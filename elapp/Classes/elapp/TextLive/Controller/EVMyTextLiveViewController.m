//
//  EVMyTextLiveViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/13.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVMyTextLiveViewController.h"
#import "EVSharePartView.h"
#import "SGSegmentedControl.h"
#import "EVLiveImageTableView.h"
#import "EVLiveImageBottomTextView.h"
#import "EVNotOpenView.h"
#import <HyphenateLite_CN/EMSDK.h>
#import "EVEaseMessageModel.h"
#import "EVTextLiveToolBar.h"
#import "YZInputView.h"
#import "EVSendImageView.h"
#import "CCVerticalLayoutButton.h"
#import "EVHVWatchStockView.h"
#import "EVHVStockTextView.h"
#import "EVBaseToolManager+EVSearchAPI.h"
#import "EVStockBaseModel.h"
#import "EVNullDataView.h"
#import "EVTextLiveChatTableView.h"
#import "EVLoginInfo.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVHVGiftAniView.h"
#import "EVShareManager.h"


@interface EVMyTextLiveViewController ()<SGSegmentedControlStaticDelegate,UIScrollViewDelegate,EVLiveImageBottomViewDelegate,EMChatManagerDelegate,EVTextBarDelegate,EVSendImageDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,EVHVStockTextViewDelegate,EVTextLiveTableViewDelegate,EMChatroomManagerDelegate>
{
    //延迟显示小红花  刚进入的时候不显示
    BOOL isDisplayflower;
}

/**
 小红花数组  收到小红花就放到这个数组里   用来区别 如果收到相同的红花  就不加入进去  避免重复
 */
@property (nonatomic,strong) NSMutableArray *redFlowerArray;

@property (nonatomic,strong) NSMutableArray *historyChatArray;
@property (nonatomic,strong) NSMutableArray *historyArray;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) EVSharePartView *eVSharePartView;

@property (nonatomic, strong) SGSegmentedControlStatic *topSView;

@property (nonatomic, weak) UIScrollView *mainScrollView;

@property (nonatomic, weak) EVLiveImageTableView  *liveImageTableView;
@property (strong, nonatomic) EMConversation *conversation;

@property (nonatomic, strong) UIWindow *textBackWindow;

@property (nonatomic, weak) EVTextLiveToolBar *textLiveToolBar;
@property (nonatomic, weak) EVTextLiveToolBar *chatLiveToolBar;

@property (nonatomic, weak) UIControl *touchLayer;


@property (nonatomic,assign) CGFloat keyBoardHig;

@property (nonatomic, strong) NSLayoutConstraint *toolBarTextViewHig;

@property (nonatomic, strong) NSLayoutConstraint *toolBarTextBottonF;

@property (nonatomic, strong) NSLayoutConstraint *chatToolBarTextViewHig;

@property (nonatomic, strong) NSLayoutConstraint *chatToolBarTextBottonF;

@property (nonatomic, weak) EVSendImageView *sendImageView;

@property (nonatomic, strong) NSLayoutConstraint *sendImageViewHig;

@property (nonatomic, assign) BOOL isChooseImageButton;

@property (nonatomic, weak) EVHVWatchStockView *watchStockView;

@property (nonatomic, weak) EVHVStockTextView *stockTextView;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, weak) EVNotOpenView *notOpenStockView;

@property (nonatomic, assign) NSInteger chooseIndex;

@property (nonatomic, weak) EVTextLiveChatTableView *textLiveChatTableView;

@property (nonatomic, copy) NSString *rpName;
@property (nonatomic, copy) NSString *rpContent;

@property (nonatomic, assign) NSInteger segmentedIndex;

@property (nonatomic, weak) EVHVGiftAniView *hvGiftAniView;

@property (nonatomic) UIImage *snopImage;

@property (nonatomic, assign) BOOL isRefresh;

@property (nonatomic, strong) EMChatroom  *chatRoom;

@property (nonatomic, weak) EVNullDataView *liveImageNullDataView;
@end

@implementation EVMyTextLiveViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的直播间";
    self.chooseIndex = 0;
    [self addBarItem];
    [self addSegmentView];

    [self addScrollView];

    [self addShareView];
    
    [self addGiftAniView];
    //延迟一秒显示小红花
    [self performSelector:@selector(delayDisplayFlower) withObject:nil afterDelay:1.f];
}

