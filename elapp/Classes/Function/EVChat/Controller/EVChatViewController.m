//
//  EVChatViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVChatViewController.h"
#import "EVChatEditView.h"
#import <PureLayout.h>
#import "SRRefreshView.h"
#import "UIView+Utils.h"
#import "EVEaseMob.h"
#import "EVNotifyConversationItem.h"
#import "EVMessageItem.h"
#import "EVChatMessageCell.h"
#import "EVAlertManager.h"
#import "EVLocationViewController.h"
#import "EMCDDeviceManager.h"
#import <AVFoundation/AVFoundation.h>
#import "EVLiveViewController.h"
#import "EVChatVoiceAnimationView.h"
#import "AppDelegate.h"
#import "EVLoginInfo.h"
#import "EVOtherPersonViewController.h"
#import "EVChooseChatterViewController.h"
#import "NSDate+Category.h"
#import "EVPasteImageView.h"
#import "NSString+Extension.h"
#import "EVNavigationController.h"
#import "EVAccountPhoneBindViewController.h"
#import "EVStreamer+Extension.h"
#import "NSObject+Extension.h"
#import "UIViewController+Extension.h"
#import "UIBarButtonItem+CCNavigationRight.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"

#define FOCUSVIEW_HEIGHT 50

#define SECTION_LOAD_MESSAGE_COUNT 15

@interface EVChatViewController ()<SRRefreshDelegate, UITableViewDelegate, UITableViewDataSource,CCChatEditViewDelegate,EMChatManagerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationViewDelegate, CCChatMessageCellDelegate, EVOtherPersonViewControllerDelegate, EMCDDeviceManagerDelegate, CCLiveViewControllerDelegate,CCChooseChatterDelegate>
{
    BOOL _isPlayingAudio;
    EMConversationType _conversationType;
    NSInteger handleMsgCount; // 处理消息的条数(无论发送或接收)
    
    BOOL _viewPrepare;
}
@property (strong, nonatomic) SRRefreshView *slimeView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) UITableView *tableView;
@property (nonatomic,weak) EVChatVoiceAnimationView *animationView;
@property (nonatomic,weak) EVChatEditView *editView;
@property (nonatomic,strong) EVLoginInfo *currUserInfo;
@property (nonatomic,weak) EVChatMessageCell *preAnimationCell;
@property (nonatomic,weak) NSLayoutConstraint *focusViewTopContraint;
@property (nonatomic,weak) UIView *focusView;
@property (nonatomic,strong) EVBaseToolManager *engine;
@property (nonatomic,weak) NSLayoutConstraint *editviewBottom;
@property (copy, nonatomic) NSString *msgText;
@property ( strong, nonatomic ) EVMessageItem *selectedMsgItem;
@property ( strong, nonatomic ) NSDate *chatTagDate;
@property ( strong, nonatomic ) NSArray *memberNames;
@property ( strong, nonatomic ) NSArray *friendsarray;
@property (assign, nonatomic) BOOL startLive;
@property ( strong, nonatomic ) UIMenuItem *pasteImageItem;

@end

@implementation EVChatViewController

- (instancetype)init
{
    if ( self = [super init] )
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (EVBaseToolManager *)engine
{
    if ( _engine == nil )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

- (NSDate *)chatTagDate
{
    if (_chatTagDate == nil) {
        _chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:0];
    }
    
    return _chatTagDate;
}

- (NSString *)chatter
{
    if ( _chatter == nil )
    {
        _chatter = self.conversationItem.conversation.chatter;
    }
    return _chatter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpView];
    
    // 获取好友聊天记录
    [self loadMessages];
    [self setUpNotification];
}

- (void)memberNamesForChatter:(NSString *)chatter members:(NSArray *)members completion: (void(^)(NSArray *friendsarray,NSArray *memberNames))completion
{
    if ( members.count > 0 )
    {
        NSMutableArray *nameArray = [NSMutableArray array];
        self.memberNames = nameArray;
        self.friendsarray = members;
        if ( completion )
        {
            completion(members,nameArray);
        }
    }
}

- (void)memberNamesForChatter:(NSString *)chatter completion: (void(^)(NSArray *friendsarray,NSArray *memberNames))completion
{
    if ( self.memberNames.count > 0 )
    {
        if ( completion )
        {
            completion(self.friendsarray,self.memberNames);
        }
    }
    else
    {

    }
}

- (void)dealloc
{
    [self leaveRoom];
    [CCNotificationCenter removeObserver:self];
    [_engine cancelAllOperation];
    _viewPrepare = NO;
    [_slimeView endRefresh];
    [_slimeView removeFromSuperview];
    _slimeView = nil;
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
}

