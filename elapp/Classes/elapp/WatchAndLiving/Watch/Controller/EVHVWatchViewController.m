//
//  EVHVWatchViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/7.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVWatchViewController.h"
#import "EVHVWatchTopView.h"
#import "EVHVWatchCenterView.h"
#import "EVHVWatchBottomView.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVVideoPlayer.h"
#import "EVRecordControlView.h"
#import "EVSDKLiveEngineParams.h"
#import "NSObject+Extension.h"
#import "EVSDKLiveMessageEngine.h"
#import "EVLoginInfo.h"
#import "EVHVChatTextView.h"
#import "EVMessageManager.h"
#import "EVComment.h"
#import "EVHVChatView.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVStartResourceTool.h"
#import "EVMagicEmojiView.h"
#import "EVYunBiViewController.h"
#import "EVUserAsset.h"
#import "EVHVStockTextView.h"
#import "EVHVVideoCoverView.h"
#import "EVStartGoodModel.h"
#import "AppDelegate.h"
#import "EVSharePartView.h"
#import "EVBaseToolManager+EVSearchAPI.h"
#import "EVHVWatchStockView.h"
#import "EVStockBaseModel.h"
#import "EVNotOpenView.h"
#import "EVBaseToolManager+EVHomeAPI.h"
#import "EVHVVideoCommentView.h"
#import "EVHVVideoCommentModel.h"
#import "EVShareManager.h"
#import "EVVipCenterViewController.h"
#import "EVLoginViewController.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "YZInputView.h"
#import "EVNetWorkStateManger.h"
#import "EVVipCenterController.h"


#import "EVPayVideoCoverView.h"
#import "EVVideoPayBottomView.h"
#define VideoWidth (ScreenWidth * 210)/375


@interface EVHVWatchViewController ()<EVHVWatchTopViewDelegate,EVVideoPlayerDelegate,EVRecordControlViewDelegate,EVSDKMessageDelegate,EVHVChatTextViewDelegate,UITextFieldDelegate,CCMagicEmojiViewDelegate,EVYiBiViewControllerDelegate,EVHVStockTextViewDelegate,EVHVWatchBottomViewDelegate,EVHVWatchCenterViewDelegate,EVWebViewShareViewDelegate>
{
    // 录播使用的
    dispatch_source_t _recordPlayTimer;
    dispatch_queue_t _recordPlayTimerQueue;
}
@property (nonatomic, weak) UIView *videoView;

@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) EVVideoPlayer *evPlayer;

@property (nonatomic, weak) EVHVWatchTopView *watchTopView;

@property (nonatomic, weak) EVRecordControlView *recordControlView;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) EVSDKLiveMessageEngine *liveMessageEngine;


/**
 聊天 view
 */
@property (nonatomic, weak) EVHVChatTextView *chatTextView;

@property (nonatomic, strong) NSLayoutConstraint *chatTextViewHig;

@property (nonatomic, strong) NSLayoutConstraint *chatTextViewBom;

@property (nonatomic, strong) UIButton *blackBackView;

@property (nonatomic, assign) BOOL isJoinTopic;

@property (nonatomic, weak) EVHVWatchBottomView *watchBottomView;

@property (nonatomic, weak) EVHVWatchCenterView *watchCenterView;

@property (nonatomic, weak) EVMagicEmojiView *magicEmojiView;

@property (strong, nonatomic) EVUserAsset *asset;  /**< 用户资产信息 */

/**
 搜索股票输入框
 */
@property (nonatomic, weak) EVHVStockTextView *stockTextView;

@property (nonatomic, assign) NSInteger scrollViewIndex;

@property (nonatomic, assign) BOOL isLoadingVideoData;

@property (nonatomic, strong) EVHVVideoCoverView *videoCoverView;

@property (nonatomic, strong) EVHVVideoCoverView *liveloadingView;

@property (nonatomic, strong) EVHVVideoCoverView *videoEndCoverView;

@property (nonatomic, strong) EVPayVideoCoverView * videoPayCoverView;
@property (nonatomic, weak) UIView *topViewContentView;

@property (nonatomic, weak) UIView *videoPlayView;

@property (nonatomic, assign) BOOL isPullScreen;

@property (nonatomic, weak) UIView *statusView;

@property (nonatomic, strong) EVSharePartView *eVSharePartView;

@property (nonatomic, strong) EVHVVideoCoverView *playCompleteView;

@property (nonatomic, strong) EVStartGoodModel *startGoodModel;

//付费


/**
 付费 支付底部弹窗view
 */
@property (nonatomic, strong) EVVideoPayBottomView * payBottomView;
@end

@implementation EVHVWatchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
   
    [self.evPlayer pause];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollViewIndex = 0;

    
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [EVNotificationCenter addObserver:self selector:@selector(successLogin:) name:@"newUserRefusterSuccess" object:nil];
    [EVNotificationCenter addObserver:self selector:@selector(watchVideoNetworkChanged:) name:CCNetWorkChangeNotification object:nil];
    [self addUpView];
    
    [self loadWatchStartData];
    
    [self loadVideoData];
    [self loadMyAssetsData];
    WEAK(self)
    [self.watchBottomView.chatView.chatTableView addRefreshHeaderWithRefreshingBlock:^{
        [weakself.liveMessageEngine loadMoreHistoryDataSuccess:^{
            [weakself.watchBottomView.chatView.chatTableView endHeaderRefreshing];
        }];
    }];
}