- (void)delayDisplayFlower{
    isDisplayflower = YES;
}

- (void)addBarItem
{
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hv_share"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
    
    
    UIBarButtonItem *leftBarBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hv_back_return"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnClick)];
    self.navigationItem.leftBarButtonItem = leftBarBtnItem;
}


- (void)addSegmentView
{
    UIView *segmentBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, 44)];
    segmentBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:segmentBackView];
    NSArray *titleArray = @[@"直播",@"数据",@"聊天",@"秘籍"];
    
    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 0, ScreenWidth/5 * 4, 44) delegate:self childVcTitle:titleArray indicatorIsFull:NO];
    
    // 必须实现的方法
    [self.topSView SG_setUpSegmentedControlType:^(SGSegmentedControlStaticType *segmentedControlStaticType, NSArray *__autoreleasing *nomalImageArr, NSArray *__autoreleasing *selectedImageArr) {
        
    }];
    
    [self.topSView SG_setUpSegmentedControlStyle:^(UIColor *__autoreleasing *segmentedControlColor, UIColor *__autoreleasing *titleColor, UIColor *__autoreleasing *selectedTitleColor, UIColor *__autoreleasing *indicatorColor, BOOL *isShowIndicor) {
        *segmentedControlColor = [UIColor whiteColor];
        *titleColor = [UIColor evTextColorH2];
        *selectedTitleColor = [UIColor evMainColor];
        *indicatorColor = [UIColor evMainColor];
    }];
    self.topSView.selectedIndex = 0;
    [segmentBackView addSubview:_topSView];
    
    
}