- (void)leaveRoom
{
    [EVEaseMob setChatManagerDelegate:CCGetHomeViewController()];
    if ( _conversationItem.conversation.conversationType == eConversationTypeChatRoom )
    {
        NSString *chatter = [self.chatter copy];
        [[EVEaseMob sharedInstance].chatManager asyncLeaveChatroom:chatter completion:^(EMChatroom *chatroom, EMError *error){

        }];
    }
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
}

- (void)setUpNotification
{
    [CCNotificationCenter addObserver:self selector:@selector(proximitySensorChanged) name:UIDeviceProximityStateDidChangeNotification object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(userModelUpdate:) name:CCUserModelUpdateToLocalNotification object:nil];

}

#pragma mark - button  action
- (IBAction)clickFocusButton:(UIButton *)sender
{
    __weak typeof(self) wself = self;
    [self.engine GETFollowUserWithName:self.conversationItem.userModel.name followType:follow start:^{
        [CCProgressHUD showMessage:@""toView:wself.view];
        sender.userInteractionEnabled = NO;
    } fail:^(NSError *error) {
        sender.userInteractionEnabled = YES;
        [CCProgressHUD hideHUDForView:wself.view];
        [CCProgressHUD showError:kE_GlobalZH(@"noNetwork") toView:wself.view];
    } success:^{
        [CCProgressHUD hideHUDForView:wself.view];
        wself.focusViewTopContraint.constant = -FOCUSVIEW_HEIGHT;
        [UIView animateWithDuration:0.5 animations:^{
            [wself.focusView layoutIfNeeded];
        }];
        self.conversationItem.userModel.followed = YES;
        sender.userInteractionEnabled = YES;
    } essionExpire:^{
        sender.userInteractionEnabled = YES;
        CCRelogin(wself);
    }];
}

- (void)clickRightBarButtonItem
{

    EVOtherPersonViewController *other = [[EVOtherPersonViewController alloc] initWithName:self.conversationItem.userModel.name];
    other.dismissMsgBtn = YES;
    other.delegate = self;
    other.fromLivingRoom = NO;
    [self.navigationController pushViewController:other animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view endEditing:YES];
    self.editviewBottom.constant = 0;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.editView resetKeyBoard];
    
    if ( [[EMCDDeviceManager sharedInstance] isPlaying] )
    {
        [[EMCDDeviceManager sharedInstance] stopPlaying];
    }
}