- (void)watchVideoNetworkChanged:(NSNotification *)notification {
    NSNumber *statusNumber = [notification.userInfo objectForKey:CCNetWorkStateKey];
    EVNetworkStatus status = [statusNumber integerValue];
    if (status == WithoutNetwork) {
        self.videoCoverView.topImage = [UIImage imageNamed:@"ic_gray_logo"];
        NSString *noNetNoticeTitle;
        if (self.watchVideoInfo.living == 1) {
            noNetNoticeTitle = @"直播已断开，请稍后";
        }
        else if (self.watchVideoInfo.living == 0) {
            noNetNoticeTitle = @"回放已断开，请稍后";
        }
        else {
            noNetNoticeTitle = @"网络已断开";
        }
        self.videoCoverView.titleStr = noNetNoticeTitle;
        self.videoCoverView.hidden = NO;
        [self.videoView bringSubviewToFront:self.videoCoverView];
        [self.evPlayer pause];
    }
    else {
        self.videoCoverView.hidden = YES;
        [self.evPlayer play];
    }
}

- (void)successLogin:(NSNotification *)notifucation
{
     [self loadMyAssetsData];
    _liveMessageEngine.userData = [EVLoginInfo localObject].name;
    [_liveMessageEngine loginConnect];
}
- (void)setVideoAndLiveModel:(EVVideoAndLiveModel *)videoAndLiveModel
{
    if (!videoAndLiveModel) {
        return;
    }
    if (!_watchVideoInfo) {
        _watchVideoInfo = [[EVWatchVideoInfo alloc] init];
    }
    _videoAndLiveModel = videoAndLiveModel;
    _watchVideoInfo.vid = videoAndLiveModel.vid;
    _watchVideoInfo.mode = [videoAndLiveModel.mode integerValue];
    _watchVideoInfo.permission = videoAndLiveModel.permission;
}

#pragma mark - 获取视频信息   开始播放
- (void)loadWatchStartData
{
    WEAK(self)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if ( self.watchVideoInfo.vid )
    {
        param[kVid] = self.watchVideoInfo.vid;
    }
    

//    [EVProgressHUD showIndeterminateForView:self.view];
    // 获取视频信息
    [self.baseToolManager GETUserstartwatchvideoWithParams:param Start:^{
        
    } fail:^(NSError *error) {
//        [EVProgressHUD hideHUDForView:self.view];
        if ([error.userInfo[@"reterr"] isEqualToString:@"晚到一步，已被主播焚掉啦"]) {
            [EVProgressHUD showError:error.userInfo[@"reterr"]];
              [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        [EVProgressHUD showError:@"获取失败"];
    } success:^(NSDictionary *videoInfo) {
        [EVProgressHUD hideHUDForView:self.view];
        [weakself successLivingDataVideoInfo:videoInfo];
    } sessionExpire:^{
        [EVProgressHUD hideHUDForView:self.view];
        EVRelogin(weakself);
    }];
}

//获取关注信息
- (void)loadVideoData
{
    WEAK(self)

    [self.baseToolManager GETBaseUserInfoWithPersonid:self.watchVideoInfo.name start:^{
        
    } fail:^(NSError *error) {
        
    } success:^(NSDictionary *modelDict) {
        weakself.watchCenterView.isFollow = [modelDict[@"followed"] boolValue];
        weakself.isLoadingVideoData = YES;
        // 有些时候 weakself.watchVideoInfo 会是 [EVNowVideoItem] 类型的 why?
        if ([weakself.watchVideoInfo isKindOfClass:[EVWatchVideoInfo class]]) {
            weakself.watchVideoInfo.followed = [modelDict[@"followed"] boolValue];
        }

    } sessionExpire:^{
        
    }];
}

#pragma mark - 添加观看历史记录
- (void)addWatchHistory
{
    [self.baseToolManager ADDHistoryWithWatchVid:self.watchVideoInfo.vid fail:^(NSError *error) {
        
    } success:^(NSDictionary *retinfo) {
        
    } sessionExpire:^{
        
    }];
}

- (void)loadMyAssetsData
{
    WEAK(self)
    [self.baseToolManager GETUserAssetsWithStart:^{
        
    } fail:^(NSError *error) {
        EVLog(@"get asset fail");
    } success:^(NSDictionary *videoInfo) {
        EVLog(@"get asset success");
        self.asset = [EVUserAsset objectWithDictionary:videoInfo];
        [weakself updateAssetWithInfo:videoInfo];
    } sessionExpire:^{
        EVRelogin(weakself);
    }];
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

- (void)successLivingDataVideoInfo:(NSDictionary *)videoInfo
{
    _watchVideoInfo = [EVWatchVideoInfo objectWithDictionary:videoInfo];
   
    if ([_watchVideoInfo.permission integerValue] == 7 )
    {
        if ([_watchVideoInfo.price integerValue] == 0)
        {
            //付费直播 已经付费
            self.videoPayCoverView.hidden = YES;
        }
        else
        {
            //付费直播 没付费
            self.videoPayCoverView.hidden = NO;
            NSString * price = _watchVideoInfo.price;
            NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@豆",price]];
            [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, price.length)];
            [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor evEcoinColor] range:NSMakeRange(0, price.length)];
            self.videoPayCoverView.viewPriceLabel.attributedText = attributeString;
        }
    }
        
    
    
    [self addChatTextView];
    [self addPresentListView];
    if (self.watchVideoInfo.uri != nil) {
        [self configPlayer];
    }
    if (self.watchVideoInfo.mode == 2) {
        [self addMediaControlView];
        [self startRecordPlayTimer];
        self.watchBottomView.videoCommentView.hidden = NO;
        self.watchBottomView.chatView.hidden = YES;
        [self chatNotSendGiftView:0];
        self.watchBottomView.videoCommentView.watchVideoInfo = self.watchVideoInfo;
    }else {
        if (self.watchVideoInfo.living == 0) {
            [self addLiveMessageEngine];
            [self addMediaControlView];
            [self startRecordPlayTimer];
        }else if (self.watchVideoInfo.living == 1){
            [self addLiveMessageEngine];
            self.watchTopView.pauseButton.hidden = YES;
            [self startRecordPlayTimer];
        }
    }
    self.watchCenterView.watchVideoInfo = self.watchVideoInfo;
}

- (void)livingAndEndLivingWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo videoInfo:(NSDictionary *)videoInfo
{
    
    
}

- (void)configPlayer
{
    // 直播加速
    NSString *play_url = [self.watchVideoInfo.uri mutableCopy];
    self.evPlayer = [[EVVideoPlayer alloc] initWithContentURL:play_url];
    EVLog(@"---------init player---------- %@",play_url);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, VideoWidth)];
    [self.videoView addSubview:view];
    self.videoPlayView = view;
    self.evPlayer.vid = self.watchVideoInfo.vid;
    self.evPlayer.delegate = self;
    self.evPlayer.scalingMode = MPMovieScalingModeFill;
    self.evPlayer.presentview = view;
    [self.view bringSubviewToFront:self.chatTextView];