- (void)addScrollView
{
        WEAK(self)
    UIScrollView *mainScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:mainScrollView];
    self.mainScrollView = mainScrollView;
    mainScrollView.backgroundColor = [UIColor evBackgroundColor];
    mainScrollView.pagingEnabled = YES;
    mainScrollView.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 157);
    mainScrollView.contentSize = CGSizeMake(ScreenWidth * 4, ScreenHeight - 157);
    mainScrollView.delegate = self;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    self.view.backgroundColor = [UIColor evBackgroundColor];
    
    EVLiveImageTableView *liveImageTableView = [[EVLiveImageTableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    liveImageTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 157);
    [mainScrollView addSubview:liveImageTableView];
    self.liveImageTableView = liveImageTableView;
    [liveImageTableView updateWatchCount:self.chatRoom.membersCount];
    [liveImageTableView addRefreshFooterWithRefreshingBlock:^{
        [weakself loadHistoryData];
    }];
    
    EVNullDataView *nullDataView = [[EVNullDataView alloc] init];
    nullDataView.title = @"牛人快来直播吧";
    nullDataView.topImage = [UIImage imageNamed:@"ic_smile"];
    nullDataView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 157);
    [mainScrollView addSubview:nullDataView];
    self.liveImageNullDataView = nullDataView;
   
    
    EVHVWatchStockView *dataView = [[EVHVWatchStockView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 108)];
    [mainScrollView addSubview:dataView];
    self.watchStockView = dataView;
    dataView.backgroundColor =[UIColor evBackgroundColor];
    self.watchStockView.hidden = YES;
    
    EVTextLiveChatTableView *textLiveChatTableView = [[EVTextLiveChatTableView alloc] init];
    textLiveChatTableView.frame = CGRectMake(ScreenWidth * 2, 11, ScreenWidth, ScreenHeight - 157);
    [mainScrollView addSubview:textLiveChatTableView];
    self.textLiveChatTableView = textLiveChatTableView;
    textLiveChatTableView.backgroundColor = [UIColor evBackgroundColor];
    textLiveChatTableView.tDelegate = self;
    [textLiveChatTableView updateWatchCount:self.textLiveModel.viewcount];
    [textLiveChatTableView addRefreshHeaderWithRefreshingBlock:^{
        [weakself loadHistoryData];
    }];
    
    EVNotOpenView *notOpenView = [[EVNotOpenView alloc] init];
    [mainScrollView addSubview:notOpenView];
    notOpenView.frame = CGRectMake(ScreenWidth * 3, 0, ScreenWidth, ScreenHeight - 108);
    self.view.backgroundColor = [UIColor evBackgroundColor];
    
    
    UIControl *touchLayer = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    touchLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.navigationController.view addSubview:touchLayer];
    touchLayer.hidden = YES;
    self.touchLayer = touchLayer;
    [touchLayer addTarget:self action:@selector(touchHide) forControlEvents:(UIControlEventTouchUpInside)];
    
    EVTextLiveToolBar *textLiveToolBar = [[EVTextLiveToolBar alloc] init];
    [self.navigationController.view addSubview:textLiveToolBar];
    self.textLiveToolBar = textLiveToolBar;
    textLiveToolBar.delegate = self;
    [textLiveToolBar autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [textLiveToolBar autoPinEdgeToSuperviewEdge:ALEdgeRight];
    self.toolBarTextBottonF =    [textLiveToolBar autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    self.toolBarTextViewHig =    [textLiveToolBar autoSetDimension:ALDimensionHeight toSize:49];
    

    textLiveToolBar.inputTextView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        if (text.length <= 0) {
            weakself.toolBarTextViewHig.constant = 49;
            return;
        }
        if (weakself.chooseIndex == 0) {
            weakself.toolBarTextViewHig.constant = textHeight + 16;
            weakself.toolBarTextBottonF.constant  = - weakself.keyBoardHig - 36;
        }else if(self.chooseIndex == 2 ) {
            weakself.toolBarTextViewHig.constant = textHeight + 16;
            weakself.toolBarTextBottonF.constant  = - weakself.keyBoardHig ;
            weakself.chatToolBarTextViewHig.constant = textHeight + 16;
            weakself.chatToolBarTextBottonF.constant  = - weakself.keyBoardHig;
        }
        
    };
    
    
    
    EVSendImageView *sendImageView = [[EVSendImageView alloc] init];
    [self.navigationController.view addSubview:sendImageView];
    self.sendImageView = sendImageView;
    sendImageView.delegate = self;
    self.segmentedIndex = 0;
    sendImageView.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    [sendImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [sendImageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [sendImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:textLiveToolBar];
    self.sendImageViewHig =    [sendImageView autoSetDimension:ALDimensionHeight toSize:0];
    
    
    [EVNotificationCenter addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [EVNotificationCenter addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    EVHVStockTextView *stockTextView  = [[EVHVStockTextView alloc] init];
    [self.view addSubview:stockTextView];
    stockTextView.hidden = YES;
    stockTextView.frame = CGRectMake(0, ScreenHeight - 108, ScreenWidth, 49);
    stockTextView.delegate = self;
    self.stockTextView = stockTextView;
    stockTextView.backgroundColor = [UIColor whiteColor];
    
    
    EVNotOpenView *notOpenStockView = [[EVNotOpenView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 157)];
    [mainScrollView addSubview:notOpenStockView];
    notOpenStockView.imageName = @"ic_watch_stock_not_data";
    notOpenStockView.titleStr = @"搜索你想了解的股票";
    self.notOpenStockView = notOpenStockView;
    notOpenStockView.backgroundColor = [UIColor evBackgroundColor];
}


- (void)addShareView
{
    [self.view addSubview:self.eVSharePartView];
    WEAK(self)
    self.eVSharePartView.cancelShareBlock = ^() {
        weakself.textLiveToolBar.hidden = NO;
        weakself.stockTextView.hidden = NO;
        [weakself changeViewHideIndex:weakself.chooseIndex];
        [UIView animateWithDuration:0.3 animations:^{
            weakself.eVSharePartView.frame = CGRectMake(0, ScreenHeight, ScreenHeight, ScreenHeight - 64);
        }];
    };
}

#pragma mark - 显示小红花
- (void)addGiftAniView
{
    EVHVGiftAniView *hvGiftAniView = [[EVHVGiftAniView alloc] init];
    [self.view addSubview:hvGiftAniView];
    self.hvGiftAniView = hvGiftAniView;
    [hvGiftAniView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16];
    [hvGiftAniView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:65];
    [hvGiftAniView autoSetDimensionsToSize:CGSizeMake(80, 190)];
    [self.view bringSubviewToFront:self.hvGiftAniView];
    hvGiftAniView.backgroundColor = [UIColor clearColor];
}



- (void)SGSegmentedIndex:(NSInteger)index
{
    self.segmentedIndex = index;
}

- (void)longPressModel:(EVEaseMessageModel *)model
{
    if (![model.fromName isEqualToString:[EVLoginInfo localObject].name]) {
        self.textLiveToolBar.inputTextView.text = [NSString stringWithFormat:@"回复%@ ",model.nickname];
        self.rpName = self.textLiveToolBar.inputTextView.text;
        self.rpContent = model.text;
        [self.textLiveToolBar.inputTextView textDidChange];
        [self.textLiveToolBar.inputTextView becomeFirstResponder];
    }
}

- (void)keyBoardShow:(NSNotification *)notification
{
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyBoardHig = frame.size.height;
    if (self.chooseIndex == 0) {
        self.sendImageView.cameraBtn.hidden = YES;
        self.sendImageView.photoBtn.hidden = YES;
        self.touchLayer.hidden =  NO;
        self.toolBarTextBottonF.constant  =  - frame.size.height - 36;
        self.sendImageViewHig.constant = 36;
    }
    else if (self.chooseIndex == 1)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.stockTextView.frame = CGRectMake(0, ScreenHeight - frame.size.height - 108, ScreenWidth, 49);
        }];
    }else if (self.chooseIndex == 2) {
        self.touchLayer.hidden =  NO;
        self.toolBarTextBottonF.constant  =  - frame.size.height;
    }
   
}

- (void)chooseImageButton:(UIButton *)btn
{
    if (self.chooseIndex == 0) {
        btn.selected = YES;
        self.isChooseImageButton = YES;
        self.sendImageView.cameraBtn.hidden = NO;
        self.sendImageView.photoBtn.hidden = NO;
        [self.textLiveToolBar.inputTextView resignFirstResponder];
    }
}

- (void)keyBoardHide:(NSNotification *)notification
{
    if (self.chooseIndex == 0) {
        if (self.isChooseImageButton) {
            self.sendImageView.imageButtonBottonHig.constant = 105;
            self.sendImageViewHig.constant = 36+105;
            self.toolBarTextBottonF.constant = -105 - 36;
        }else {
            self.keyBoardHig = 0;
            self.toolBarTextBottonF.constant = 0;
            self.sendImageViewHig.constant = 0;
        }
    }
    else if (self.chooseIndex == 1)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.stockTextView.frame = CGRectMake(0, ScreenHeight - 108, ScreenWidth, 49);
        }];
    }
    else if(self.chooseIndex == 2)
    {
         self.keyBoardHig = 0;
        self.toolBarTextBottonF.constant = 0;
    }
   
 
}
- (void)touchHide
{
    self.sendImageView.cameraBtn.hidden = YES;
    self.sendImageView.photoBtn.hidden = YES;
    self.toolBarTextBottonF.constant = 0;
    self.sendImageViewHig.constant = 0;
    self.touchLayer.hidden = YES;
   
    if (self.chooseIndex == 0)
    {
        if ([self.textLiveToolBar.inputTextView canResignFirstResponder]) {
            self.isChooseImageButton = NO;
            [self.textLiveToolBar.inputTextView resignFirstResponder];
        }else {
            self.isChooseImageButton = YES;
        }
    }
    else if (self.chooseIndex == 2)
    {
        [self.textLiveToolBar.inputTextView resignFirstResponder];
    }
    
}