- (void)setUpView
{
    _viewPrepare = YES;
  
    self.title = self.conversationItem.userModel.nickname;
    
   
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightBarButtonItemWithTitle:kE_GlobalZH(@"e_data") textColor:nil target:self action:@selector(clickRightBarButtonItem)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor evSecondColor]} forState:(UIControlStateNormal)];
    
    self.view.backgroundColor = [UIColor evBackgroundColor];
    EVChatEditView *editView = [[EVChatEditView alloc] init];
    editView.textColor = [UIColor blackColor];
    self.editView = editView;
    editView.delegate = self;
    [self.view addSubview:editView];
    self.editviewBottom = [editView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [editView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [editView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    editView.heightContraint = [editView autoSetDimension:ALDimensionHeight toSize:CCChatEditView_DEFAULT_HEIGHT];
    
    //  提示框
    UIView *focusView = [[[NSBundle mainBundle] loadNibNamed:@"EVPromptFocusView" owner:self options:nil] firstObject];
    [self.view addSubview:focusView];
    [focusView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [focusView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [focusView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    CGFloat focusViewHeight = FOCUSVIEW_HEIGHT;
    [focusView autoSetDimension:ALDimensionHeight toSize:focusViewHeight];
    self.focusView = focusView;
  
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor evBackgroundColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    [tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [tableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [tableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:editView];
    tableView.frame = CGRectMake(0, focusView.bottom, ScreenWidth, editView.top);
    [tableView addSubview:self.slimeView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTableView)];
    [tableView addGestureRecognizer:tap];
    
    EVChatVoiceAnimationView *animationView = [[EVChatVoiceAnimationView alloc] init];
    [self.view addSubview:animationView];
    self.animationView = animationView;
    [animationView autoSetDimensionsToSize:CGSizeMake(150, 150)];
    [animationView autoCenterInSuperview];
    animationView.state = CCChatVoiceAnimationViewHidden;
    
}
//// 隐藏关注视图
//- (void)hideFocusView
//{
//    self.focusViewTopContraint.constant =  -FOCUSVIEW_HEIGHT;
//}
//  显示关注视图
- (void)showFocusView
{
    [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
        [_focusView layoutIfNeeded];
        self.focusViewTopContraint.constant = 0;
    } completion:^(BOOL finished) {
        self.focusViewTopContraint.constant = 0;
    }];
}

//  获取聊天记录
- (void)loadMessages
{
    EVMessageItem * firstAtItem = nil;
    self.currUserInfo = [EVLoginInfo localObject];
    //  注册环信消息管理者代理
    [EVEaseMob setChatManagerDelegate:self];
    EMConversation *conversation = nil;
   
    conversation = self.conversationItem.conversation;
    
    for (EMMessage *msg in [conversation loadNumbersOfMessages:SECTION_LOAD_MESSAGE_COUNT<self.unread?self.unread:SECTION_LOAD_MESSAGE_COUNT before:[[NSDate date] timeIntervalSince1970] * 1000])
    {
        EVMessageItem *messageItem = [[EVMessageItem alloc] initWith:msg];
        [self showTimeWithMessageItem:messageItem];
        [messageItem cellHeight];
        [self.dataArray addObject:messageItem];
        if ( _hasAt && !firstAtItem  && !msg.isRead)
        {
            firstAtItem = messageItem;
        }
        [self markNotVoiceMessageAsRead:msg];
    }
 
    [self.tableView reloadData];
    if ( _hasAt )
    {
        NSIndexPath * scrollToPath = [NSIndexPath indexPathForRow:[self.dataArray indexOfObject:firstAtItem] inSection:0];
        [self.tableView scrollToRowAtIndexPath:scrollToPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else if ( self.dataArray.count > 1 )
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(NSInteger)self.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}


#pragma mark - notification
- (void)userModelUpdate:(NSNotification *)notification
{
    EVUserModel *userModel = notification.userInfo[CCUpdateUserModel];
    if ( [self.conversationItem.userModel.name isEqualToString:userModel.name] )
    {
        self.conversationItem.userModel = userModel;
        self.title = userModel.nickname;
    }
}

#pragma mark - 环信 delegate
- (void)didReceiveMessage:(EMMessage *)message
{
    [self handeMessage:message];
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    for (EMMessage *message in offlineMessages) {
        [self handeMessage:message];
    }
}

- (void)willSendMessage:(EMMessage *)message error:(EMError *)error
{
    if ( ![message.to isEqualToString:self.chatter] )
    {
        return;
    }
    [self.tableView reloadData];
}

- (void)didSendMessage:(EMMessage *)message error:(EMError *)error
{
    if ( ![message.to isEqualToString:self.chatter] )
    {
        return;
    }
    if (!error)
    {
        message.deliveryState = eMessageDeliveryState_Delivered;
    }
    else
    {
        message.deliveryState = eMessageDeliveryState_Failure;
    }
    [self.tableView reloadData];
}

- (void)handeMessage:(EMMessage *)msg
{
    if ((![msg.from isEqualToString:self.chatter]) || ([msg.from isEqualToString: msg.to])) {
        return;
    }
    
    [EVEaseMob checkApplicationStateWithMessage:msg];
    EVMessageItem *messageItem = [[EVMessageItem alloc] initWith:msg];
    messageItem.messageFrom = CCMessageFromReceive;
    [self showTimeWithMessageItem:messageItem];
    [self.dataArray addObject:messageItem];
 
    [self reloadDataWithMessage:msg];
    
}

- (void)reloadDataWithMessage:(EMMessage *)msg
{
    [self.tableView reloadData];
    [self markNotVoiceMessageAsRead:msg];
    if ( self.dataArray.count > 1 )
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    // 将会话信息写入本地数据库
    [self conversationItemWriteToLocal];
}

// 计算是否需要显示时间
- (void)showTimeWithMessageItem:(EVMessageItem *)item
{
        EMMessage *message = item.message;
        NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
        NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
        if (tempDate > 60 || tempDate < - 60 || (self.chatTagDate == nil)) {
            item.createTime = [createDate minuteDescription];
            item.showTime = YES;
            self.chatTagDate = createDate;
        }
}

- (void)markNotVoiceMessageAsRead:(EMMessage *)msg
{
    if (msg.isRead) {
        return;
    }
    id <IEMMessageBody> body = msg.messageBodies.firstObject;
    //  如果是语言消息先不标记已读
    if ( [body messageBodyType] != eMessageBodyType_Voice )
    {
        [self.conversationItem.conversation markMessageWithId:msg.messageId asRead:YES];
    }
   
    [CCNotificationCenter postNotificationName:CCIMConversationHasReadNotification object:nil userInfo:@{CCIMConversationModelKey:self.conversationItem}];
    
   
        
}

- (void)didLoginFromOtherDevice
{
    [EVBaseToolManager setIMAccountHasLogin:NO];
    
    [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kAccountOtherDeviceLogin cancelButtonTitle:kCancel comfirmTitle:kAgainLogin WithComfirm:^{
        [EVLoginInfo cleanLoginInfo];
        [EVBaseToolManager resetSession];
        [self reLogin];
    } cancel:nil];
}

- (void)reLogin
{
    __weak typeof(self) wself = self;
    [EVBaseToolManager checkSession:^{
        [CCProgressHUD showMessage:@"" toView:wself.view];
    } completet:^(BOOL expire) {
        [CCProgressHUD hideHUDForView:wself.view];
        if ( expire )
        {
            CCRelogin(wself);
        }
        else
        {
            [wself reloginIm];
        }
        [CCUserDefault setObject:nil forKey:SESSION_ID_STR];
    } fail:^(NSError *error) {
        [CCProgressHUD hideHUDForView:wself.view];
        [CCProgressHUD showError:kNoNetworking toView:wself.view];
    }];
}

- (void)reloginIm
{
    __weak typeof(self) wself = self;
    [EVEaseMob checkAndAutoReloginWithLoginInfo:nil imHasLogin:^(EVLoginInfo *loginInfo) {

    } loginSuccess:^(EVLoginInfo *login) {
        [wself loadMessages];
    } loginFail:^(EMError *error) {
        [CCProgressHUD showError:[NSString stringWithFormat:@"%@%ld",kNot_newwork_service, error.errorCode] toView:wself.view];
    } sessionExpire:^{
        [CCProgressHUD showError:kNot_newwork_service toView:wself.view];
    } needRegistIM:^{
        [CCProgressHUD showError:kNot_newwork_service toView:wself.view];
    }];
}

#pragma mark - EVOtherPersonViewControllerDelegate

- (void)modifyUserModel:(EVUserModel *)userModel
{
    if ( userModel.followed )
    {
//        [self hideFocusView];
    }
    else
    {
        self.focusViewTopContraint.constant = FOCUSVIEW_HEIGHT;
        [self showFocusView];
    }
}

#pragma mark -  getter
- (SRRefreshView *)slimeView
{
    if ( !_viewPrepare )
    {
        return nil;
    }
    if (_slimeView == nil)
    {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIMenuItem *)pasteImageItem
{
    if ( _pasteImageItem == nil )
    {
        _pasteImageItem = [[UIMenuItem alloc] initWithTitle:kE_GlobalZH(@"e_stick") action:@selector(pasteImage:)];
    }
    return _pasteImageItem;
}


#pragma mark - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_slimeView)
    {
        [_slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_slimeView)
    {
        [_slimeView scrollViewDidEndDraging];
    }
}


#pragma mark - CCChatEditViewDelegate
- (void)chatEditView:(EVChatEditView *)editView keyBoardFrameDidChage:(CGRect)keyBoardFrame animationTime:(NSTimeInterval)time
{

    CGFloat keyBoardY = keyBoardFrame.origin.y;
    CGFloat bottom = 0;
    CGRect frame = self.view.frame;
    if ( keyBoardY == ScreenHeight )
    {
        frame.origin.y = 64;
    }
    else
    {
        frame.origin.y = - keyBoardFrame.size.height + 64;
        bottom = -keyBoardFrame.size.height;
    }
    
    CGSize contentSize = self.tableView.contentSize;

    if ( contentSize.height < 0.4 * ScreenHeight )
    {
        self.editviewBottom.constant = bottom;
        [UIView animateWithDuration:time animations:^{
            [self.editView layoutIfNeeded];
        }];
    }
    else
    {
        self.editviewBottom.constant = 0;
        [UIView animateWithDuration:time animations:^{
            self.view.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }

}


#pragma mark - CCOpenRedEnvelopeDelegate
- (void)openSuccess:(NSDictionary *)retval
{
    
    NSArray * openlist = retval[@"openlist"];
    NSInteger openEcoin = 0;
    for (NSDictionary * openDic in openlist) {
        openEcoin += [openDic[@"value"] integerValue];
    }
    
    
}

- (void)seeLuck:(NSDictionary *)retval
{
    EVLoginInfo * loginInfo = [EVLoginInfo localObject];
    NSArray * openlist = retval[@"openlist"];
    NSInteger openEcoin = 0;
    NSInteger openValue = 0;
    for (NSDictionary * openDic in openlist) {
        openEcoin += [openDic[@"value"] integerValue];
        if ([loginInfo.name isEqualToString:openDic[@"name"]]) {
            openValue = [openDic[@"value"] integerValue];
        }
    }
    
}

#pragma mark - CCChatMessageCellDelegate
- (void)chatMessageCell:(EVChatMessageCell *)cell didClickCellType:(NSInteger)type
{
    EVMessageItem *item = cell.messageItem;
    switch ( type )
    {
        case CCChatMessageCell_VOICE:
        {
            [self playVoiceWith:item withMessageCell:cell];
        }
            break;

            
        case CCChatMessageCell_SEND_AGAIN:
            [[EVEaseMob cc_shareInstance].chatManager asyncSendMessage:cell.messageItem.message progress:nil];
            break;
            
        default:
            break;
    }
}

- (void)chatMessageCell:(EVChatMessageCell *)cell didClickHeaderType:(NSInteger)messageFrom
{
    if ( messageFrom == CCMessageFromSend )  // 用户自己
    {
        [CCProgressHUD showError:kE_GlobalZH(@"is_self") toView:self.view];
    }
    else                                     // 与用户聊天的人
    {
        EVOtherPersonViewController *other = nil;
        NSString *name = self.conversationItem.userModel.name;
        other = [[EVOtherPersonViewController alloc] initWithName:name];
        other.dismissMsgBtn = YES;
        other.delegate = self;
        other.fromLivingRoom = NO;
        [self.navigationController pushViewController:other animated:YES];
    }
}

- (void)chatMessageCell:(EVChatMessageCell *)cell didLongPressedHeaderType:(NSInteger)messageFrom
{
    if ( messageFrom == CCMessageFromSend )
    {
        [CCProgressHUD showError:kE_GlobalZH(@"is_self") toView:self.view];
    }
}

#pragma mark - 点击cell上的内容
- (void)playVoiceWith:(EVMessageItem *)item withMessageCell:(EVChatMessageCell *)cell
{
    //  如果是接受到的语音 标记为已读
    if ( item.messageFrom == CCMessageFromReceive && item.isRead == NO )
    {
        BOOL hasRead = [self.conversationItem.conversation markMessageWithId:item.message.messageId asRead:YES];
        if (hasRead)
        {
            [CCNotificationCenter postNotificationName:CCIMConversationHasReadNotification object:nil userInfo:@{CCIMConversationModelKey:self.conversationItem}];
        }
    }
    [self.preAnimationCell stopVoiceAniamtion];
    id <IEMFileMessageBody> body = [item.message.messageBodies firstObject];
    EMAttachmentDownloadStatus downloadStatus = [body attachmentDownloadStatus];
    if (downloadStatus == EMAttachmentDownloading) {
        [CCProgressHUD showError:kE_GlobalZH(@"download_voice") toView:self.view];
        return;
    }
    else if (downloadStatus == EMAttachmentDownloadFailure)
    {
        [[EaseMob sharedInstance].chatManager asyncFetchMessage:item.message progress:nil];
        [CCProgressHUD showError:kE_GlobalZH(@"download_voice_fail") toView:self.view];
        return;
    }

    [[EVEaseMob cc_shareInstance] sendHasReadResponseForMessages:@[item.message]];
    __weak typeof(self) wself = self;
    [[EMCDDeviceManager sharedInstance] enableProximitySensor];
    [cell startVoiceAniamtion];
    [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:item.voiceLocationPath completion:^(NSError *error) {
        if ( error )
        {
            [CCProgressHUD showError:kE_GlobalZH(@"play_voice_fail") toView:wself.view];
        }
// fix by 杨尚彬 线程同步问题
        [self performBlockOnMainThread:^{
            [cell stopVoiceAniamtion];
            //  如果是接受到的语音 刷新当前行去掉红点
            if ( item.messageFrom == CCMessageFromReceive && item.isRead == NO )
            {
                NSIndexPath *indexPath = [wself.tableView indexPathForCell:cell];
                
                [wself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            [[EMCDDeviceManager sharedInstance] disableProximitySensor];
        }];
    }];
    self.preAnimationCell = cell;
}

#pragma mark - EMCDDeviceManagerDelegate 听筒模式
- (void)proximitySensorChanged
{
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    }
    else
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

#pragma mark - CCChatEditViewDelegate

- (void)chatEditView:(EVChatEditView *)editView buttonDidClicked:(NSInteger)buttonType
{
    switch ( buttonType )
    {
        case CCChatEditView_TAG_SEND:
        {
            NSString *text = editView.text;
            if ( text.length == 0 )
            {
                [CCProgressHUD showError:kE_GlobalZH(@"send_content_not_nil") toView:self.view];
                return;
            }
            [self sendMessageWithText:editView.text];
        }
            break;
            
        case CCChatEditView_TAG_PHOTO:
            [self addOpenLibrary];
            break;
            
        case CCChatEditView_TAG_TAKE_PHOTO:
        {
            [EVStreamer  requestCameraAuthedUserAuthed:^{
                [self addCarema];
            } userDeny:nil];
        }
            break;
        
            
        case CCChatEditView_TAG_SPEAK_START:
        {
            if ( [CCAppSetting shareInstance].appstate == CCEasyvaasAppStateLiving )
            {
                [CCProgressHUD showError:kE_GlobalZH(@"current_watch_status") toView:self.view];
                return;
            }
            
            [EVStreamer requestMicPhoneAuthedUserAuthed:^{
                [self startRecordVoice];
            } userDeny:nil];
        }
            break;
            
        case CCChatEditView_TAG_SPEAK_END:
            if ( [CCAppSetting shareInstance].appstate == CCEasyvaasAppStateLiving )
            {
                return;
            }
            [self endRecordVoice];
            break;
            
        case CCChatEditView_TAG_SPEAK_CANCEL:
            if ( [CCAppSetting shareInstance].appstate == CCEasyvaasAppStateLiving )
            {
                return;
            }
            [self cancelRecordVioce];
            break; 
        case CCChatEditView_TAG_SPEAK_DRAG_IN:
            self.animationView.state = CCChatVoiceAnimationViewHoldOn;
            break;
            
        case CCChatEditView_TAG_SPEAK_DRAG_OUT:
            self.animationView.state = CCChatVoiceAnimationViewSliderUp;
            break;
            
     
            
        default:
            break;
    }
}


- (void)chatEditView:(EVChatEditView *)editView textViewShouldBeginEditing:(UITextView *)textView
{
    if ( [UIPasteboard generalPasteboard].image )
    {
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:@[self.pasteImageItem]];
    }
    else
    {
        [[UIMenuController sharedMenuController] setMenuItems:nil];
    }
}

- (void)removeLastNickNameWithTextView:(EVChatTextView *)textView
{
    NSMutableString *newText = [textView.text mutableCopy];
    // 获取光标位置
    NSRange cursorRange = textView.selectedRange;
    NSUInteger cursorLocation = cursorRange.location;
    // 获取光标前面的字符串
    NSString *strBeforeCursor = [textView.text substringToIndex:cursorLocation];
    // 获取光标之前最后一个@后的字符串
    NSArray *subArray = [strBeforeCursor componentsSeparatedByString:@"@"];
    if ( subArray.count > 1 )
    {
        NSString *laststr = [subArray lastObject];
        NSMutableArray *atNicknames = [NSMutableArray array];
        NSInteger deleteIndex = 0;

        if ( [atNicknames containsObject:laststr] )
        {
            [newText deleteCharactersInRange:NSMakeRange(cursorLocation - laststr.length - 1, laststr.length + 1)];
            textView.text = newText;
            deleteIndex = [atNicknames indexOfObject:laststr];
            textView.selectedRange = NSMakeRange(cursorLocation - laststr.length - 1, 0);
        }
    }
}


- (void) chatEditView:(EVChatEditView *)editView didChange:(EVChatTextView *)textView
{

    // 删除最后一个昵称
    [self removeLastNickNameWithTextView:textView];
    
    // 如果textview的最后一个字符是@,就进入下一页
    if ( [[textView.text substringWithRange:NSMakeRange(textView.text.length - 1, 1)] isEqualToString:@"@"])
    {
    
    }
}

#pragma mark - CCLiveViewControllerDelegate
- (void)liveDidStart:(EVLiveViewController *)liveVC info:(NSDictionary *)userInfo
{
    NSString *vid = userInfo[kVid];
    UIImage *thumb = userInfo[kThumb];
    if ( vid && thumb )
    {
        [self sendMessageWithImage:thumb ext:@{kVid : vid}];
    }
}


- (void)sendVideoWithMemberNames:(NSArray *)names
{
    EVLiveViewController *liveVC = [[EVLiveViewController alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kAllowname_list] = names;
    liveVC.liveParams = params;
    liveVC.foreCapture = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:liveVC];
    [self presentViewController:nav animated:YES completion:^{
        self.startLive = YES;
    }];
    liveVC.delegate = self;
}

- (void)sendMessageWithText:(NSString *)text
{
    NSDictionary *extDic = nil;
  
    EMMessage *msg = [EVEaseMob sendTextMessageWithString:text toUsername:self.chatter isChatGroup:NO requireEncryption:MESSAGE_Encrypt ext:extDic];
    [self handelSendMessage:msg];
    // 清空@信息

}

- (void)sendMessageWithImage:(UIImage *)image ext:(NSDictionary *)ext
{
    EMMessage *message = [EVEaseMob sendImageMessageWithImage:image toUsername:self.chatter isChatGroup:NO requireEncryption:NO ext:ext];
    [self handelSendMessage:message];
}

- (void)sendAudioMessage:(EMChatVoice *)voice
{
    EMMessageType type = eMessageTypeChat;
    EMMessage *tempMessage = [EVEaseMob sendVoice:voice
                                            toUsername:self.chatter
                                      messageType:type
                                     requireEncryption:NO ext:nil];
    [self handelSendMessage:tempMessage];
}

- (void)handelSendMessage:(EMMessage *)message
{
    EVMessageItem *item = [[EVMessageItem alloc] initWith:message];
    [self showTimeWithMessageItem:item];
    [self.dataArray addObject:item];
    [self.tableView reloadData];
    if ( self.dataArray.count > 1 )
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(NSInteger)self.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    // 将会话信息写入本地数据库
    [self conversationItemWriteToLocal];
}

- (void)conversationItemWriteToLocal
{
    handleMsgCount ++;
    if ( handleMsgCount == 1 )
    {
        [self.conversationItem updateToLocalCacheComplete:NULL];
    }
}

- (EMMessageType)messageType
{
    EMMessageType type = eMessageTypeChat;
    switch (_conversationType) {
        case eConversationTypeChat:
            type = eMessageTypeChat;
            break;
        case eConversationTypeGroupChat:
            type = eMessageTypeGroupChat;
            break;
        case eConversationTypeChatRoom:
            type = eMessageTypeChatRoom;
            break;
        default:
            break;
    }
    return type;
}

#pragma mark - LocationViewDelegate
-(void)sendLocationLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address
{
    EMMessage *message = [EVEaseMob sendLocationLatitude:latitude longitude:longitude address:address toUsername:self.chatter isChatGroup:NO requireEncryption:MESSAGE_Encrypt ext:nil];
    [self handelSendMessage:message];
}

#pragma mark - voice Record
- (void)startRecordVoice
{
    self.animationView.hidden = NO;
    self.animationView.state = CCChatVoiceAnimationViewHoldOn;
    if ( ![self canRecord] )
    {
        [CCProgressHUD showError:kE_GlobalZH(@"mike_fail") toView:self.view];
        return;
    }
    int x = arc4random() % 100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
    __weak typeof(self) wself = self;
    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error) {
        [self performBlockOnMainThread:^{
            if ( error )
            {
                [CCProgressHUD showError:kE_GlobalZH(@"mike_init_fail_again") toView:wself.view];
            }
        }];
    }];
}

- (void)endRecordVoice
{
    self.animationView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        [self performBlockOnMainThread:^{
            if (!error)
            {
                EMChatVoice *voice = [[EMChatVoice alloc] initWithFile:recordPath
                                                           displayName:@"audio"];
                voice.duration = aDuration;
                [weakSelf sendAudioMessage:voice];
            }
            else
            {
                [CCProgressHUD showError:kE_GlobalZH(@"time_very_short") toView:weakSelf.view];
            }

        }];
    }];
}

- (void)cancelRecordVioce
{
    self.animationView.hidden = YES;
    self.animationView.state = CCChatVoiceAnimationViewHidden;
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
}

- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    return bCanRecord;
}

#pragma mark - select a image
- (void)addCarema
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTooltip message:kE_GlobalZH(@"you_device_camera") delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerOriginalImage];

    if ( editImage == nil )
    {
        [CCProgressHUD showError:kE_GlobalZH(@"checking_image_save_photo")];
    }
    else
    {
        [self sendMessageWithImage:editImage ext:nil];
    }
}

- (void)addOpenLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;

        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}


#pragma mark - slimeRefresh delegate
//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    //  加载信息
    EVMessageItem *messageItem = [self.dataArray firstObject];
    
    NSArray *result = [self.conversationItem.conversation loadNumbersOfMessages:SECTION_LOAD_MESSAGE_COUNT withMessageId:messageItem.message.messageId];
    NSInteger currCount = result.count;
    for (NSInteger i = currCount - 1; i >= 0; i --)
    {
        EMMessage *msg = [result objectAtIndex:i];
        EVMessageItem *messageItem = [[EVMessageItem alloc] initWith:msg];
        if ( ![self.dataArray containsObject:messageItem] )
        {
            [self showTimeWithMessageItem:messageItem];
            [messageItem cellHeight];
            [self.dataArray insertObject:messageItem atIndex:0];
            currCount--;
        }
    }
    
    [self.tableView reloadData];
    
    //  停止刷新
    [_slimeView endRefresh];
    
    if ( currCount == result.count )
    {
        __weak SRRefreshView *wslimeView = _slimeView;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wslimeView removeFromSuperview];
        });
        
    }
}