//    if ([self.watchVideoInfo.horizontal isEqualToString:@"1"]) {
//        self.evPlayer.needRotate = YES;
//    }
    if ([_watchVideoInfo.permission integerValue] != 7) {
        //如果不是付费直播  则直接播放
        [self.evPlayer play];
    }
    else if ([_watchVideoInfo.price integerValue] == 0)
    {
        //已经付费了
        [self.evPlayer play];
    }
    [self topViewHideView];
    [self.videoView addSubview:self.playCompleteView];
    
    [self addWatchHistory];
}

- (void)addUpView
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    contentView.backgroundColor = [UIColor evBackgroundColor];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    UIView *topViewContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, VideoWidth+20)];
    topViewContentView.backgroundColor = [UIColor evBackgroundColor];
    [self.view addSubview:topViewContentView];
    self.topViewContentView = topViewContentView;
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    statusView.backgroundColor = [UIColor blackColor];
    [topViewContentView addSubview:statusView];
    self.statusView = statusView;
    
    
    UIView *videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, VideoWidth)];
    videoView.backgroundColor = [UIColor clearColor];
    [topViewContentView addSubview:videoView];
    self.videoView = videoView;
    
    if (self.watchVideoInfo.mode == 2 || self.watchVideoInfo.living == 0) {
        self.liveloadingView.titleStr = @"视频加载中";
    }
    [videoView addSubview:self.videoCoverView];
    [videoView addSubview:self.liveloadingView];
  
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.videoView addGestureRecognizer:singleTap];
    
    
    
    EVHVWatchTopView *watchTopView = [[EVHVWatchTopView alloc] init];
    watchTopView.frame = CGRectMake(0, 20, ScreenWidth, VideoWidth);
    [topViewContentView addSubview:watchTopView];
    watchTopView.delegate = self;
    self.watchTopView = watchTopView;
    
    
    //如果为付费直播
    if ([_watchVideoInfo.permission integerValue] == 7) {
        [topViewContentView addSubview:self.videoPayCoverView];
        watchTopView.shareButton.hidden = YES;
    }

 
    EVHVWatchCenterView *centerView = [[EVHVWatchCenterView alloc] init];
    centerView.frame = CGRectMake(0, VideoWidth+20, ScreenWidth, 91);
    [contentView addSubview:centerView];
    centerView.delegate = self;
    self.watchCenterView = centerView;
    
    CGRect bottomView = CGRectMake(0, VideoWidth+116, ScreenWidth, ScreenHeight - VideoWidth - 116);
    NSMutableArray *titleArr = [NSMutableArray array];
    
    if (self.watchVideoInfo.mode == 2) {
        NSArray *tArr = @[@"评论",@"数据",@"秘籍"];
        titleArr = [NSMutableArray arrayWithArray:tArr];
    }else {
        if (self.watchVideoInfo.living == 0) {
            NSArray *tArr = @[@"聊天",@"数据",@"秘籍"];
            titleArr = [NSMutableArray arrayWithArray:tArr];
        }else if (self.watchVideoInfo.living == 1) {
            NSArray *tArr = @[@"聊天",@"数据",@"秘籍"];
            titleArr = [NSMutableArray arrayWithArray:tArr];
        }
    }
    EVHVWatchBottomView *watchBottomView = [[EVHVWatchBottomView alloc] initWithFrame:bottomView titleArray:titleArr];
    watchBottomView.isLiving = self.watchVideoInfo.mode;
    [contentView addSubview:watchBottomView];
    watchBottomView.delagate = self;
    self.watchBottomView = watchBottomView;
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    self.watchTopView.hidden = NO;
     [self.watchTopView gestureHideView];
}

- (void)topViewHideView
{
    if (self.watchTopView.hidden == NO) {
        [self.watchTopView gestureHideView];
    }
}
#pragma mark - 添加聊天输入框
- (void)addChatTextView
{
    _blackBackView = [[UIButton alloc] init];
    _blackBackView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _blackBackView.alpha = 0.5;
    _blackBackView.backgroundColor = [UIColor blackColor];
    [_blackBackView addTarget:self action:@selector(backViewClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_blackBackView];
    _blackBackView.hidden = YES;
    
    EVHVChatTextView *chatTextView = [[EVHVChatTextView alloc] init];
//    chatTextView.frame = CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49);
    [self.view addSubview:chatTextView];
    chatTextView.backgroundColor = [UIColor whiteColor];
    chatTextView.delegate = self;
//    chatTextView.commentBtn.delegate = self;
    _chatTextView = chatTextView;
    [chatTextView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [chatTextView autoPinEdgeToSuperviewEdge:ALEdgeRight];
  self.chatTextViewHig =   [chatTextView autoSetDimension:ALDimensionHeight toSize:49];
   self.chatTextViewBom =  [chatTextView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    WEAK(self)
    chatTextView.commentBtn.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        if (text.length <= 0) {
            weakself.chatTextViewHig.constant = 49;
            return;
        }
        weakself.chatTextViewHig.constant = textHeight + 16;
    };
    chatTextView.commentBtn.yz_beginTouchBlock = ^() {
        if (![EVLoginInfo hasLogged]) {
            [chatTextView resignFirstResponder];
            
            UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];

            [self presentViewController:navighaVC animated:YES completion:nil];
        }
    };
    
    EVHVStockTextView *stockTextView  = [[EVHVStockTextView alloc] init];
    [self.view addSubview:stockTextView];
    stockTextView.hidden = YES;
    stockTextView.frame = CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49);
    stockTextView.delegate = self;
    self.stockTextView = stockTextView;
    stockTextView.backgroundColor = [UIColor whiteColor];
    
}