- (void)chooseButton:(UIButton *)btn
{
    switch (btn.tag) {
        case 1000:
        {
            [self addCarema];
        }
            break;
        case 1001:
        {
            [self addOpenLibrary];
        }
            break;
        default:
            break;
    }
}

- (void)searchButton
{
    [self.baseToolManager getSearchInfosWith:self.stockTextView.stockTextFiled.text type:EVSearchTypeStock start:0 count:20 startBlock:nil fail:^(NSError *error) {
        
    } success:^(NSDictionary *dict) {
        
        NSArray *dataArr  = [EVStockBaseModel objectWithDictionaryArray:dict[@"data"]];
        
        if (dataArr.count !=0) {
            self.notOpenStockView.hidden = YES;
            self.watchStockView.hidden = NO;
        }else {
            [EVProgressHUD showMessage:@"您的输入有误，请重新输入"];
        }
        self.watchStockView.dataArray = dataArr;
    } sessionExpire:^{
        
    } reterrBlock:nil];
    [self.stockTextView.stockTextFiled resignFirstResponder];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备上没有摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
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
        [EVProgressHUD showMessage:@"请检查该图片是否存在本机相册中"];
    }
    else
    {
        [self sendImageMessage:editImage];
    }
}

- (void)sendImageMessage:(UIImage *)image
{
    self.liveImageNullDataView.hidden = YES;
    NSData *data = UIImageJPEGRepresentation(image, 1);
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithData:data displayName:@"image.png"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[EVLoginInfo localObject].nickname forKey:@"nk"];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.conversation.conversationId from:from to:self.conversation.conversationId body:body ext:dict];
    
    message.chatType = EMChatTypeChatRoom;// 设置为聊天室消息
    
        WEAK(self)
        [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
            NSLog(@"proress--------------   %d",progress);
        } completion:^(EMMessage *aMessage, EMError *aError) {
            NSLog(@"aerror-------  %@",aError);
            if (!aError) {
                [self uploadHooviewDataExt:aMessage.ext message:aMessage imageType:@"img" image:image];
                [weakself _refreshAfterSentMessage:aMessage];
            }
            else {
                [weakself.liveImageTableView reloadData];
            }
        }];
}
- (void)sendMessageBtn:(UIButton *)btn textToolBar:(EVTextLiveToolBar *)textToolBar
{
    self.liveImageNullDataView.hidden = YES;
    NSString *chatViewText;
    if (textToolBar  == self.chatLiveToolBar) {
        chatViewText = self.chatLiveToolBar.inputTextView.text;
    }else {
        chatViewText = self.textLiveToolBar.inputTextView.text;
    }
  
    NSString *from = [[EMClient sharedClient] currentUsername];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *messageType;
    switch (self.segmentedIndex) {
        case 0:
        {
           messageType = @"nor";
        }
            break;
        case 1:
        {
            messageType = @"hl";
        }
            break;
        case 2:
        {
            messageType = @"st";
        }
            break;
            
        default:
            break;
    }

    [dict setValue:messageType forKey:@"tp"];
    [dict setValue:[EVLoginInfo localObject].nickname forKey:@"nk"];
    if (self.rpName != nil && ![self.rpName isEqualToString:@""]) {
        if ([chatViewText rangeOfString:self.rpName].location != NSNotFound) {
            NSString *chatS = chatViewText;
            chatViewText = [chatViewText substringWithRange:NSMakeRange(self.rpName.length,chatS.length - self.rpName.length)];
            NSString *rct = [NSString stringWithFormat:@"%@%@",self.rpName,self.rpContent];
            [dict setObject:rct forKey:@"rct"];
            [dict setValue:@"rp" forKey:@"tp"];
        }
    }
    
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:chatViewText];
  
    self.rpName = nil;
    self.rpContent = nil;
    //生成Message

    [self touchHide];
    
    EMMessage *message = [[EMMessage alloc] initWithConversationID:_conversation.conversationId from:from to:_conversation.conversationId body:body ext:dict];
    message.chatType = EMChatTypeChatRoom;
    __weak typeof(self) weakself = self;
    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
    } completion:^(EMMessage *aMessage, EMError *aError) {
        if (!aError) {
            [weakself uploadHooviewDataExt:aMessage.ext message:aMessage imageType:@"txt" image:nil];
            [weakself _refreshAfterSentMessage:aMessage];
        }
        else {
            [weakself.liveImageTableView reloadData];
        }
    }];
}



