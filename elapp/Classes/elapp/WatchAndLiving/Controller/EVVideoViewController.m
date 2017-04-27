//
//  EVVideoViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVVideoViewController.h"
#import <PureLayout.h>
#import "NSString+Extension.h"
#import "EVNewLiveViewController.h"
#import "EVLoginInfo.h"
#import "EVBaseToolManager.h"
#import "EVNotifyConversationItem.h"
#import "EVOtherPersonViewController.h"
#import "EVAudienceCollectionView.h"
#import "EVAudienceCell.h"
#import "EVAudience.h"
#import "EVAlertManager.h"
#import "UIScrollView+GifRefresh.h"
#import "EVAudienceUserJoinView.h"
#import "EVAudienceCommentUnreadButton.h"
#import "EVCommentCell.h"
#import "EVRedEnvelopeModel.h"
#import "EVRedEnvelopeView.h"
#import "EVFantuanContributionListVC.h"
#import "AppDelegate.h"
#import "EVPromptRedPacketView.h"
#import "EVManagerUserView.h"
#import "EVMngUserListController.h"
#import "EVLiveTipsLabel.h"
#import "EVDanmuSwitch.h"
#import "EVYunBiViewController.h"
#import "EVUserAsset.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVMessageManager.h"
#import "EVSDKLiveMessageEngine.h"
#import "EVDanmuManager.h"
#import "EVSDKLiveEngineParams.h"
#import "EVLiveEvents.h"
#import "EVLiveWatchManager.h"
#import "EVVideoViewProtocol.h"
#import "EVWatchBottomItemView.h"



#define EVAudienceInfoVIEW_HEIGHT 37
#define kDefaultAudienceCellMarign 8

@implementation EVContentView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.hidden && self.alpha > 0) {
        for (UIView *subview in self.subviews.reverseObjectEnumerator) {
            CGPoint subPoint = [subview convertPoint:point fromView:self];
            UIView *result = [subview hitTest:subPoint withEvent:event];
            if (result != nil) {
                return result;
            }
        }
    }
    
    return self;
}

@end

@interface EVVideoViewController () <CCAudienceChatTextViewDelegate, CCAudiencceInfoViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate,CCCommentCellDelegate, CCRiceAmountViewDelegate, CCPresentViewDelegate, EVReportResonViewDelegate,CCPromptRedPacktViewDelegate,AlertDelegate,CCMagicEmojiViewDelegate,EVYiBiViewControllerDelegate, MngUserListDelegate,EVSDKMessageDelegate,EVDanmuDelegate,EVOtherPersonViewControllerDelegate,EVVideoViewProtocol,EVHVLiveTopViewDelegate>

/** 所有的红包 */
@property (nonatomic,strong) NSMutableDictionary *allRedEnvelope;

/** 观众 */
@property ( nonatomic, strong) NSMutableArray *audiences;

/** 评论列表是否正在滑动 */
@property ( nonatomic ) BOOL scrolling;

/** 第一次加载评论 */
@property ( nonatomic ) BOOL firstLoadComment;

/** 已经没有更多评论了 */
@property (nonatomic, assign) BOOL noMoreComments;

/** 未读消息条数 */
@property (nonatomic, assign) NSInteger unreadCommentNum;

/** 网络请求工具 */
@property (nonatomic, weak) EVBaseToolManager *engine;

/** 评论 */
@property ( nonatomic, strong ) NSMutableArray<EVComment *> *comments;


@property (nonatomic , strong) EVComment *replayComment;

// MARK: subviews
/** 显示内容的view */
@property ( nonatomic, weak ) EVContentView *contentView;

/** 滑屏 */
@property ( nonatomic, weak ) UIScrollView *slidScrollView;

/** 文字输入 */
@property ( nonatomic, weak ) EVAudienceChatTextView *chatTextView;

/** 聊天容器 */
@property ( nonatomic, weak ) UIView *chatContainerView;

/** 观众列表 */
@property (nonatomic, weak)  EVAudienceCollectionView *audiencesList;

/** 评论列表 */
@property ( nonatomic, weak ) EVCommentTableView *commentTableView;

@property ( nonatomic, weak ) NSLayoutConstraint *commentTableHeightConstraint;

/** 提示用户进入的view */
@property ( nonatomic, weak ) EVAudienceUserJoinView *joinView;

/** 提示未读消息 */
@property ( nonatomic, weak ) EVAudienceCommentUnreadButton *unreadBtn;

/** 主播云票数量 */
@property ( nonatomic, weak ) EVRiceAmountView *riceAmountView;

@property ( nonatomic, weak ) NSLayoutConstraint *riceTopConstraint;

/** 收到礼物提示 */
@property (nonatomic, weak) EVPresentView *presentView;

/** 礼物动画 */
@property (nonatomic, weak) EVCenterPresentView *presentAnimatingView;

/** 观众信息浮动窗口 */
@property ( weak, nonatomic ) EVFloatingView *floatView;


/** 云票下面显示红包 */
@property ( nonatomic, weak ) EVPromptRedPacketView *promptRedPacketView;

@property (nonatomic, weak) EVDanmuSwitch *danmuSwitch;

@property (nonatomic, weak) NSMutableArray *redPackageArray;

@property (nonatomic, weak) EVDanmuManager *danmuManager;


@property (nonatomic, strong) NSMutableArray *allGiftArray;


@property (nonatomic, copy) NSString *oldHid;



@property (nonatomic, weak) UILabel *watchNumL;
@end

@implementation EVVideoViewController

#pragma mark - ***********     Life Cycle ♻️      ***********

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _allRedEnvelope = [NSMutableDictionary dictionary];
    self.sendComment = YES;
    self.firstLoadComment = YES;
    [self setUpViews];
    [self addNotificationCenter];
    self.allGiftArray = [NSMutableArray arrayWithArray:[[EVStartResourceTool shareInstance] presentsWithType:EVPresentTypePresent]];
    

}