- (void)addMediaControlView
{
    EVRecordControlView *recordControlView = [[EVRecordControlView alloc] init];
    recordControlView.delegate = self;
    recordControlView.hidden = NO;
    [self.watchTopView addSubview:recordControlView];
    self.recordControlView = recordControlView;
    [self.recordControlView setUp];
    [self.watchTopView sendSubviewToBack:recordControlView];
    recordControlView.backgroundColor = [UIColor clearColor];
    self.recordControlView.frame = CGRectMake(0, self.watchTopView.bounds.size.height - 50, ScreenWidth, 50);
}

- (void)addPresentListView
{
    if ( [[EVStartResourceTool shareInstance] prensentEnable])
    {
        EVMagicEmojiView *magicEmojiView = [EVMagicEmojiView magicEmojiViewToTargetView:self.view];
        _magicEmojiView = magicEmojiView;
        _magicEmojiView.delegate = self;
       
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isKindOfClass:[self.chatTextView.commentBtn  class]]) {
        [self loginView];
    }
}

- (void)addLiveMessageEngine
{
    _liveMessageEngine = [[EVSDKLiveMessageEngine alloc]init];
    _liveMessageEngine.topicVid = _watchVideoInfo.vid;
    _liveMessageEngine.delegate = self;
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    _liveMessageEngine.userData = loginInfo.name;
    [_liveMessageEngine connectMessage];
    _liveMessageEngine.anchorName = self.watchVideoInfo.nickname;
}


- (void)successJoinTopic
{
    EVLog(@"success-------------");
    self.isJoinTopic = YES;
    [self.watchBottomView.chatView receiveSystemMessage:@"温馨提示：涉及色情，低俗，暴力等聊天内容将被封停账号。文明聊天，从我做起！"];
    [self.view addSubview:self.eVSharePartView];
    WEAK(self)
    self.eVSharePartView.cancelShareBlock = ^() {
        [UIView animateWithDuration:0.3 animations:^{
            if (weakself.isPullScreen) {
                weakself.eVSharePartView.frame = CGRectMake((ScreenWidth -ScreenHeight)/2, ScreenHeight, ScreenHeight, 169);
            }
            else
            {
                weakself.eVSharePartView.frame = CGRectMake(0, ScreenHeight, ScreenHeight, ScreenHeight);
            }
            
        } completion:^(BOOL finished) {
            weakself.eVSharePartView.hidden = YES;
        }];
    };
}

- (void)joinTopicIDNil
{
    EVLog(@"fail ------------------");
    self.isJoinTopic = NO;
}

- (void)backViewClick:(UIButton *)btn
{
//    if (self.isJoinTopic == YES) {
        if (self.blackBackView == nil || self.blackBackView.hidden == YES) {
//            [self.view addSubview:self.blackBackView];
        }else {
            if (self.scrollViewIndex == 0) {
                
            }else {
                
            }
            self.blackBackView.hidden = YES;
            [self.chatTextView.commentBtn resignFirstResponder];
            [self.stockTextView.stockTextFiled resignFirstResponder];
        }
//    }
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.blackBackView.hidden = NO;
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    
    if (self.scrollViewIndex == 0) {
        self.stockTextView.hidden = YES;
        [self.view bringSubviewToFront:self.chatTextView];
        self.chatTextView.hidden = NO;
        self.chatTextView.giftButton.hidden = YES;
        self.chatTextView.sendImageViewRig.constant = 0;
        self.chatTextView.commentBtnRig.constant = -67;
        self.chatTextViewBom.constant = -kbSize.height;
        [UIView animateWithDuration:0.3 animations:^{
            [self chatNotSendGiftView:kbSize.height];
        }];
    }else if (self.scrollViewIndex == 1) {
        [self.view bringSubviewToFront:self.stockTextView];
        self.stockTextView.hidden = NO;
        self.chatTextView.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.stockTextView.frame = CGRectMake(0, ScreenHeight - kbSize.height - 49, ScreenWidth, 49);
        }];
    }else {
        self.stockTextView.hidden = YES;
        self.chatTextView.hidden = YES;
    }
}

- (void)chatNotSendGiftView:(CGFloat)sizeHig
{
    self.chatTextView.giftButton.hidden = NO;
    self.chatTextView.sendImageViewRig.constant = 0;
    self.chatTextView.commentBtnRig.constant = -10;
//    self.chatTextView.frame = CGRectMake(0, ScreenHeight - sizeHig - 49, ScreenWidth, 49);
//    self.chatTextView.contentView.frame = CGRectMake(10, 4, ScreenWidth - 20, 40);
//    self.chatTextView.commentBtn.frame = CGRectMake(10, 4, ScreenWidth - 64, 32);
//    self.chatTextView.sendButton.frame = CGRectMake(ScreenWidth - 74,0, 54, 40);
}

- (void)chatTextSendGiftView
{
    self.chatTextView.giftButton.hidden = NO;
    self.chatTextView.sendImageViewRig.constant = -67;
    self.chatTextView.commentBtnRig.constant = -67;
//    self.chatTextView.frame = CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49);
//    self.chatTextView.contentView.frame = CGRectMake(10, 5, ScreenWidth -65, 40);
//    self.chatTextView.commentBtn.frame = CGRectMake(10, 0, ScreenWidth - 65, 40);
//    self.chatTextView.sendButton.frame = CGRectMake(ScreenWidth - 119, 0, 54, 40);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.blackBackView.hidden = YES;
    //NSDictionary* info = [notification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    if (self.scrollViewIndex == 0) {
        [self.view bringSubviewToFront:self.chatTextView];
        self.stockTextView.hidden = YES;
        self.chatTextViewBom.constant = 0;
       
        [UIView animateWithDuration:0.3 animations:^{
            if (self.watchVideoInfo.mode == 2) {
                [self chatNotSendGiftView:0];
            }else {
                [self chatTextSendGiftView];
            }
            
        }];
    }else if (self.scrollViewIndex == 1) {
        [self.view bringSubviewToFront:self.stockTextView];
        self.chatTextView.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.stockTextView.frame = CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49);
        }];
    }else {
        
    }
    
    
}