- (void)addTextWindowView
{
 

}

- (void)showKeyBoardClick
{
    EVLog(@"弹出键盘");
    [self addTextWindowView];
}

- (void)_refreshAfterSentMessage:(EMMessage *)message
{
    EVEaseMessageModel *easeMessageModel = [[EVEaseMessageModel alloc] initWithMessage:message];
    if (easeMessageModel.state == EVEaseMessageTypeStateSt) {
        [self.liveImageTableView updateTpMessageModel:easeMessageModel];
    }else {
//        if ([message.from isEqualToString:[EVLoginInfo localObject].imuser]) {
//            [self.liveImageTableView updateMessageModel:easeMessageModel];
//        }
         [self.liveImageTableView updateMessageModel:easeMessageModel];
    }
    EVEaseMessageModel *chatEaseMessageModel = [[EVEaseMessageModel alloc] initWithChatMessage:message];
   
    [self.textLiveChatTableView updateMessageModel:chatEaseMessageModel];
}

- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index
{
    CGFloat offsetX = index * self.view.frame.size.width;
    self.mainScrollView.contentOffset = CGPointMake(offsetX, 0);
    [self changeViewHideIndex:index];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.mainScrollView) {
        NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
        [self changeViewHideIndex:index];
        [self.topSView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
    }
}