- (void)dealloc
{
    EVLog(@"EVVideoViewController is dealloc");
    [[EVManagerUserView shareSheet] hideActionWindow];
    [[EVManagerUserView shareSheet] removeFromSuperview];
    [EVRedEnvelopeView clearData];
    [[EVMessageManager shareManager] close];
    [_allRedEnvelope removeAllObjects];
    _allRedEnvelope = nil;
    [self.commentTableView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - ***********      Build UI 🎨       ***********
// 直播状态提醒
- (void)addLiveStatusAlertView
{
    EVLiveTipsLabel *tipsLabel = [[EVLiveTipsLabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    [self.view addSubview:tipsLabel];
    self.tipsLabel = tipsLabel;
    [tipsLabel hiddenWithAnimation];
}


#pragma mark - add subviews
- (void)setUpViews
{
    self.view.backgroundColor = [UIColor blackColor];

    [self addContentView];
    [self addBottomChatView];
    [self addPresentCenterView];
    [self addTopVideoInfoView];
    [self addAudienceListView];
    [self addRiceAmountView];
    [self setUpLoadMoreComment];
    [self commentTableViewAndUserJoinView];
    [self addLiveStatusAlertView];
    [self addPresentView];
    [self addDanmuView];
    /** 礼物列表 */
    [self addPresentListView];
    [self addKeyBoardNotificationCenter];
}

// 中间展示动画
- (void)addPresentCenterView
{
    EVCenterPresentView *presentAnimatingView = [[EVCenterPresentView alloc] init];
    presentAnimatingView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:presentAnimatingView];
    [presentAnimatingView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [presentAnimatingView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [presentAnimatingView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:380];
    self.presentAnimatingView = presentAnimatingView;
    self.presentAnimatingView.hidden = YES;
}

// 提示观众发礼物
- (void)addPresentView
{
    EVPresentView *presentView = [[EVPresentView alloc] init];
    [self.contentView addSubview:presentView];
    presentView.delegate = self;
    [presentView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:245];
    [presentView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [presentView autoSetDimension:ALDimensionHeight toSize:42];
    [presentView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:80 relation:NSLayoutRelationGreaterThanOrEqual];
    self.presentView = presentView;
    presentView.hidden = YES;
}

- (void)addDanmuView
{
    EVDanmuManager *danmuManager = [[EVDanmuManager alloc]init];
    danmuManager.delegate = self;
    [self.contentView addSubview:danmuManager];
    danmuManager.hidden = YES;
    [danmuManager autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:300];
    [danmuManager autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [danmuManager autoSetDimension:ALDimensionHeight toSize:42];
    [danmuManager autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:80 relation:NSLayoutRelationGreaterThanOrEqual];
    self.danmuManager = danmuManager;
    
}

// 评论和观众进入提示
- (void)commentTableViewAndUserJoinView
{
    // 容器
//    UIView *commentAndUserJoinContainerView = [[UIView alloc] init];
//    [self.contentView addSubview:commentAndUserJoinContainerView];
//    commentAndUserJoinContainerView.backgroundColor  = [UIColor clearColor];
//    [commentAndUserJoinContainerView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
//    [commentAndUserJoinContainerView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
//    [commentAndUserJoinContainerView autoSetDimension:ALDimensionHeight toSize:190];
//    [commentAndUserJoinContainerView autoSetDimension:ALDimensionWidth toSize:ScreenHeight/2];
    // 评论列表
    EVCommentTableView *commentTableView = [[EVCommentTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    if ( IOS8_OR_LATER )
    {
        commentTableView.rowHeight = UITableViewAutomaticDimension;
    }
    commentTableView.scrollsToTop = YES;
    commentTableView.transform = CGAffineTransformMakeRotation(M_PI);
    [commentTableView hideFooter];
    commentTableView.dataSource = self;
    commentTableView.delegate = self;
    commentTableView.showsVerticalScrollIndicator = NO;
    commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    commentTableView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:commentTableView];
    self.commentTableView = commentTableView;
    commentTableView.backgroundColor  = [UIColor clearColor];
    [commentTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [commentTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [commentTableView autoSetDimension:ALDimensionHeight toSize:190];
    [commentTableView autoSetDimension:ALDimensionWidth toSize:ScreenHeight/2];
    [commentTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    // 未读消息提醒
    EVAudienceCommentUnreadButton *unreadBtn = [EVAudienceCommentUnreadButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:unreadBtn];
    [unreadBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:commentTableView];
    [unreadBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    unreadBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:0.9];
    [unreadBtn autoSetDimension:ALDimensionHeight toSize:25];
    unreadBtn.layer.cornerRadius = 3;
    [unreadBtn addTarget:self action:@selector(commentTableViewScrollToBottom) forControlEvents:UIControlEventTouchUpInside];
    unreadBtn.hidden = YES;
    _unreadBtn = unreadBtn;
}

// 观众列表
- (void)addAudienceListView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = kDefaultAudienceCellMarign;
    layout.itemSize = CGSizeMake(kCollectionViewItemSize, kCollectionViewItemSize);
    EVAudienceCollectionView *audiencesList = [[EVAudienceCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    audiencesList.backgroundColor = [UIColor clearColor];
    audiencesList.backgroundColor = [UIColor clearColor];
    audiencesList.dataSource = self;
    audiencesList.delegate = self;
    audiencesList.showsHorizontalScrollIndicator = NO;
    audiencesList.hidden = YES;
    [audiencesList registerClass:[EVAudienceCell class] forCellWithReuseIdentifier:[EVAudienceCell audienceCellID]];
    [self.contentView addSubview:audiencesList];
    self.AudienceViewConstraint = [audiencesList autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:143.0];
    [audiencesList autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:50];
    [audiencesList autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:24];
    [audiencesList autoSetDimension:ALDimensionHeight toSize:kCollectionViewItemSize];
    self.audiencesList = audiencesList;
}

// 主播云票数量
- (void)addRiceAmountView
{
    EVRiceAmountView *riceAmountView = [[EVRiceAmountView alloc] init];
    riceAmountView.hidden = YES;
    riceAmountView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.2];
    [self.contentView addSubview:riceAmountView];
    [riceAmountView autoSetDimension:ALDimensionHeight toSize:25];
    [riceAmountView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.videoInfoView];
    riceAmountView.delegate = self;
    self.riceTopConstraint = [riceAmountView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.videoInfoView withOffset:8];
    riceAmountView.layer.cornerRadius = 13;
    _riceAmountView = riceAmountView;
    [self.contentView bringSubviewToFront:riceAmountView];
}

// 视频和主播信息
- (void)addTopVideoInfoView
{
    EVHVLiveTopView *videoInfoView = [[EVHVLiveTopView alloc] init];
    videoInfoView.delegate = self;
    videoInfoView.backgroundColor = [UIColor clearColor];
    videoInfoView.frame = CGRectMake(0, 30, ScreenHeight, 30);
    [self.contentView addSubview:videoInfoView];
    _videoInfoView = videoInfoView;
    
    
    UILabel *hvBeanLabel = [[UILabel alloc] init];
    hvBeanLabel.frame = CGRectMake((ScreenHeight -115)/2, 30, 115, 26);
    [self.contentView addSubview:hvBeanLabel];
    self.hvBeanLabel = hvBeanLabel;
    hvBeanLabel.backgroundColor = [UIColor colorWithHexString:@"#F87A2A"];
    hvBeanLabel.layer.cornerRadius = 13;
    hvBeanLabel.layer.masksToBounds = YES;
    hvBeanLabel.text = @"火眼币0";
    hvBeanLabel.textColor = [UIColor whiteColor];
    hvBeanLabel.textAlignment = NSTextAlignmentCenter;
    hvBeanLabel.font = [UIFont textFontB2];
    
    
    UILabel *watchNumL = [[UILabel alloc] init];
    [self.contentView addSubview:watchNumL];
    self.watchNumL = watchNumL;
    watchNumL.frame = CGRectMake((ScreenHeight - 100)/2,CGRectGetMaxY(hvBeanLabel.frame) + 2,100, 22);
    watchNumL.textAlignment = NSTextAlignmentCenter;
    watchNumL.textColor = [UIColor whiteColor];
    watchNumL.backgroundColor = [UIColor clearColor];
    watchNumL.text = @"0人观看";
    watchNumL.font = [UIFont textFontB2];
}

// 滑屏
- (void)addContentView
{
    /** 有内容的页面 */
    EVContentView *contentView = [[EVContentView alloc] initWithFrame:CGRectMake(0, 0,ScreenHeight, ScreenWidth)];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.clipsToBounds = YES;
    [self.view addSubview:contentView];
    _contentView = contentView;

}

// 评论输入发送
- (void)addBottomChatView
{
    UIView *bottomContainerView = [[UIView alloc] init];
    bottomContainerView.backgroundColor = [UIColor clearColor];
    bottomContainerView.hidden = YES;
    [self.contentView addSubview:bottomContainerView];
    [bottomContainerView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [bottomContainerView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [bottomContainerView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    _chatContainerView = bottomContainerView;
    
    EVDanmuSwitch * danmuSwitch = [[EVDanmuSwitch alloc] init];
    [bottomContainerView addSubview:danmuSwitch];
    [danmuSwitch autoSetDimensionsToSize:CGSizeMake(50, 31)];
    [danmuSwitch autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [danmuSwitch autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [danmuSwitch addTarget:self action:@selector(danmuSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
    self.danmuSwitch = danmuSwitch;
    
    /** 评论输入 */
    EVAudienceChatTextView *textView = [[EVAudienceChatTextView alloc] init];
    textView.delegate = self;
    [bottomContainerView addSubview:textView];
    textView.heightContraint = [textView autoSetDimension:ALDimensionHeight toSize:CCAudienceChatTextViewHeight];
    textView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.8];
    [textView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:danmuSwitch withOffset:10];
    [textView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [bottomContainerView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:textView];
    textView.layer.cornerRadius = 3;
    _chatTextView = textView;
    
    /** 发送按钮 */
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:kSend forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendChat) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.titleLabel.font = EVNormalFont(16);
    sendBtn.backgroundColor = [UIColor evMainColor];
    [bottomContainerView addSubview:sendBtn];
    [sendBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [sendBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:textView withOffset:5];
    [sendBtn autoSetDimension:ALDimensionHeight toSize:CCAudienceChatTextViewHeight];
    [sendBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:textView];
    [sendBtn autoSetDimension:ALDimensionWidth toSize:60];
    sendBtn.layer.cornerRadius = 3.f;
    sendBtn.layer.masksToBounds = YES;
}


#pragma mark - event response
- (void)showliveShareViewDidClickButtonView:(BOOL)YorN
{
    if (YorN) {
        if (!self.shareView) {
            EVLiveShareView *shareView = [[EVLiveShareView alloc] initWithParentView:self.view];
            shareView.delegate = self;
            [self.view addSubview:shareView];
            self.shareView = shareView;
        }
        [self.shareView show];
    }
    self.commentTableView.hidden = NO;
    self.bottomBtnContainerView.hidden = YES;
    self.recordControlView.hidden      = YorN;
    [self.contacter boardCastEvent:AUDIENCE_SHAREVIEW_STATECHANGE withParams:@{AUDIENCE_SHAREVIEW_STATECHANGE : @(!YorN)}];
}

- (EVReportReasonView *)reportReasonView
{
    if ( !_reportReasonView )
    {
        // 举报
        EVReportReasonView *reportReasonView = [[EVReportReasonView alloc] init];
        [reportReasonView hide];
        reportReasonView.delegate = self;
        [self.view addSubview:reportReasonView];
        _reportReasonView = reportReasonView;
    }
    return _reportReasonView;
}

- (EVPromptRedPacketView *)promptRedPacketView
{
    if ( !_promptRedPacketView )
    {
        EVPromptRedPacketView *promptRedPacketView = [[EVPromptRedPacketView alloc] init];
        [self.contentView addSubview:promptRedPacketView];
        promptRedPacketView.hidden = YES;
        [promptRedPacketView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.riceAmountView];
        [promptRedPacketView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.riceAmountView withOffset:8];
        promptRedPacketView.delegate = self;
        _promptRedPacketView = promptRedPacketView;
    }
    return _promptRedPacketView;
}
#pragma mark - ***********    Notifications 📢    ***********
- (void)addNotificationCenter
{
    [EVNotificationCenter addObserver:self selector:@selector(followStateChanged:) name:EVFollowedStateChangedNotification object:nil];
    
    [EVNotificationCenter addObserver:self
                             selector:@selector(didEnterForeground)
                                 name:UIApplicationWillEnterForegroundNotification
                               object:nil];
    
    [EVNotificationCenter addObserver:self
                             selector:@selector(didEnterBackground)
                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)addKeyBoardNotificationCenter
{
    [EVNotificationCenter addObserver:self selector:@selector(keyBoardShow) name:UIKeyboardWillShowNotification object:nil];
    [EVNotificationCenter addObserver:self selector:@selector(keyBoardHide) name:UIKeyboardWillHideNotification object:nil];
}


// 进入前台
- (void)didEnterForeground
{
    self.firstLoadComment = YES;
}

// 切到后台
- (void)didEnterBackground
{
    self.firstLoadComment = NO;
}

- (void)followStateChanged:(NSNotification *)notify
{
    
}

#pragma mark - keyboard change
- (void)keyBoardShow
{
    if ( self.sendComment )
    {
        self.chatContainerView.hidden = NO;
        self.sendComment = NO;
    }
    self.bottomBtnContainerView.hidden = YES;
}

- (void)keyBoardHide
{
    self.chatContainerView.hidden = YES;
    UIView *livePrepareView = nil;
    if ( [self isKindOfClass:[EVNewLiveViewController class]] )
    {
        livePrepareView = ((EVNewLiveViewController *)self).prepareView;
    }
    if ( livePrepareView.hidden || !livePrepareView )
    {
        self.bottomBtnContainerView.hidden =YES;
    }
}

#pragma mark - ***********      Actions 🌠        ***********

/*
 *  播放页面需要的操作，直播页面不需要
 *  在播放页面实现
 */
- (void)updateEcoinAfterGrabRedEnvelop:(NSInteger)ecoin{}
- (void)livingWatchFollowAnchor{}
- (void)atAnchor{}

/**
 *  举报用户
 */
- (void)reportUserTitle:(NSString *)title
{
    NSArray *arrayCon = @[kE_GlobalZH(@"vulgar_pro"), kE_GlobalZH(@"rubbissh_ad"),kE_GlobalZH(@"break_the_law"), kE_GlobalZH(@"deveive"), kE_GlobalZH(@"people_attack"),kE_GlobalZH(@"e_else")];
    [[EVManagerUserView shareSheet]showAnimationViewArray:arrayCon reportTitle:title delegate:self];
}

// 跳转到私信页面
- (void)gotoLetterPageWithUserModel:(EVUserModel *)userModel
{
    if ( userModel.imuser == nil )
    {
        [EVProgressHUD showError:kE_GlobalZH(@"failChat")];
        return;
    }
//    [EVAppSetting shareInstance].appstate = EVEasyvaasAppStateLiving;
//    EVChatViewController *chatVC = [[EVChatViewController alloc] init];
//    EVNotifyConversationItem *conversationItem = [[EVNotifyConversationItem alloc] init];
//    conversationItem.userModel = userModel;
//    conversationItem.conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:userModel.imuser conversationType:eConversationTypeChat];
//    chatVC.conversationItem = conversationItem;
//    [self configurationNavigationBar];
//    [self.navigationController pushViewController:chatVC animated:YES];
}

// 跳转个人中心
- (void)showUserCenterWithName:(NSString *)name fromLivingRoom:(BOOL)fromLivingRoom
{
    EVOtherPersonViewController *otherPersonViewController = [EVOtherPersonViewController instanceWithName:name];
    [self configurationNavigationBar];
    otherPersonViewController.delegate = self;
    otherPersonViewController.fromLivingRoom = fromLivingRoom;
    [self.navigationController pushViewController:otherPersonViewController animated:YES];
}

- (void)configurationNavigationBar
{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor evMainColor]}];
    navigationBar.tintColor = [UIColor evMainColor];
    navigationBar.barTintColor = [UIColor evNaviBarBgColor];
}


#pragma mark - private method

- (void)focusAudienceWithUserModel:(EVUserModel *)userModel
{
    if ( [self.name isEqualToString:userModel.name] )
    {
        [EVProgressHUD showError:kE_GlobalZH(@"not_follow_self") toView:self.view];
        return;
    }
    FollowType type = userModel.followed ? unfollow : follow;
    __weak typeof(self) wself = self;
    [self.engine GETFollowUserWithName:userModel.name followType:type start:nil fail:^(NSError *error) {
    } success:^{
        switch (type)
        {
            case unfollow:
            {
                userModel.fans_count -= 1;
            }
                break;
                
            case follow:
            {
                userModel.fans_count += 1;
            }
                break;
        }
        
        userModel.followed = !userModel.followed;
        wself.floatView.userModel = userModel;
    } essionExpire:^{
        [wself sessionExpireAndRelogin];
    }];
}

- (void)setUpLoadMoreComment
{
    __weak typeof(self) wself = self;
    [self.commentTableView addRefreshFooterWithRefreshingBlock:^{
        [wself loadMoreComments];
    }];
    EVRefreshGifFooter *footer = [self.commentTableView footer];
    footer.transform = CGAffineTransformMakeRotation(M_PI);
    
    [self.commentTableView setFooterTitle:kE_GlobalZH(@"pull_loading_more_comment") forState:CCRefreshStateIdle];
    [self.commentTableView setFooterTitle:kE_GlobalZH(@"loading_more_comment") forState:CCRefreshStatePulling];
    [self.commentTableView hideFooter];
}

// 加载更多评论
- (void)loadMoreComments
{
    NSInteger commentid = 0; // 开始下一项的评论
    if ( commentid == 0 )
    {
        [self.commentTableView setFooterState:CCRefreshStateNoMoreData];
        return;
    }
}

// 展示用户信息
- (void)showUserInfoWithName:(NSString *)name
{
    if ( self.floatView.hidden == NO )
    {
        return;
    }
    if ( [self.name isEqualToString:name] )
    {
        [EVProgressHUD showError:kE_GlobalZH(@"is_self") toView:self.view];
        return;
    }
    
    __weak typeof(self) wself = self;
    
    [self.floatView show];
    [self.contentView bringSubviewToFront:self.floatView];
    
    [self.engine GETBaseUserInfoWithUname:name start:nil fail:^(NSError *error) {
        NSString *message = nil;
        message = kE_GlobalZH(@"request_fail_again");
        [EVProgressHUD showError:message toView:wself.view];
    } success:^(NSDictionary *modelDict) {
        EVLog(@"%@", modelDict);
        [EVProgressHUD hideHUDForView:wself.view];
        EVUserModel *model = [EVUserModel objectWithDictionary:modelDict];
        model.is_current_user = [model.name isEqualToString:wself.name];
        wself.floatView.userModel = model;
    } sessionExpire:^{
        [EVProgressHUD hideHUDForView:wself.view];
        [wself sessionExpireAndRelogin];
    }];
}


#pragma mark - CCShareView delegate
- (void)liveShareViewDidHidden
{
    self.commentTableView.hidden = NO;
    self.bottomBtnContainerView.hidden = YES;
    self.recordControlView.hidden = NO;
    [self.contacter boardCastEvent:AUDIENCE_SHAREVIEW_STATECHANGE withParams:@{AUDIENCE_SHAREVIEW_STATECHANGE : @YES}];
}

#pragma mark - CCAudienceViewDelegate
- (void)audienceInfoView:(EVVideoTopView *)view
              didClicked:(EVAudienceInfoViewButtonType)buttonType
{
    [self audienceDidClicked:buttonType];
}

- (void)liveTopViewButtonType:(EVHVLiveTopViewType)type button:(UIButton *)button
{
    [self topViewButtonType:type button:button];
}

- (void)topViewButtonType:(EVHVLiveTopViewType)type button:(UIButton *)button
{
    
}

#pragma mark - CCAudienceChatTextViewDelegate
- (void)audienceChatTextViewDidClickSendButton:(EVAudienceChatTextView *)textView
{
   
}

- (void)modifyFollowUser:(BOOL)follow
{
    if (follow == NO) {
       self.AudienceViewConstraint.constant = 143;
    }else {
        self.AudienceViewConstraint.constant = 100;
    }
}

#pragma mark - floating view delegate
//这块在修改 添加管理员
- (void)floatingView:(EVFloatingView *)floatingView clickButton:(UIButton *)button
{
    NSLog(@"%s",__func__);
    NSString *vid = self.vid;
    if ( vid == nil)
    {
        [EVProgressHUD showError:kE_GlobalZH(@"living_data_loading") toView:self.view];
        return;
    }
    NSInteger tag = button.tag;
    __block EVUserModel *userModel = floatingView.userModel;
    switch ( tag )
    {
        case CCFloatingViewReport:        // 举报
        {
            
            if ( userModel.name.length == 0 )
            {
                [EVProgressHUD showError:kE_GlobalZH(@"user_data_loading") toView:self.view];
                return;
            }
            [floatingView dismiss];
            self.reportedUser = userModel;
            if ([button.titleLabel.text isEqualToString:kE_GlobalZH(@"e_manager")]) {
                NSArray *arrayCon = [EVLiveWatchManager isManagerUserAndShutupName:self.floatView.userModel.name shutUsers:self.shutupUsers mngUsers:self.managerUser];
                [[EVManagerUserView shareSheet]showAnimationViewArray:arrayCon reportTitle:kE_GlobalZH(@"e_manager") delegate:self];
            }else{
                [self reportUserTitle:kE_GlobalZH(@"report_user")];
            }
        }
            break;
            
        case CCFloatingViewAtTa:   // 回复评论
        {
            self.sendComment = YES;
            EVComment *comment = [[EVComment alloc] init];
            comment.name = userModel.name;
            comment.reply_nickname = userModel.nickname;
            comment.reply_name = userModel.name;
            if ( [EVLoginInfo checkCurrUserByName:comment.name] )
            {
                [EVProgressHUD showError:kE_GlobalZH(@"not_give_me_send_comment") toView:self.view];
                return;
            }
            self.replayComment = comment;
            [self.floatView dismiss];
            NSString *replyNickNameString = [NSString stringWithFormat:@"@%@ ",userModel.nickname];
            comment.replyNickNameString = replyNickNameString;
            [self.chatTextView setReplyString:replyNickNameString];
            [self.chatTextView beginEdit];
        }
            break;
            
        case CCFloatingViewFocucs:         // 关注
        {
            [self focusAudienceWithUserModel:userModel];
        }
            break;
            
        case CCFloatingViewHomePage:    // 主页
            [self showUserCenterWithName:userModel.name fromLivingRoom:NO];
            break;
            
        case CCFloatingViewMessage:      // 私信
            [self gotoLetterPageWithUserModel:userModel];
            break;
            
        default:
            break;
    }
}

- (void)mngUserListArray:(NSMutableArray *)array
{
    if (self.managerUser.count == 0) {
        [self.managerUser addObjectsFromArray:array];
    }else{
        [self.managerUser removeAllObjects];
        [self.managerUser addObjectsFromArray:array];
    }
}

//danmu button userdata
- (void)presentViewShowFloatingView:(EVDanmuModel *)model
{
    __weak typeof(self) wself = self;
    if (model.content == nil || [model.content isEqualToString:@""]) {
        return;
    }
    [self.engine GETBaseUserInfoWithUname:model.name start:nil fail:^(NSError *error) {
        NSString *message = nil;
        message = kE_GlobalZH(@"request_fail_again");
        [EVProgressHUD showError:message toView:wself.view];
    } success:^(NSDictionary *modelDict) {
        EVLog(@"%@", modelDict);
        [EVProgressHUD hideHUDForView:wself.view];
        EVUserModel *model = [EVUserModel objectWithDictionary:modelDict];
        model.is_current_user = [model.name isEqualToString:wself.name];
        wself.floatView.userModel = model;
    } sessionExpire:^{
        [EVProgressHUD hideHUDForView:wself.view];
        [wself sessionExpireAndRelogin];
    }];
    [self.floatView show];
}


#pragma mark - EVPresentView delegate
- (void)animationWithPresent:(EVStartGoodModel *)present time:(NSInteger)time mine:(BOOL)mine nickName:(NSString *)nickName
{
    switch ( present.anitype )
    {
        case EVPresentAniTypeStaticImage:
        {
            [self.presentAnimatingView startAnimationWithPresent:present];
            break;
        }
        case EVPresentAniTypeZip:
        {
            if ( mine )
            {
                break;
            }
//            NSString *aniDir = [self presentAniDirectoryWithPath:PRESENTFILEPATH(present.ani)];
            break;
        }
        default:
            break;
    }
}

#pragma mark - CCRiceAmountViewDelegate
- (void)riceAmoutViewDidSelect
{
    EVFantuanContributionListVC *fantuanVC = [[EVFantuanContributionListVC alloc] init];
//    fantuanVC.name = self.videoInfoView.item.name;
    [self.navigationController pushViewController:fantuanVC animated:YES];
}
#pragma mark - CCCommentCellDelegate
- (void)commentCell:(EVCommentCell *)cell
         didClicked:(CCCommentClickType)type
{
    switch ( type )
    {
        case CCCommentClickTypeComment:
        {
            EVComment *comment = cell.comment;
            
            switch ( comment.commentType )
            {
                case CCCommentComment: {
                    [self clickNormalComment:comment];
                    break;
                }
                case CCCommentRedEnvelop: {
                    [self showRedEnvelopeViewWithComment:comment];
                    break;
                }
                default:
                    break;
            }
        }
            break;
            
        case CCCommentClickTypeNickName:
            [self showUserInfoWithName:cell.comment.name];
            break;
            
        case CCCommentClickTypeReplyName:
            if ( cell.comment.reply_name )
            {
                [self showUserInfoWithName:cell.comment.reply_name];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.scrolling = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger commentCount = self.comments.count;
    return commentCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVComment *comment = self.comments[indexPath.row];
    EVCommentCell *commentCell = (EVCommentCell *)[self.commentTableView popCellFromPoolWithID:[EVCommentCell cellID]];
    
    // 解决回复评论后，被回复的评论也添加了"@replaynickname:"
    if ( [comment.reply_name isEqualToString:comment.name] )
    {
        comment.reply_nickname = @"";
    }
    commentCell.delegate = self;
    commentCell.comment = comment;
    return commentCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath
                                                                    *)indexPath
{
//    EVComment *comment = self.comments[indexPath.row];
//    if ( [comment.commentflag isEqualToString:kE_GlobalZH(@"e_RedPack")] )
//    {
//        [self showRedEnvelopeViewWithComment:comment];
//    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.commentTableView pushCellToPool:cell];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVComment *comment = self.comments[indexPath.row];
    if ( comment.commentType == CCCommentRedEnvelop )
    {
        return 33;
    }
    return comment.cellheigt;
}

#pragma mark - UICollection view delegete
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.audiences.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVAudienceCell *cell = (EVAudienceCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[EVAudienceCell audienceCellID] forIndexPath:indexPath];
    EVAudience *audience = self.audiences[indexPath.item];
    cell.audience = audience;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.item > (NSInteger)self.audiences.count  - 1 )
    {
        return;
    }
    
    EVAudience *audience = self.audiences[indexPath.item];
    if ( audience.guest )
    {
        [EVProgressHUD showError:kE_GlobalZH(@"is_one_tourist") toView:self.view];
        return;
    }
    [self showUserInfoWithName:audience.name];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ( [change[@"new"] CGPointValue].y == 0 )
    {
        self.unreadCommentNum = 0;
    }
}

// 评论滚动到最底部
- (void)commentTableViewScrollToBottom
{
    if ( self.commentTableView.dragging )
    {
        return;
    }
    self.unreadCommentNum = 0;

    [self.commentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

// 处理评论内容
- (void)handelCommnetsWithNewComment:(NSArray *)data
{
    EVComment *newComments = [data firstObject];
    [self.comments insertObject:newComments atIndex:0];
    [self.commentTableView reloadData];
    
    // 如果正处在底部，则继续滚动到底部
    if ( self.commentTableView.contentOffset.y != 0 )
    {
        self.unreadCommentNum += data.count;
    }
}

// 未读消息个数
- (void)setUnreadCommentNum:(NSInteger)unreadCommentNum
{
    _unreadCommentNum = unreadCommentNum;
    self.unreadBtn.unreadNum = unreadCommentNum;
    self.unreadBtn.hidden = !unreadCommentNum;
    
    // 根据未读消息个数改变评论显示区域
    if (unreadCommentNum == 0)
    {
        self.commentTableBottomConstraint.constant = -5;
        self.scrolling = NO;
    }
    else
    {
        self.commentTableHeightConstraint.constant = kDefaultTableHeight - self.unreadBtn.bounds.size.height - 10;
        self.commentTableBottomConstraint.constant = -(self.unreadBtn.bounds.size.height + 10);
    }
}

// 展示红包界面
- (void)showRedEnvelopeViewWithComment:(EVComment *)comment
{
    EVRedEnvelopeItemModel *envelopeModel = [[EVRedEnvelopeItemModel alloc] init];
    envelopeModel.hid = comment.reply_name;
    envelopeModel.hnm = comment.nickname;
    envelopeModel.hlg = comment.reply_nickname;
    EVRedEnvelopeView *redEnvelopeView = [[EVRedEnvelopeView alloc] init];
    __weak typeof(self) wself = self;
    redEnvelopeView.grabRedEnveloCompleteHandler = ^(EVRedEnvelopeView *redEnvelopView, NSInteger ecoin) {
        
        [wself updateEcoinAfterGrabRedEnvelop:ecoin];
    };
    redEnvelopeView.vid = self.vid;
    redEnvelopeView.currentModel = envelopeModel;
    [redEnvelopeView buttonShow];
}


- (void)sessionExpireAndRelogin
{
    [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kE_GlobalZH(@"fail_account_again_login") comfirmTitle:kOK WithComfirm:^{
        if ( self.navigationController.childViewControllers.count > 1 )
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if ( self.navigationController.childViewControllers.count == 1 )
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        [(AppDelegate *)[UIApplication sharedApplication].delegate relogin];
    }];
}

- (void)logoutVideoAndChatWithName:(NSString *)name
{
    if ( self.navigationController.childViewControllers.count > 1 )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ( self.navigationController.childViewControllers.count == 1 )
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [(AppDelegate *)[UIApplication sharedApplication].delegate chatWithName:name];
}

- (void)danmuSwitchClick:(EVDanmuSwitch *)sender
{
    sender.selected = !sender.selected;
}

- (void)sendChat
{
    [self audienceChatTextViewDidClickSendButton:self.chatTextView];
}


//举报用户
- (void)reportWithReason:(UIButton *)reason reportTitle:(NSString *)reportTitle
{
    if ([reportTitle isEqualToString:kE_GlobalZH(@"report_user")]) {
        __weak typeof(self) weakself = self;
        if ( self.reportedUser )
        {
            [EVProgressHUD showSuccess:kE_GlobalZH(@"process_report") toView:weakself.view];
            [self.engine GETUserInformWithName:[self.reportedUser.name mutableCopy]
                                description:[reason.currentTitle mutableCopy]
                                      start:nil
                                    success:nil
                                       fail:nil
                                     expire:nil];
            self.reportedUser = nil;
            return;
        }
        
        
    }else if([reportTitle isEqualToString:kE_GlobalZH(@"report_video")]){
        [EVProgressHUD showSuccess:kE_GlobalZH(@"process_report_video") toView:self.view];
        [self.engine GETUserInformWithName:[self.reportedUser.name mutableCopy]
                               description:[reason.currentTitle mutableCopy]
                                     start:nil
                                   success:nil
                                      fail:nil
                                    expire:nil];
    }else{
        
        if ([reason.currentTitle isEqualToString:kE_GlobalZH(@"setting_manager")]) {

            [self.liveWatchManager settingManagerWithName:self.reportedUser.name vid:self.topicVid state:1];
            
        }else if([reason.currentTitle isEqualToString:kE_GlobalZH(@"manager_list")]){
            EVMngUserListController *mngUserListV = [[EVMngUserListController alloc]init];
            mngUserListV.vid = self.vid;
            mngUserListV.managerArray = self.managerUser;
            mngUserListV.delegate = self;
            [self.navigationController pushViewController:mngUserListV animated:YES];
        }else if ([reason.currentTitle isEqualToString:kE_GlobalZH(@"e_gag")]){
            for (NSString *users in self.managerUser) {
                if ([users isEqualToString:self.reportedUser.name]) {
                    [EVProgressHUD showError:kE_GlobalZH(@"not_limit")];
                    break;
                }else{
                    [self.shutupUsers  addObject:self.reportedUser.name];
                  
                }
            }
            [self  shutupAudienceWithAudienceName:self.reportedUser.name shutupState:1];
        }else if ([reason.currentTitle isEqualToString:kE_GlobalZH(@"e_report")]){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self reportUserTitle:kE_GlobalZH(@"report_user")];
            });
        }else if ([reason.currentTitle isEqualToString:kE_GlobalZH(@"cancel_manager")]){

            [self.liveWatchManager settingManagerWithName:self.reportedUser.name vid:self.topicVid state:0];
        }else if([reason.currentTitle isEqualToString:kE_GlobalZH(@"complete_gag")]){
             [self shutupAudienceWithAudienceName:self.reportedUser.name shutupState:0];
        }else if([reason.currentTitle isEqualToString:kE_GlobalZH(@"e_kickuser")]){
            
            [self.liveWatchManager kickUserWithName:self.reportedUser.name vid:self.topicVid state:1];
        }else {
            
        }
    }
}

- (void)shutupAudienceWithAudienceName:(NSString *)name shutupState:(BOOL)shutup
{
    [self.liveWatchManager shutupAudienceWithAudienceName:name vid:self.topicVid shutupState:shutup];
}

- (NSString *)presentAniDirectoryWithPath:(NSString *)path
{
    NSString *dir;
    for (NSString *subPath in [[NSFileManager defaultManager] subpathsAtPath:path])
    {
        if ( [subPath cc_containString:@"Animation"] )
        {
            dir = subPath;
            break;
        }
    }
    return dir;
}



- (void)clickNormalComment:(EVComment *)comment
{
    EVLoginInfo *info = [EVLoginInfo localObject];
    if ( [comment.name isEqualToString:info.name] )
    {
        [EVProgressHUD showError:kE_GlobalZH(@"not_reply_self_comment") toView:self.view];
        return;
    }
    self.sendComment = YES;
    EVComment *replyComment = [[EVComment alloc] init];
    replyComment.is_guest = comment.is_guest;
    replyComment.textOrigin = comment.textOrigin;
    replyComment.comment_id = comment.comment_id;
    replyComment.commentType = comment.commentType;
    replyComment.name = comment.name;
    replyComment.reply_name = comment.nickname;
    replyComment.nickname = comment.nickname;
    replyComment.content = comment.content;
    replyComment.prefixNameAttributeString = comment.prefixNameAttributeString;
    replyComment.cellheigt = comment.cellheigt;
    replyComment.userNickNameRnage = comment.userNickNameRnage;
    replyComment.usernicknameFrame = comment.usernicknameFrame;
    replyComment.replynickFrame = comment.replynickFrame;
    
    replyComment.reply_nickname = [comment.nickname mutableCopy];
    replyComment.reply_name = [comment.name mutableCopy];
    replyComment.replyNickNameString = [NSString stringWithFormat:@"@%@ ",comment.nickname];
    
    self.replayComment = comment;
    [self.chatTextView setReplyString:replyComment.replyNickNameString];
    [self.chatTextView beginEdit];
}

- (void)audienceDidClicked:(EVAudienceInfoViewButtonType)btn
{
    switch ( btn )
    {
        case EVAudienceInfoFocus:
            [self livingWatchFollowAnchor];
            break;
            
        case EVAudienceInfoComment:
        {
            [self atAnchor];
            
            
        }
            break;

        case EVAudienceInfoMessage:
//            [self gotoLetterPageWithUserModel:self.videoInfoView.item.userModel];
            break;
            
        case EVAudienceInfoIndexPage:
            
//            [self showUserCenterWithName:self.videoInfoView.item.name fromLivingRoom:YES];
            break;
        case EVAudienceInfoFollow:
            [self livingWatchFollowAnchor];
            break;
        default:
            break;
    }
}


- (void)liveShareViewWillHided {
    [self showShareView:NO];
}

//新添加的   以前没有
- (void)showShareView:(BOOL)YorN
{
    [self showliveShareViewDidClickButtonView:YorN];
}

- (void)sendDanmuSuccess
{
    __weak typeof(self) wself = self;
    [self.engine GETUserAssetsWithStart:^{
        
    } fail:^(NSError *error) {
        EVLog(@"get asset fail");
    } success:^(NSDictionary *videoInfo) {
        EVLog(@"get asset success");
        [wself updateAssetWithInfo:videoInfo];
    } sessionExpire:^{
        EVRelogin(wself);
    }];
}

- (void)sendDanmuCancel
{
    
}

- (void)addPresentListView
{
    if ( [[EVStartResourceTool shareInstance] prensentEnable] || [[EVStartResourceTool shareInstance] emojiPresentEnable] )
    {
        EVMagicEmojiView *magicEmojiView = [EVMagicEmojiView magicEmojiViewToTargetView:self.contentView];
        _magicEmojiView = magicEmojiView;
        _magicEmojiView.delegate = self;
    }
}

// 去充值界面
- (void)gotoRechargeYiBi
{
    EVYunBiViewController *yibiVC = [[EVYunBiViewController alloc] init];
    yibiVC.delegate = self;
    EVUserAsset *asset = [[EVUserAsset alloc] init];
    asset.ecoin = self.magicEmojiView.ecoin;
    yibiVC.asset = asset;
    if (self.navigationController)
    {
        [self.navigationController pushViewController:yibiVC animated:YES];
    }
}

#pragma mark - CCYiBiViewController delegate
- (void)buySuccessWithEcoin:(NSInteger)ecoin
{
    self.magicEmojiView.ecoin = ecoin;
    // 存放到本地
    EVLoginInfo *info = [EVLoginInfo localObject];
    info.ecoin = ecoin;
    [info synchronized];
}

// 更新资产信息
- (void)updateAssetWithInfo:(NSDictionary *)Info
{
    NSInteger barley = [Info[kBarley] integerValue];
    NSInteger ecoin = [Info[kEcoin] integerValue];
    self.magicEmojiView.barley = barley;
    self.magicEmojiView.ecoin = ecoin;
    
    // 存放到本地
    EVLoginInfo *info = [EVLoginInfo localObject];
    info.barley = barley;
    info.ecoin = ecoin;
    [info synchronized];
}

- (void)audienceChatTextChangeInputStyle
{
    self.sendComment = YES;
}

- (void)audienceChatTextKeyBarodDidChange:(EVAudienceChatTextView *)textView textFrame:(CGRect)frame animationTime:(NSTimeInterval)time
{
    CGRect contentViewFrame = self.contentView.frame;
    CGFloat height = frame.size.height;
    if ( frame.origin.y < self.view.bounds.size.height )
    {
        contentViewFrame.origin.y = -height;
    }
    else
    {
        contentViewFrame.origin.y = 0;
    }
    self.contentView.frame = contentViewFrame;
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

#pragma mark - video view protocol

- (void)showRedEnvelopBottomRiceWithModel:(EVRedEnvelopeItemModel *)model
{
    [self.promptRedPacketView pushRedPacket:model];
}

- (void)showRedPacktWithItem:(EVRedEnvelopeItemModel *)model
{
    EVRedEnvelopeView *redEnvelopeView = [[EVRedEnvelopeView alloc] init];
    __weak typeof(self) wself = self;
    redEnvelopeView.grabRedEnveloCompleteHandler = ^(EVRedEnvelopeView *redEnvelopView, NSInteger ecoin) {
        wself.oldHid = redEnvelopView.currentModel.hid;
        [wself updateEcoinAfterGrabRedEnvelop:ecoin];
    };
    redEnvelopeView.vid = self.vid;
    redEnvelopeView.currentModel = model;
    [redEnvelopeView buttonShow];
}


- (void)audienceShutedupSuccess
{
    [EVProgressHUD showSuccess:@"设置成功"];
}

- (void)audienceShutedupFail
{
     [EVProgressHUD showSuccess:@"设置失败"];
}


//设置管理员成功
- (void)settingManagerSuccess
{
      [EVProgressHUD showSuccess:@"设置成功"];
}

//设置管理员失败
- (void)settingManagerFail
{
      [EVProgressHUD showSuccess:@"设置失败"];
}

#pragma mark - old chat server -------------------
#pragma mark - xintiao

- (void)audienceShutedup
{
    [EVProgressHUD showError:kE_GlobalZH(@"self_gag") toView:self.view];
}

- (void)dismissShareView
{
    [self.shareView dissmiss];
}

// 更新视频信息
- (void)updateVideoInfo:(NSDictionary *)videoInfo
{
    if ( videoInfo[AUDIENCE_UPDATE_PLAY_TIME] )
    {
//        self.videoInfoView.item.time = videoInfo[AUDIENCE_UPDATE_PLAY_TIME];
    }
    
}

#pragma mark - hidden content.subviews
- (void)hiddenContentSubviews {
    for (UIView *view in self.contentView.subviews) {
        view.hidden = YES;
    }
}

#pragma mark - ***********     Lazy Loads 💤      ***********
- (EVControllerContacter *)contacter
{
    if ( _contacter == nil )
    {
        _contacter = [[EVControllerContacter alloc] init];
    }
    return _contacter;
}

- (NSString *)name
{
    if ( !_name )
    {
        EVLoginInfo *info = [EVLoginInfo localObject];
        _name = info.name;
    }
    return _name;
}

- (NSMutableArray *)redPackageArray
{
    if (!_redPackageArray) {
        _redPackageArray = [NSMutableArray array];
    }
    return _redPackageArray;
}
//管理用户
- (NSMutableArray *)managerUser
{
    if (_managerUser == nil) {
        _managerUser = [NSMutableArray array];
    }
    return _managerUser;
}
//禁言数组
- (NSMutableArray *)shutupUsers
{
    if (_shutupUsers == nil) {
        _shutupUsers = [NSMutableArray array];
    }
    return _shutupUsers;
}

- (NSMutableArray *)comments
{
    if (!_comments) {
        _comments = [NSMutableArray array];
    }
    
    return _comments;
}

- (EVFloatingView *)floatView
{
    if ( !_floatView )
    {
        EVFloatingView *floatWindow = [[EVFloatingView alloc] init];
        floatWindow.hidden = YES;
        floatWindow.delegate = self;
        floatWindow.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:floatWindow];
        floatWindow.isAnchor = YES;
        floatWindow.floatingViewY = [floatWindow autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [floatWindow autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [floatWindow autoSetDimensionsToSize:CGSizeMake(286, 315)];
        _floatView = floatWindow;
    }
    return _floatView;
}

- (NSMutableArray *)audiences
{
    if ( !_audiences )
    {
        _audiences = [NSMutableArray array];
    }
    return _audiences;
}

- (EVLiveWatchManager *)liveWatchManager
{
    if (!_liveWatchManager) {
        _liveWatchManager = [[EVLiveWatchManager alloc]init];
        _liveWatchManager.protocol = self;
        
    }
    return _liveWatchManager;
}

- (NSMutableArray *)linkArray
{
    if (!_linkArray) {
        _linkArray = [NSMutableArray array];
    }
    return _linkArray;
}

- (void)setTopicVid:(NSString *)topicVid
{
    _topicVid = topicVid;
    if (![topicVid isEqualToString:@""] &&  topicVid != nil && ![_anchorName isEqualToString:@""] && _anchorName != nil) {
        [self connectMessageInVC:topicVid];
    }
}

- (void)setAnchorName:(NSString *)anchorName
{
    _anchorName = anchorName;
    if (![_topicVid isEqualToString:@""] &&  _topicVid != nil && ![_anchorName isEqualToString:@""] && _anchorName != nil) {
        [self connectMessageInVC:_topicVid];
    }
}
- (void)receiveRedDic:(NSDictionary *)dict
{
    @synchronized(self)
    {
        __weak typeof(self) wself = self;
        
        EVRedEnvelopeItemModel *model = [EVRedEnvelopeItemModel objectWithDictionary:dict];
        model.htm = 10;
        model.open = 1;
        NSArray *tmp = [NSMutableArray arrayWithArray:wself.allRedEnvelope[model.hid]];
        NSMutableArray *temp = [NSMutableArray array];
        [temp addObjectsFromArray:tmp];
        
        if ( ![temp containsObject:model] )
        {
            if ( model.open == 0 )
            {
                [temp addObject:model];
                [wself.allRedEnvelope setObject:temp forKey:model.hid];
            }
            else if ( model.open == 1 )
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    EVRedEnvelopeView *redEnvelopeView = [[EVRedEnvelopeView alloc] init];
                    redEnvelopeView.currentModel = model;
                    redEnvelopeView.transitionStyle = arc4random() % 4;
                    redEnvelopeView.vid = wself.vid;
                    // 红包提醒
                    [wself showRedEnvelopBottomRiceWithModel:redEnvelopeView.currentModel];
                    redEnvelopeView.grabRedEnveloCompleteHandler = ^(EVRedEnvelopeView *redEnvelopView, NSInteger ecoin) {
                        [wself updateEcoinAfterGrabRedEnvelop:ecoin];
                    };
                
                });
            }
        }
        
        [EVRedEnvelopeView setAllRedEnvelope:self.allRedEnvelope];
    }
}
#pragma mark - 新的连接聊天服务器
- (void)connectMessageInVC:(NSString *)topicVid
{
    
}

- (void)setMessageSDKEngine:(EVSDKLiveMessageEngine *)messageSDKEngine
{
    _messageSDKEngine = messageSDKEngine;
    EVLog(@"connect message server --------  %@",self.vid);
    _messageSDKEngine = [[EVSDKLiveMessageEngine alloc]init];
    _messageSDKEngine.topicVid = self.vid;
    _messageSDKEngine.delegate = self;
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    _messageSDKEngine.userData = loginInfo.name;
    [_messageSDKEngine connectMessage];
    _messageSDKEngine.anchorName = _anchorName;
}

- (void)successJoinTopic
{
    EVLog(@"加入话题成功");
    NSString *commentString = [NSString stringWithFormat:@"温馨提示：绿色直播。涉及色情，低俗，暴力等内容将被封停账号，文明直播，从我做起！"];
    NSDictionary *commentFormat = [NSDictionary dictionaryWithObjectsAndKeys:@"",EVMessageKeyNk, nil];
    NSMutableDictionary *commentJoin = [NSMutableDictionary dictionaryWithObjectsAndKeys:commentFormat,EVMessageKeyExbr, nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:commentJoin options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[EVMessageManager shareManager] sendMessage:commentString userData:jsonString toTopic:self.topicVid result:^(BOOL isSuccess, EVMessageErrorCode errorCode) {
        if (isSuccess) {
            EVLog(@"sendmessagesuccess ------------");
        }else{
            EVLog(@"errorCode ------------------");
        }
    }];
}

- (void)joinTopicIDNil
{
    EVLog(@"topicidnil");
}

- (void)updateMessageJoinUserData:(NSMutableArray *)data
{
    [self handelCommnetsWithNewComment:data];
    
}

- (void)updateMessageAllUserData:(NSMutableArray *)data
{
    self.audiencesList.userInteractionEnabled = NO;
    self.audiences = data;
    [self.audiencesList reloadData];
    self.audiencesList.userInteractionEnabled = YES;
    self.watchNumL.text = [NSString stringWithFormat:@"%ld人观看",data.count];
//    self.videoInfoView.itenm.watchingCount = (NSInteger)(data.count);
}

- (void)updateMessageNewCommentData:(NSMutableArray *)data
{
      [self handelCommnetsWithNewComment:data];
}

- (void)updateMessageShutUserData:(NSMutableArray *)data
{
    self.shutupUsers = [NSMutableArray arrayWithArray:data];
    for (NSString *userName in data) {
        if ([userName isEqualToString:[EVLoginInfo localObject].name]) {
            [EVProgressHUD showSuccess:@"禁言成功"];
        }
    }
}

- (void)updateMessageKickUserData:(NSMutableArray *)data
{
    for (NSString *userName in data) {
        if ([userName isEqualToString:[EVLoginInfo localObject].name]) {
            self.isKickSelf = YES;
        }
    }
}

- (void)updateMessageMngUserData:(NSMutableArray *)data
{
    self.managerUser = [NSMutableArray arrayWithArray:data];
    
    for (NSString *userName in data) {
        if ([userName isEqualToString:[EVLoginInfo localObject].name]) {
            [EVProgressHUD showSuccess:@"设置成功"];
            self.floatView.isMng = YES;
        }
    }
}

- (void)updateMessageLinkDict:(NSDictionary *)dict comment:(NSString *)comment
{

}

- (void)updateMessageRedPacketDict:(NSDictionary *)dict
{
     [self receiveRedDic:dict];
}

- (void)updateMessageGiftDict:(NSDictionary *)dict
{
    NSMutableDictionary *giftDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSMutableArray *array = [NSMutableArray arrayWithObject:giftDict];
    EVStartGoodModel *startGoodM = [EVStartGoodModel modelWithDict:dict];
    [self.giftAniView addStartGoodModel:startGoodM];
    [self.presentView pushPresents:array];
    [self.presentAnimatingView startAnimationWithPresent:startGoodM];
}

- (void)updateMessasgeDanmuDict:(NSDictionary *)dict comment:(NSString *)comment
{
    EVDanmuModel * model = [EVDanmuModel modelFromDictionary:dict comment:comment];
    [self.contentView bringSubviewToFront:self.presentView];
    [self.danmuManager receiveDanmu:model];
}


- (void)updateLiveStatus:(BOOL)status
{
    self.livingStatus = status;
}


- (void)updateMessageLoveCount:(long long)loveCount
{
}


- (void)updateMessageWatchingCount:(long long)watchingCount
{
    EVLog(@"----- watchingcount -------  %lld",watchingCount);
    if (self.watching_count > 0) {
        long long upRice = watchingCount - self.watch_count;
        self.growwatching_count = upRice+self.growwatching_count;
    }
    self.watchNumL.text = [NSString stringWithFormat:@"%lld人观看",watchingCount];
    self.watching_count = watchingCount;
}

- (void)updateMessageRiceRoll:(long long)riceRoll
{
    if (riceRoll > self.huoyanbi && self.huoyanbi > 0) {
         long long upRice = riceRoll - self.huoyanbi;
        self.growHuoyanbi = upRice+self.growHuoyanbi;
        EVLog(@"huoyan  ----  %lld",self.growHuoyanbi);
    }
    self.huoyanbi = riceRoll;
    EVLog(@"000=----- huoyanbi -------  %lld",riceRoll);
    self.hvBeanLabel.text = [NSString stringWithFormat:@"火眼币 %lld",riceRoll];
}

- (void)updateMessageWatchedCount:(long long)watchedCount
{
    EVLog(@"watchcount-----------------  %lld",watchedCount);
    if (self.huoyanbi > 0) {
        long long upRice = watchedCount - self.watch_count;
        self.growwatch_count = upRice+self.growwatch_count;
    }
    self.watch_count = watchedCount;
}
@end