- (void)startRecordPlayTimer
{
    _recordPlayTimerQueue = dispatch_queue_create("cloudfocus.recordplay", DISPATCH_QUEUE_SERIAL);
    _recordPlayTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _recordPlayTimerQueue);
    dispatch_source_set_timer(_recordPlayTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __weak typeof(self) wself = self;
    dispatch_source_set_event_handler(_recordPlayTimer, ^{
        [wself recordTimerUpdate];
    });
    dispatch_resume(_recordPlayTimer);
}

- (void)stopRecordPlayTimer
{
    if ( _recordPlayTimer )
    {
        dispatch_source_cancel(_recordPlayTimer);
        _recordPlayTimer = nil;
    }
}

- (void)recordTimerUpdate
{
    [self performBlockOnMainThread:^{
        [self _recordTimerUpdate];
    }];
}

- (void)_recordTimerUpdate
{
    NSTimeInterval duration = _evPlayer.duration;
    NSInteger intDuration = duration + 0.5;
    NSInteger intBuffering = _evPlayer.playableDuration;
    NSTimeInterval position = _evPlayer.currentPlaybackTime;
    double intPosition = position + 0.5;
    [self updateRecorderProgressWithInfo:@{CCPLAYER_TIME_WHOLE_TIME: @(intDuration), CCPLAYER_TIME_CURR_TIME: @(intPosition), CCPLAYER_TIME_BUFFER_TIME: @(intBuffering)}];
    self.watchVideoInfo.currSecond = intPosition;
}


- (void)updateRecorderProgressWithInfo:(NSDictionary *)info
{
    double maxProgress = [info[CCPLAYER_TIME_WHOLE_TIME] doubleValue];
    double currProgress = [info[CCPLAYER_TIME_CURR_TIME] doubleValue];
    double bufferTime = [info[CCPLAYER_TIME_BUFFER_TIME] doubleValue];
    
    if ( maxProgress > 0 )
    {
        self.recordControlView.maxProgress = maxProgress;
        self.recordControlView.maxProgress = maxProgress;
    }
    if ( currProgress )
    {
        self.recordControlView.currProgress = currProgress;
        self.recordControlView.currProgress = currProgress;
    }
    if ( bufferTime )
    {
        self.recordControlView.bufferProgress = bufferTime;
        self.recordControlView.bufferProgress = bufferTime;
    }
}

- (void)backButton
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self destoryevPlayer];
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;//(以上2行代码,可以理解为打开横屏开关)
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.evPlayer shutdown];
    self.evPlayer = nil;
}
#pragma mark -delegate
#pragma mark - 播放控件点击
- (void)watchButttonClickType:(EVHVWatchViewType)type button:(UIButton *)button
{
    switch (type) {
        case EVHVWatchViewTypeBack:
        {
            if (self.isPullScreen) {
                //如果是全屏   旋转屏幕
                [self watchButttonClickType:EVHVWatchViewTypeFull button:_watchTopView.fullButton];
            }
            else
            {
                [self backButton];
            }
            
        }
        break;
        
        case EVHVWatchViewTypeFull:
        //MARK:全屏按钮点击
            if (button.selected == NO) {
                AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                
                appDelegate.allowRotation = YES;//(以上2行代码,可以理解为打开横屏开关)
                
                [self setNewOrientation:YES];//调用转屏代码90
                self.topViewContentView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                self.videoView.frame = CGRectMake(0, 0,ScreenWidth, ScreenHeight);
                self.watchTopView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                self.recordControlView.frame = CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50);
                self.statusView.hidden = YES;
                self.liveloadingView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                self.isPullScreen = YES;
                self.videoPlayView.frame =  CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                self.playCompleteView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                self.chatTextView.hidden = YES;
                
                self.eVSharePartView.frame = CGRectMake((ScreenWidth -ScreenHeight)/2, ScreenHeight, ScreenHeight, 169);
            }else {
               
                [self ZoomOutView];
                self.chatTextView.hidden = NO;
            }
            button.selected = !button.selected;
        break;
    
        case EVHVWatchViewTypeShare:
        {
//            if (self.isPullScreen == YES) {
//                [self ZoomOutView];
//            }
            [self shareViewShowAction];
            
        }
        break;
        case EVHVWatchViewTypePause:
        {
          button.selected = !button.selected;
          button.selected ? [self.evPlayer pause] : [self.evPlayer againPlay];
        }
        break;
        default:
        break;
    }
}

- (void)shareViewShowAction {
    self.eVSharePartView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        if (self.isPullScreen) {
            self.eVSharePartView.frame = CGRectMake((ScreenWidth -ScreenHeight)/2, ScreenHeight - 169, ScreenHeight, 169);
        }
        else
        {
            self.eVSharePartView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        }
        
    }];
}
- (void)ZoomOutView
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;//(以上2行代码,可以理解为打开横屏开关)
    [self setNewOrientation:NO];//调用转屏代码90
    self.watchTopView.frame = CGRectMake(0, 20, ScreenWidth, VideoWidth);
    self.topViewContentView.frame = CGRectMake(0, 0, ScreenWidth, 20+VideoWidth);
    self.statusView.hidden = NO;
    self.recordControlView.frame = CGRectMake(0, self.watchTopView.bounds.size.height - 50, ScreenWidth, 50);
    self.videoView.frame = CGRectMake(0, 20, ScreenWidth, VideoWidth);
    self.liveloadingView.frame = CGRectMake(0, 0, ScreenWidth, VideoWidth);
    self.videoPlayView.frame = CGRectMake(0, 0, ScreenWidth,VideoWidth);
    self.playCompleteView.frame = CGRectMake(0, 0, ScreenWidth, VideoWidth);
    self.eVSharePartView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    self.eVSharePartView.hidden = YES;
    self.isPullScreen = NO;
}
#pragma mark - 屏幕旋转
- (void)setNewOrientation:(BOOL)fullscreen