- (void)changeViewHideIndex:(NSInteger)index
{
    self.chooseIndex = index;
    if (index == 0) {
        self.hvGiftAniView.hidden = NO;
        self.textLiveToolBar.hidden = NO;
         self.stockTextView.hidden = YES;
    }else if(index == 1){
        self.hvGiftAniView.hidden = YES;
        self.stockTextView.hidden = NO;
        self.textLiveToolBar.hidden = YES;
    }else if (index == 2) {
        self.hvGiftAniView.hidden = YES;
         self.stockTextView.hidden = YES;
        self.textLiveToolBar.hidden = NO;
    }else {
        self.hvGiftAniView.hidden = YES;
        self.textLiveToolBar.hidden = YES;
        self.stockTextView.hidden = YES;
    }
}




- (void)rightBarBtnClick
{
    [self shareViewShowAction];
}

- (void)leftBarBtnClick
{
    [self dismissVC];
}
#pragma mark - Private method
- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


//分享view
- (void)shareViewShowAction {

    self.textLiveToolBar.hidden = YES;
    self.stockTextView.hidden = YES;
   self.snopImage =  [self snapshot:self.navigationController.view];
    [UIView animateWithDuration:0.3 animations:^{
        self.eVSharePartView.frame = CGRectMake(0, 0, ScreenHeight, ScreenHeight - 64);
    }];
}

- (void)shareType:(EVLiveShareButtonType)type
{
    
        if (self.snopImage == nil) {
    
            [EVProgressHUD showError:@"截屏失败"];
    
        }

        ShareType shareType = ShareTypeMineTextLive;
    
        [UIImage gp_imageWithURlString:[EVLoginInfo localObject].logourl comoleteOrLoadFromCache:^(UIImage *image, BOOL loadFromLocal) {
            [[EVShareManager shareInstance] shareContentWithPlatform:type shareType:shareType titleReplace:[EVLoginInfo localObject].nickname descriptionReplaceName:@"" descriptionReplaceId:nil URLString:nil image:image outImage:self.snopImage];
        }];
}

- (void)dismissVC
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    EMError *Error;
    [[EMClient sharedClient].roomManager leaveChatroom:_textLiveModel.streamid error:&Error];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setTextLiveModel:(EVTextLiveModel *)textLiveModel
{
    _textLiveModel = textLiveModel;
    
    EMError *error = nil;
    //加入聊天室
    self.chatRoom = [[EMClient sharedClient].roomManager joinChatroom:_textLiveModel.streamid error:&error];
    EVLog(@"chatroom-------  %@ ---------  %ld ------ ",self.chatRoom,error.code);
    [self.liveImageTableView updateWatchCount:self.chatRoom.membersCount];
    //TODO:注册环信消息回调

    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].roomManager addDelegate:self];
   
    _conversation = [[EMClient sharedClient].chatManager getConversation:textLiveModel.streamid type:EMConversationTypeChatRoom createIfNotExist:YES];
    
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    
}