#pragma mark - table delegate 

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[EVChatMessageCell cellId]];
    if (!cell) {
        cell = [[EVChatMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[EVChatMessageCell cellId]];
        cell.delegate = self;
    }
    EVMessageItem *item = self.dataArray[indexPath.row];
    if ( item.messageFrom == CCMessageFromSend )
    {
        item.logourl = self.currUserInfo.logourl;
    }
    else
    {
       
        item.logourl = self.conversationItem.userModel.logourl;
    }
    
    cell.messageItem = item;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVMessageItem *item = self.dataArray[indexPath.row];
    return item.cellHeight;
}

#pragma mark -

- (void)tapTableView
{
    // 隐藏菜单
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    [self.view endEditing:YES];
}

#pragma mark - 绑定手机号
// 直播需要绑定手机, 请监听改回调
- (void)liveNeedToBindPhone:(EVLiveViewController *)liveVC
{
    EVAccountPhoneBindViewController *phoneBindVC = [EVAccountPhoneBindViewController accountPhoneBindViewController];
    EVRelationWith3rdAccoutModel *model = [[EVRelationWith3rdAccoutModel alloc] init];
    model.type = @"phone";
    [self presentViewController:phoneBindVC animated:YES completion:nil];
}


#pragma mark - 点击菜单的代理方法
- (void)chatMessageCell:(EVChatMessageCell *)cell didClickRelayMenuWithItem:(EVMessageItem *)msgItem
{
    EVChooseChatterViewController *chooseVC = [[EVChooseChatterViewController alloc] init];
    
    chooseVC.delegate = self;
    
    if ( msgItem.messageType == CCMessageImage )
    {
        UIImage *image = [UIImage imageWithContentsOfFile:msgItem.localImagePath];
        EMChatImage *chatImage = [[EMChatImage alloc] initWithUIImage:image displayName:@"image.jpg"];
        EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithImage:chatImage thumbnailImage:nil];
        
        chooseVC.relayMsgBodies = @[body];
        chooseVC.ext = msgItem.ext;
    }
    if ( msgItem.messageType == CCMessageVoice )
    {
        EMChatVoice *voice = [[EMChatVoice alloc] initWithFile:msgItem.voiceLocationPath displayName:@"voice"];
        voice.duration = msgItem.time;
        EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithChatObject:voice];
        chooseVC.relayMsgBodies = @[body];
    }
    
    if ( msgItem.messageType == CCMessageText )
    {
        chooseVC.relayMsgBodies = msgItem.message.messageBodies;
    }
    
    EVNavigationController *chooseNaviController = [[EVNavigationController alloc] initWithRootViewController:chooseVC];
    [self presentViewController:chooseNaviController animated:YES completion:NULL];

}