{
    if (fullscreen)
    {
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    }else{
        
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
        
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    }
    
}

#pragma mark - EVVideoPlayerDelegate
- (void)evVideoPlayer:(EVVideoPlayer *)player didChangedState:(EVPlayerState)state {
    switch (state) {
        case EVPlayerStateBuffering: {
            EVLog(@"正在缓冲中");
            
            break;
        }
        case EVPlayerStatePlaying: {
            self.liveloadingView.hidden = YES;
            break;
        }
        case EVPlayerStateUnknown: {
            break;
        }
        case EVPlayerStateConnectFailed:
            EVLog(@"---------evplayer connect failed----------");
            [EVProgressHUD showError:@"视频地址错误"];
            [self backButton];
        case EVPlayerStateComplete: {
            self.watchTopView.pause = YES;
            
            EVLog(@"--msw--evlive video over----");
           
            break;
        }
    }
}

#pragma mark --
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendChatStr:textField.text];
    [self.chatTextView.commentBtn setText:nil];
    [self.chatTextView.commentBtn textDidChange];
    [self resignBackView];
    return YES;
}

- (void)chatViewButtonType:(EVHVChatTextViewType)type
{
    switch (type) {
        case EVHVChatTextViewTypeGift:
        {
            EVLoginInfo *loginInfo = [EVLoginInfo localObject];
            if ([loginInfo.sessionid isEqualToString:@""] || loginInfo.sessionid == nil) {
                UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
                
                [self presentViewController:navighaVC animated:YES completion:nil];
                break;
            }
            [_magicEmojiView show];
            [self.view bringSubviewToFront:self.magicEmojiView];
        }
            
            break;
        case EVHVChatTextViewTypeSend:
        {
          
            if (self.chatTextView.commentBtn.text.length > 140) {
                [EVProgressHUD showError:@"字数不能超过140"];
                return;
            }
            [self sendChatStr:self.chatTextView.commentBtn.text];
            [self.chatTextView.commentBtn setText:nil];
            [self.chatTextView.commentBtn textDidChange];
            [self resignBackView];
        }
            break;
        default:
            break;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.chatTextView.commentBtn) {
        if (range.length == 1) {
            return YES;
        }else if (textField.text.length >= 140) {
            return NO;
        }
        return YES;
    }
    return YES;
}

- (void)resignBackView
{
    [self.chatTextView.commentBtn resignFirstResponder];
    self.blackBackView.hidden = YES;
    self.chatTextView.commentBtn.text = nil;
}


- (void)sendChatStr:(NSString *)str
{
    if (str.length  <= 0) {
        [EVProgressHUD showError:@"输入为空"];
        return;
    }
     EVLoginInfo *loginfo = [EVLoginInfo localObject];
    if (self.watchVideoInfo.mode == 2) {
        [self.baseToolManager POSTVideoCommentContent:str vid:self.watchVideoInfo.vid userID:loginfo.name userName:loginfo.nickname userAvatar:loginfo.logourl start:^{
           
        } fail:^(NSError *error) {
            NSString *errorMsg = @"评论失败";
            if (![EVLoginInfo localObject]) {
                errorMsg = [errorMsg stringByAppendingString:@"，请先登录"];
            }
            [EVProgressHUD showError:errorMsg];
            
        } success:^(NSDictionary *retinfo) {
            [EVProgressHUD showSuccess:@"评论成功"];
            [self.watchBottomView.videoCommentView loadDataVid:self.watchVideoInfo.vid start:@"0" count:@"20"];
            
        }];
    }else {
       
        NSDictionary *commentFormat = [NSDictionary dictionaryWithObjectsAndKeys:loginfo.nickname,EVMessageKeyNk, nil];
        NSMutableDictionary *commentJoin = [NSMutableDictionary dictionaryWithObjectsAndKeys:commentFormat,EVMessageKeyExct, nil];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:commentJoin options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

        [[EVMessageManager shareManager] sendMessage:str userData:jsonString toTopic:self.watchVideoInfo.vid result:^(BOOL isSuccess, EVMessageErrorCode errorCode) {
            if (isSuccess) {
                EVLog(@"sendmessagesuccess ------------");
            }else{
                
                
            }
        }];
    }
 
    
}


- (void)loginView
{
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    if ([loginInfo.sessionid isEqualToString:@""] || loginInfo.sessionid == nil) {
        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
        
        [self presentViewController:navighaVC animated:YES completion:nil];
        return;
    }

}

- (void)liveShareViewDidClickButton:(EVLiveShareButtonType)type
{
    NSString *nickName = self.watchVideoInfo.nickname;
    //NSString *videoTitle = self.watchVideoInfo.title;
    NSString *shareUrlString = self.watchVideoInfo.share_url;
    
    if (self.watchVideoInfo.logourl == nil) {
        
        [EVProgressHUD showError:@"加载完成在分享"];

    }
    
//    self.isSharing = YES;
    ShareType shareType;
    if (self.watchVideoInfo.mode == 2) {
        shareType = ShareTypeGoodVideo;
    }else {
        shareType = ShareTypeLiveAnchor;
    }
    
    UIImage *image = [UIImage imageNamed:@"icon_share"];
    [[EVShareManager shareInstance] shareContentWithPlatform:type shareType:shareType titleReplace:nickName descriptionReplaceName:self.watchVideoInfo.title descriptionReplaceId:nil URLString:shareUrlString image:image outImage:nil];
    
    
}