- (void)didReceiveMessages:(NSArray *)aMessages
{
    
    if (aMessages.count > 0) {
        self.liveImageNullDataView.hidden = YES;
    }
    for (EMMessage *umessage in aMessages) {
        
        NSUInteger i  = [aMessages indexOfObject:umessage];
        if (i == 0) {
             self.time = [NSString stringWithFormat:@"%lld",umessage.timestamp];
        }
       
        EVEaseMessageModel *easeMessageModel = [[EVEaseMessageModel alloc] initWithMessage:umessage];
        if (easeMessageModel.state == EVEaseMessageTypeStateSt) {
            [self.liveImageTableView updateTpMessageModel:easeMessageModel];
        }else {
            if ([umessage.from isEqualToString:[EVLoginInfo localObject].imuser]) {
                [self.liveImageTableView updateMessageModel:easeMessageModel];
            }
        }
        EVEaseMessageModel *chateaseMessageModel = [[EVEaseMessageModel alloc] initWithChatMessage:umessage];
        [self.textLiveChatTableView updateMessageModel:chateaseMessageModel];
        EMMessageBody *cmdBody = umessage.body;
        //收到小红花    
        if (cmdBody.type == EMMessageBodyTypeCmd) {
            [self messageGiftDict:umessage.ext model:umessage];
        }
//        if (cmdBody.type == EMMessageBodyTypeText) {
//            EMTextMessageBody *messageBody = (EMTextMessageBody *)umessage.body;
//            if ([messageBody.text isEqualToString:@"礼物"]) {
//                NSLog(@"如果消息为礼物0000000000000000:%@",[umessage messageId]);
//                NSLog(@"[umessage isRead]:%d",[umessage isRead]);
//                NSLog(@"[umessage isDeliverAcked]:%d",[umessage isDeliverAcked]);
//                NSLog(@"[umessage isReadAcked]:%d",[umessage isReadAcked]);
//                [self messageGiftDict:umessage.ext model:umessage];
////                EMError * error;
//               
//                [[EMClient sharedClient].chatManager sendMessageReadAck:umessage completion:nil];
//                [self.conversation markMessageAsReadWithId:umessage.messageId error:nil];
////                [[EMClient sharedClient].chatManager sendMessageReadAck:umessage completion:^(EMMessage *aMessage, EMError *aError) {
////                    NSLog(@"发送完消息已读回执:%d",[aMessage isRead]);
////                    NSLog(@"错误描述：%@",aError.errorDescription);
////                }];
////                [_conversation markAllMessagesAsRead:&error];
////                NSLog(@"错误描述：%@",error.errorDescription);
//            }
//        
//        }
    }
}

- (void)messageGiftDict:(NSDictionary *)dict model:(EMMessage *)model
{
    
    BOOL isContain = NO;
    for (EMMessage * temp in self.redFlowerArray) {
        if ([model.messageId isEqualToString:temp.messageId]) {
            isContain = YES;
            break;
        }
    }
    
    if (!isContain) {
        
        [self.redFlowerArray addObject:model];
        NSMutableDictionary *giftDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        EVStartGoodModel *goodModel = [EVStartGoodModel modelWithDict:giftDict];
        //TODO:添加小红花
        [self.hvGiftAniView addStartGoodModel:goodModel];
        
    }
    
   
}

- (void)messageAttachmentStatusDidChange:(EMMessage *)aMessage
                                   error:(EMError *)aError
{

    EMFileMessageBody *fileBody = (EMFileMessageBody*)[aMessage body];
    if ([fileBody type] == EMMessageBodyTypeImage) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)fileBody;
        if ([imageBody thumbnailDownloadStatus] == EMDownloadStatusSuccessed)
        {
            [self.liveImageTableView updateStateModel:aMessage];
        }
    }
   
}

- (void)uploadHooviewDataExt:(NSDictionary *)ext message:(EMMessage *)message imageType:(NSString *)type image:(UIImage *)image
{
    NSString *msg;
    if (EMMessageBodyTypeText == message.body.type) {
        EMTextMessageBody *messageBody = (EMTextMessageBody *)message.body;
        msg = messageBody.text;
    }else {
        
    }
    NSString *time = [NSString stringWithFormat:@"%lld",message.timestamp];
    
    [self.baseToolManager POSTChatTextLiveID:self.textLiveModel.streamid from:message.from nk:ext[@"nk"] msgid:message.messageId msgtype:type msg:msg tp:ext[@"tp"] rct:ext[@"rct"] rnk:ext[@"rnk"] timestamp:time img:image success:^(NSDictionary *retinfo) {
        EVLog(@"成功-------------- %@",retinfo);
    } error:^(NSError *error) {
        EVLog(@"error---------------message--- %@",error);
    }];
}