- (void)chatMessageCell:(EVChatMessageCell *)cell didClickDeleteMenuWithItem:(EVMessageItem *)msgItem
{
    // 获取选中的行数
    NSInteger row = [self.dataArray indexOfObject:msgItem];
    
    // 如果是删除最后一条让代理执行删除最后一行的方法
    if ( (row == (NSInteger)self.dataArray.count - 1) && self.delegate && [self.delegate respondsToSelector:@selector(chatViewController:didDeleteLastMessage:)] )
    {
        // 删除后的最后一个信息
        EVMessageItem *lastItem = nil;
        if ( row > 0 )
        {
            lastItem = [self.dataArray objectAtIndex:row - 1];
        }
        [self.delegate chatViewController:self didDeleteLastMessage:lastItem.message];
    }
    
    // 获取当前消息
    EMMessage *msg = msgItem.message;
    
    // 从数据源中删除当前行
    [self.dataArray removeObject:msgItem];
    
    
 
    [self.conversationItem.conversation removeMessageWithId:msg.messageId];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    // 删除当前行
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // 刷新 否则有可能造成crash
    [self.tableView reloadData];

}

// 粘贴图片
- (void)pasteImage:(id)sender
{
    [self.editView backKeyBoard];
    __weak typeof(self) weakSelf = self;
    [[[EVPasteImageView alloc] init] showPasteImageView:^(UIImage *image) {
        [weakSelf sendMessageWithImage:image ext:nil];
    }];
}

#pragma mark - 转发消息结束的代理方法

- (void)relayCompleteMessage:(EMMessage *)message
{
    //  如果是转发给当前对话的就添加一行
    if ( [message.to isEqualToString:self.chatter] )
    {
        [self performSelector:@selector(handelSendMessage:) withObject:message afterDelay:0.5];
    }
}

@end