#pragma mark - recoredDelegate
- (void)recordInfoViewDidDragToNewProgress:(double)progress
{
    self.evPlayer.currentPlaybackTime = progress;
    [self.evPlayer againPlay];
    self.watchTopView.pause = NO;
  
}

#pragma  mark - giftdelegate
/** 充值火眼豆 */
- (void)rechargeYibi
{
    EVLog(@"充值按钮");
    [self pushHuoYanCoin];
}

/** 火眼豆数不足 */
- (void)yibiNotEnough
{
    EVLog(@"火眼豆不足");
    [self pushHuoYanCoin];
}

- (void)updateLiveStatus:(BOOL)status
{
    if (status  == NO) {
        self.playCompleteView.hidden = NO;
        [self.evPlayer shutdown];
        self.evPlayer = nil;
        EVLog(@"结束直播");
    }else {
        EVLog(@"没有结束");
    }
}

- (void)updateMessageGiftDict:(NSDictionary *)dict
{
    EVLog(@"dict----------   ------------------------------");
    NSMutableDictionary *giftDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    EVStartGoodModel *goodModel = [EVStartGoodModel modelWithDict:giftDict];
    [self.watchBottomView.giftAniView addStartGoodModel:goodModel];
}

#pragma mark - 送礼物
- (void)sendMagicEmojiWithEmoji:(EVStartGoodModel *)magicEmoji num:(NSInteger)numOfEmoji
{
    WEAK(self)
    self.startGoodModel = magicEmoji;
    [self.baseToolManager GETBuyPresentWithGoodsID:[NSString stringWithFormat:@"%ld", (long)magicEmoji.ID] number:numOfEmoji vid:self.watchVideoInfo.vid name:self.watchVideoInfo.name start:^{
        
    } fail:^(NSError *error) {
        // 就目前的网络底层，失败以后不能做重发操作，因为用户可能会继续发礼物，两个请求可能相同，
        NSString *errorStr = [error errorInfoWithPlacehold:kE_GlobalZH(@"fail_send_gift")];
        EVLog(@"errorStr = %@", errorStr);
        [EVProgressHUD showError:errorStr toView:weakself.view];
    } success:^(NSDictionary *info) {

        if (info[@"ecoin"]) {
             [weakself updateAssetWithInfo:info];
            return;
        }else {
            self.asset.ecoin = self.asset.ecoin - self.startGoodModel.cost;
            self.magicEmojiView.ecoin = self.asset.ecoin;
        }
//        [weakself updateAssetWithInfo:info];
    } sessionExpire:^{
        EVRelogin(weakself);
    }];
}

- (void)pushHuoYanCoin
{
    EVYunBiViewController *yibiVC = [[EVYunBiViewController alloc] init];
    yibiVC.asset = self.asset;
    yibiVC.delegate = self;
    [self.navigationController pushViewController:yibiVC animated:YES];
}

- (void)recordInfoViewDidBeginDrag:(id)recordInfoView
{
    self.watchTopView.pause = YES;
    [self.evPlayer pause];
}

- (void)evVideoPlayer:(EVVideoPlayer *)player updateBuffer:(int)percent position:(int)position
{
    
    
}


#pragma mark - commentdelegate
- (void)updateMessageNewCommentData:(NSMutableArray *)data isHistory:(BOOL)isHistory
{
    if (data.count > 0) {
       EVComment *comment = [data firstObject];
        [self.watchBottomView.chatView receiveChatContent:comment.content nickName:comment.nickname isHistory:isHistory];
    }
}

#pragma mark - stockDelegate

- (void)searchButton
{
    [self.baseToolManager getSearchInfosWith:self.stockTextView.stockTextFiled.text type:EVSearchTypeStock start:0 count:20 startBlock:nil fail:^(NSError *error) {
        
    } success:^(NSDictionary *dict) {
       
        NSArray *dataArr  = [EVStockBaseModel objectWithDictionaryArray:dict[@"data"]];
        
        if (dataArr.count !=0) {
            self.watchBottomView.notOpenView.hidden = YES;
            self.watchBottomView.watchStockView.hidden = NO;
        }else {
            [EVProgressHUD showMessage:@"您的输入有误，请重新输入"];
        }
        self.watchBottomView.watchStockView.dataArray = dataArr;
    } sessionExpire:^{
        
    } reterrBlock:nil];
    [self.stockTextView.stockTextFiled resignFirstResponder];
}

#pragma mark - bottomdelegate
- (void)scrollViewDidSeletedIndex:(NSInteger)index
{
    self.scrollViewIndex = index;
    if (index == 0) {
        self.chatTextView.hidden = NO;
        self.stockTextView.hidden = YES;
    }else if (index == 1) {
        self.chatTextView.hidden = YES;
        self.stockTextView.hidden = NO;
    }else {
        self.chatTextView.hidden = YES;
        self.stockTextView.hidden = YES;
    }
}