- (void)loadHistoryData
{
    NSDate *senddate = [NSDate date];
    
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    EVLog(@"date2时间戳 = %@",date2);
    WEAK(self)
    weakself.isRefresh = YES;
    [self.baseToolManager GETHistoryTextLiveStreamid:self.textLiveModel.streamid count:@"20" start:@"0"stime:self.time success:^(NSDictionary *retinfo) {
        EVLog(@"successsjhdahj  %@",retinfo);
        [weakself.liveImageTableView endFooterRefreshing];
        [weakself.textLiveChatTableView endHeaderRefreshing];
        if ([retinfo[@"reterr"] isEqualToString:@"OK"]) {
            [weakself.historyArray removeAllObjects];
            [weakself.historyChatArray removeAllObjects];
            NSArray *msgsAry = retinfo[@"retinfo"][@"msgs"];
            if (weakself.isRefresh == YES || [retinfo[@"retinfo"][@"start"] integerValue] != 0) {
                for (NSDictionary *msgDict in msgsAry) {
                    weakself.time = [NSString stringWithFormat:@"%@",msgDict[@"timestamp"]];
                    if ([msgDict[@"from"] isEqualToString:[EVLoginInfo localObject].name]) {
                        EVEaseMessageModel *messageModel = [[EVEaseMessageModel alloc] initWithHistoryMessage:msgDict];
                        [weakself.historyArray addObject:messageModel];
                    }else {
                       
                    }
                    EVEaseMessageModel *chatModel = [[EVEaseMessageModel alloc] initWithHistoryChatMessage:msgDict];
                    [weakself.historyChatArray addObject:chatModel];
                }
                
                [weakself.liveImageTableView updateHistoryArray:self.historyArray];
                [weakself.textLiveChatTableView updateHistoryArray:self.historyChatArray];
            }
            [weakself.liveImageTableView setFooterState:(msgsAry.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
            weakself.isRefresh = NO;
        }
    } error:^(NSError *error) {
        weakself.isRefresh = NO;
        [weakself.liveImageTableView endFooterRefreshing];
        [weakself.textLiveChatTableView endHeaderRefreshing];
    }];
}
#pragma mark - 收到环信透传消息
- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages
{
    //主要用于显示小红花
    if (!isDisplayflower) {
        return;
    }
    for (EMMessage *umessage in aCmdMessages)
    {
        [self messageGiftDict:umessage.ext model:umessage];
    }
}


- (void)userDidJoinChatroom:(EMChatroom *)aChatroom
                       user:(NSString *)aUsername
{
    self.textLiveModel.viewcount++;
    [self.liveImageTableView updateWatchCount:self.textLiveModel.viewcount];
}
- (void)userDidLeaveChatroom:(EMChatroom *)aChatroom
                        user:(NSString *)aUsername
{
    self.textLiveModel.viewcount--;
    [self.liveImageTableView updateWatchCount:self.textLiveModel.viewcount];
}
#pragma mark - lazy loading
- (EVSharePartView *)eVSharePartView {
    if (!_eVSharePartView) {
        _eVSharePartView = [[EVSharePartView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - 64)];
        _eVSharePartView.backgroundColor = [UIColor colorWithHexString:@"#303030" alpha:0.7];
        
    }
    return _eVSharePartView;
}

- (void)dealloc
{
    EVLog(@"EVMyTextLiveViewController dealloc");
    [EVNotificationCenter removeObserver:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
    EMError *Error;
    [[EMClient sharedClient].roomManager leaveChatroom:_textLiveModel.streamid error:&Error];
}


- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}


- (NSMutableArray *)redFlowerArray
{
    if (!_redFlowerArray) {
        _redFlowerArray = [NSMutableArray array];
    }
    return _redFlowerArray;
}
- (NSMutableArray *)historyArray
{
    if (!_historyArray) {
        _historyArray = [NSMutableArray array];
    }
    return _historyArray;
}
- (NSMutableArray *)historyChatArray
{
    if (!_historyChatArray) {
        _historyChatArray = [NSMutableArray array];
    }
    return _historyChatArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