#pragma mark - centerdelegate
- (void)watchCenterViewType:(EVHVWatchCenterType)type
{
    WEAK(self)
    switch (type) {
        case EVHVWatchCenterTypeHeadImage:
        {
            //TODO:点击头像进入个人中心
//            EVVipCenterViewController *vipCenterVC  = [[EVVipCenterViewController alloc] init];
//             [self.navigationController pushViewController:vipCenterVC animated:YES];
//            vipCenterVC.watchVideoInfo = self.watchVideoInfo;
//            vipCenterVC.isFollow = weakself.watchCenterView.isFollow;
            EVVipCenterController *vc = [[EVVipCenterController alloc] init];
            vc.watchVideoInfo = self.watchVideoInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case EVHVWatchCenterTypeFollow:
        {
            if (![EVLoginInfo hasLogged]) {
                UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
                
                [self presentViewController:navighaVC animated:YES completion:nil];
                return;
            }
            
            BOOL followType = self.watchCenterView.isFollow ? NO : YES;
            [self.baseToolManager GETFollowUserWithName:self.watchVideoInfo.name followType:followType start:^{

            } fail:^(NSError *error) {
            } success:^{
                weakself.watchCenterView.isFollow = followType;
                weakself.watchVideoInfo.followed = followType;
            } essionExpire:^{
            }];
        }
            break;
        default:
            break;
    }
}

- (void)shareType:(EVLiveShareButtonType)type
{
     [self liveShareViewDidClickButton:type];
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}

- (void)destoryevPlayer
{
    [_evPlayer shutdown];
    [_evPlayer.presentview removeFromSuperview];
}

- (EVPayVideoCoverView *)videoPayCoverView
{
    if (!_videoPayCoverView) {
        _videoPayCoverView = [[EVPayVideoCoverView alloc] init];
        _videoPayCoverView.frame = CGRectMake(0, 20, ScreenWidth, VideoWidth);
        __weak typeof(self) weakSelf = self;
        
        _videoPayCoverView.payButtonClickBlock = ^(void)
        {
            
                if([EVBaseToolManager userHasLoginLogin])
                {
                    if (weakSelf.watchVideoInfo.price) {
                        [weakSelf.payBottomView showPayViewWithPayFee:[weakSelf.watchVideoInfo.price integerValue] userAssetModel:weakSelf.asset addtoView:weakSelf.view];
                    }
                    else
                    {
                        [EVProgressHUD showMessage:@"未获取到价格"];
                    }
                    
                }
                else
                {
                    UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
                    [weakSelf presentViewController:navighaVC animated:YES completion:nil];
                }

            
        };
        
        
        _videoPayCoverView.backButtonClickBlock = ^()
        {
            [weakSelf backButton];
        };
        
    }
    return _videoPayCoverView;
}

- (EVVideoPayBottomView *)payBottomView
{
    if (!_payBottomView) {
        _payBottomView = [[EVVideoPayBottomView alloc] init];
        _payBottomView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        __weak typeof(self) weakSelf = self;
        _payBottomView.payOrChargeButtonClick = ^(EVVideoPayBottomView * view)
        {
            if ([view.viewchargeButton.currentTitle isEqualToString:@"充值"])
            {
                //充值
                EVYunBiViewController *yunbiVC = [[EVYunBiViewController alloc] init];
                yunbiVC.asset = weakSelf.asset;
                yunbiVC.updateEcionBlock = ^(NSString *ecion) {
                    weakSelf.asset.ecoin = ecion.integerValue;
                    view.assetModel = weakSelf.asset;
                };
                [weakSelf.navigationController pushViewController:yunbiVC animated:YES];
            }
            else
            {
                //购买
                [weakSelf.baseToolManager GETLivePayWithVid:weakSelf.watchVideoInfo.vid start:nil fail:^(NSError *error) {
                [EVProgressHUD showMessage:@"购买失败"];
                } successBlock:^(NSDictionary *retinfo) {
                    //购买成功
                    [EVProgressHUD showMessage:@"购买成功"];
                    [weakSelf.evPlayer play];
                    [view dismissPayView];
                    weakSelf.videoPayCoverView.hidden = YES;
                    } sessionExpire:^{
                    [EVProgressHUD showMessage:@"购买失败"];
                }];
                
            }

        };
    }
    return _payBottomView;
}

- (EVHVVideoCoverView *)videoCoverView
{
    if (!_videoCoverView) {
        _videoCoverView = [[EVHVVideoCoverView alloc] init];
        _videoCoverView.frame = CGRectMake(0, 0, ScreenWidth, VideoWidth);
        _videoCoverView.hidden = YES;
    }
    return _videoCoverView;
}

- (EVHVVideoCoverView *)liveloadingView
{
    if (!_liveloadingView) {
        _liveloadingView = [[EVHVVideoCoverView alloc] init];
        _liveloadingView.frame = CGRectMake(0, 0, ScreenWidth, VideoWidth);
        _liveloadingView.hidden = NO;
        _liveloadingView.titleStr = @"直播加载中";
        _liveloadingView.topImage = [UIImage imageNamed:@"ic_loading_1"];
    }
    return _liveloadingView;
}


- (EVHVVideoCoverView *)playCompleteView
{
    if (!_playCompleteView) {
        _playCompleteView = [[EVHVVideoCoverView alloc] init];
        _playCompleteView.frame = CGRectMake(0, 0, ScreenWidth, VideoWidth);
        _playCompleteView.hidden = YES;
    }
    return _playCompleteView;
}
- (EVSharePartView *)eVSharePartView {
    
    if (!_eVSharePartView) {
        _eVSharePartView = [[EVSharePartView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
        _eVSharePartView.backgroundColor = [UIColor colorWithHexString:@"#303030" alpha:0.7];
        _eVSharePartView.eVWebViewShareView.delegate = self;
        [self.view addSubview:_eVSharePartView];
        _eVSharePartView.hidden = YES;
            __weak typeof(self) weakSelf = self;
            self.eVSharePartView.cancelShareBlock = ^() {
                
                [UIView animateWithDuration:0.3 animations:^{
                    if (weakSelf.isPullScreen) {
                        weakSelf.eVSharePartView.frame = CGRectMake((ScreenWidth -ScreenHeight)/2, ScreenHeight, ScreenHeight, 169);
                    }
                    else
                    {
                        weakSelf.eVSharePartView.frame = CGRectMake(0, ScreenHeight, ScreenHeight, ScreenHeight);
                    }
                    
                } completion:^(BOOL finished) {
                    weakSelf.eVSharePartView.hidden = YES;
                }];
            };
    }
    return _eVSharePartView;
}
- (void)dealloc
{
    NSLog(@"EVHVWatchViewController delloc");
    self.liveMessageEngine.levelTopic = YES;
    [self.evPlayer shutdown];
    self.evPlayer = nil;
    [self stopRecordPlayTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo
{
    _watchVideoInfo = watchVideoInfo;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
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
