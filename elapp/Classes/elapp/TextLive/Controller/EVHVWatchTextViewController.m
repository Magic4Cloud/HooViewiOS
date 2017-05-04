//
//  EVHVWatchTextViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/15.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVWatchTextViewController.h"
#import "SwipeTableView.h"
#import "SGSegmentedControl.h"
#import "EVHVCenterLiveView.h"
#import "EVLineView.h"
#import "EVLiveImageTableView.h"
#import "EVVipNotOpenTableView.h"
#import "EVTextLiveStockTableView.h"
#import "EVTextLiveChatTableView.h"
#import "EVHVStockTextView.h"
#import "EVBaseToolManager+EVSearchAPI.h"
#import "EVStockBaseModel.h"
#import "EVTextLiveToolBar.h"
#import "YZInputView.h"
#import "EVLoginInfo.h"
#import "EVHVTLWatchBtnView.h"
#import "EVStartResourceTool.h"
#import "EVMagicEmojiView.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVUserAsset.h"
#import "EVHVGiftAniView.h"
#import "EVCutIgeShareViewController.h"
#import "EVSharePartView.h"
#import "EVShareManager.h"
#import "EVBaseToolManager+EVGroupAPI.h"
#import "EVVideoFunctions.h"
#import "MJRefreshHeader.h"
#import "EVYunBiViewController.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVNotOpenView.h"

#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVLoginViewController.h"
#import "EVVipCenterViewController.h"

#import "EVVipCenterController.h"


#import "EVTextLiveHeaderView.h"

#define headerTopHig     (104+64)
#define segmentHig        44

@interface EVHVWatchTextViewController ()<EVHVVipCenterDelegate,SwipeTableViewDataSource,SwipeTableViewDelegate,UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate,SGSegmentedControlStaticDelegate,EMChatManagerDelegate,EVHVStockTextViewDelegate,EVTextBarDelegate,EVHVLWatchViewDelegate,CCMagicEmojiViewDelegate,EVWebViewShareViewDelegate,EVYiBiViewControllerDelegate,EMChatroomManagerDelegate,UIScrollViewDelegate,EVTextLiveTableViewDelegate,EVTextLiveStockDelegate>
@property (nonatomic,strong) NSMutableArray *historyChatArray;
@property (nonatomic,strong) NSMutableArray *historyArray;
@property (nonatomic, assign) BOOL isRefresh;


@property (nonatomic, copy) NSString *rpName;
@property (nonatomic, copy) NSString *rpContent;

@property (strong, nonatomic) EVBaseToolManager *engine;

@property (nonatomic, strong) SGSegmentedControlStatic *topSView;

@property (nonatomic, strong) UIView *sementedBackView;

@property (nonatomic, strong) UIView *navigationView;

@property (nonatomic, strong) EVLiveImageTableView *liveImageTableView;

@property (nonatomic, strong) EVVipNotOpenTableView *vipNotOpenTableView;

@property (nonatomic, strong) EVTextLiveStockTableView *textLiveStockTableView;

@property (nonatomic, strong) EVTextLiveChatTableView *textLiveChatTableView;

@property (nonatomic, strong) EMConversation *conversation;

@property (nonatomic, strong) UIButton *blackBackView;

@property (nonatomic, weak) EVHVStockTextView *stockTextView;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, weak) EVTextLiveToolBar *textLiveToolBar;
@property (nonatomic, strong) NSLayoutConstraint *toolBarTextBottonF;
@property (nonatomic, strong) NSLayoutConstraint *toolBarTextViewHig;

@property (nonatomic, assign) NSInteger chooseIndex;
@property (nonatomic, assign) NSInteger cellStart;

@property (nonatomic, weak) EVHVTLWatchBtnView *hvtWatchBtnView;

@property (nonatomic, weak) EVMagicEmojiView *magicEmojiView;

@property (nonatomic, strong) EVStartGoodModel *startGoodModel;

@property (strong, nonatomic) EVUserAsset *asset;  /**< 用户资产信息 */

@property (nonatomic, weak) EVHVGiftAniView *hvGiftAniView;

@property (nonatomic, weak) UIButton *nBackBtn;
@property (nonatomic, weak) UIButton *nShareBtn;
@property (nonatomic, weak) UILabel *nNameLabel;

@property (nonatomic, weak) UIButton *followButton;

@property (nonatomic, strong) EVSharePartView *eVSharePartView;

@property (nonatomic) UIImage *snapImage;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, strong) EMChatroom *chatroom;


//--------------------------------------- 新 -----------------//
@property (nonatomic, weak) UIScrollView *mainBackView;

@property (nonatomic, strong) EVTextLiveHeaderView * headerView;
@end

@implementation EVHVWatchTextViewController

- (EVTextLiveHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[EVTextLiveHeaderView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 104)];
        [_headerView.followButton addTarget:self action:@selector(followClick:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalHomePage)];
        [_headerView.avatarImageView addGestureRecognizer:tap];
        _headerView.avatarImageView.userInteractionEnabled = YES;
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor evBackgroundColor];
    // Do any additional setup after loading the view from its nib.
    //    [self addUpView];
    [self addBackTableView];
}
- (void)addBackTableView
{
    // init swipetableview
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView  *mainBackView = [[UIScrollView alloc] init];
    mainBackView.frame = CGRectMake(0, 0, ScreenWidth , ScreenHeight);
    [self.view addSubview:mainBackView];
    mainBackView.contentSize = CGSizeMake(ScreenWidth * 4, 0);
    self.mainBackView = mainBackView;
    mainBackView.pagingEnabled = YES;
    mainBackView.delegate = self;
    mainBackView.showsHorizontalScrollIndicator = NO;
    
//    [self.view addSubview:self.vipCenterView];
//    self.vipCenterView.delegate = self;
//    [self.vipCenterView.reportBtn setImage:[UIImage imageNamed:@"btn_share_w_n_back"] forState:(UIControlStateNormal)];
    
    [self.view addSubview:self.headerView];
    
    self.sementedBackView  = [[UIView alloc] init];
    _sementedBackView.frame = CGRectMake(0, headerTopHig, ScreenWidth, segmentHig);
    _sementedBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.sementedBackView];
    
    NSArray *titleArray = @[@"直播",@"数据",@"聊天",@"秘籍"];
    
    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 0, ScreenWidth , segmentHig) delegate:self childVcTitle:titleArray indicatorIsFull:NO];
    // 必须实现的方法
    [_topSView SG_setUpSegmentedControlType:^(SGSegmentedControlStaticType *segmentedControlStaticType, NSArray *__autoreleasing *nomalImageArr, NSArray *__autoreleasing *selectedImageArr) {
        
    }];
    
    [_topSView SG_setUpSegmentedControlStyle:^(UIColor *__autoreleasing *segmentedControlColor, UIColor *__autoreleasing *titleColor, UIColor *__autoreleasing *selectedTitleColor, UIColor *__autoreleasing *indicatorColor, BOOL *isShowIndicor) {
        *segmentedControlColor = [UIColor whiteColor];
        *titleColor = [UIColor evTextColorH2];
        *selectedTitleColor = [UIColor evMainColor];
        *indicatorColor = [UIColor evMainColor];
    }];
    _topSView.selectedIndex = 0;
    [_sementedBackView addSubview:_topSView];
    
    
    [self updateIsFollow:self.watchVideoInfo.followed];
    if ([self.watchVideoInfo.name isEqualToString:[EVLoginInfo localObject].name]) {
        self.followButton.hidden  = YES;
    }

    self.navigationView = [[UIView alloc] init];
    _navigationView.frame = CGRectMake(0, 0, ScreenWidth, 64);
    _navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_navigationView];
    
    UIButton *nBackBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_navigationView addSubview:nBackBtn];
    self.nBackBtn = nBackBtn;
    [nBackBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [nBackBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    [nBackBtn autoSetDimensionsToSize:CGSizeMake(54, 44)];
    [nBackBtn setImage:[UIImage imageNamed:@"hv_back_return"] forState:(UIControlStateNormal)];
    [self.nBackBtn addTarget:self action:@selector(backClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UILabel *nNameLbl = [[UILabel alloc] init];
    [_navigationView addSubview:nNameLbl];
    self.nNameLabel = nNameLbl;
    self.nNameLabel.text = [NSString stringWithFormat:@"0参与"];
    [nNameLbl autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [nNameLbl autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:29];
    [nNameLbl autoSetDimensionsToSize:CGSizeMake(120, 20)];
    nNameLbl.textColor = [UIColor evRedColor];
    nNameLbl.font = [UIFont systemFontOfSize:14];
    nNameLbl.textAlignment = NSTextAlignmentCenter;
    
    UIButton *nShareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_navigationView addSubview:nShareBtn];
    self.nShareBtn  = nShareBtn;
    [nShareBtn setImage:[UIImage imageNamed:@"btn_share_n"] forState:(UIControlStateNormal)];
    [nShareBtn autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [nShareBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    [nShareBtn autoSetDimensionsToSize:CGSizeMake(44, 44)];
    [_nShareBtn addTarget:self action:@selector(shareClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [mainBackView addSubview:self.liveImageTableView];
    WEAK(self)
    _liveImageTableView.scrollVBlock = ^ (UIScrollView *scrollView) {
        [weakself updateScrollView:scrollView];
        
    };
    
    [self.liveImageTableView addRefreshFooterWithRefreshingBlock:^{
        [weakself loadHistoryData];
    }];
    
    [mainBackView addSubview:self.textLiveStockTableView];
    self.textLiveStockTableView.tDelegate = self;
    
    [mainBackView addSubview:self.textLiveChatTableView];
//    self.textLiveChatTableView.tDelegate = self;
    
    //TODO:聊天tableView
//    [self.textLiveChatTableView addRefreshHeaderWithRefreshingBlock:^{
//         [weakself loadHistoryData];
//    }];
    EVNotOpenView *notOpenView = [[EVNotOpenView alloc] init];
    notOpenView.frame = CGRectMake(ScreenWidth * 3, 260, ScreenWidth, ScreenHeight - 260);
    [mainBackView addSubview:notOpenView];
    
    
    [self addChatTextView];
    [self addPresentListView];
    [self addGiftAniView];
}
#pragma mark - 点击头像进入个人主页
- (void)personalHomePage
{
    EVWatchVideoInfo *watchInfo = [EVWatchVideoInfo new];
    watchInfo.name = self.watchVideoInfo.name;
    EVVipCenterController *vc = [[EVVipCenterController alloc] init];
    vc.watchVideoInfo = watchInfo;
    [self.navigationController pushViewController:vc animated:YES];
   
}
- (EVHVVipCenterView *)vipCenterView
{
    if (!_vipCenterView) {
        _vipCenterView = [[EVHVVipCenterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, headerTopHig) isTextLive:YES];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalHomePage)];
        [_vipCenterView.userHeadIgeView addGestureRecognizer:tap];
        _vipCenterView.userHeadIgeView.userInteractionEnabled = YES;
    }
    return _vipCenterView;
}
- (void)addChatTextView
{
    _blackBackView = [[UIButton alloc] init];
    _blackBackView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _blackBackView.alpha = 0.5;
    _blackBackView.backgroundColor = [UIColor blackColor];
    [_blackBackView addTarget:self action:@selector(backViewClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navigationController.view addSubview:_blackBackView];
    _blackBackView.hidden = YES;
    
    //TODO:聊天输入框
    EVTextLiveToolBar *textLiveToolBar = [[EVTextLiveToolBar alloc] init];
    [self.navigationController.view addSubview:textLiveToolBar];
    self.textLiveToolBar = textLiveToolBar;
    textLiveToolBar.delegate = self;
    [textLiveToolBar autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [textLiveToolBar autoPinEdgeToSuperviewEdge:ALEdgeRight];
    self.toolBarTextBottonF =    [textLiveToolBar autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    self.toolBarTextViewHig =    [textLiveToolBar autoSetDimension:ALDimensionHeight toSize:49];
    textLiveToolBar.hidden = YES;
    WEAK(self)
    textLiveToolBar.inputTextView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        if (text.length <= 0) {
            weakself.toolBarTextViewHig.constant = 49;
            return;
        }
        weakself.toolBarTextViewHig.constant = textHeight + 16;
    };
    
    EVHVStockTextView *stockTextView  = [[EVHVStockTextView alloc] init];
    [self.navigationController.view addSubview:stockTextView];
    stockTextView.hidden = YES;
    stockTextView.frame = CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49);
    stockTextView.delegate = self;
    self.stockTextView = stockTextView;
    stockTextView.backgroundColor = [UIColor whiteColor];
    
    //MARK:工具栏截图等
    EVHVTLWatchBtnView *hvtWatchBtnView = [[EVHVTLWatchBtnView alloc] init];
    [self.view addSubview:hvtWatchBtnView];
    self.hvtWatchBtnView = hvtWatchBtnView;
    hvtWatchBtnView.delegate = self;
    [hvtWatchBtnView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20];
    [hvtWatchBtnView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:16];
    [hvtWatchBtnView autoSetDimensionsToSize:CGSizeMake(40, 96)];
    
    
    [EVNotificationCenter addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [EVNotificationCenter addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    [self loadMyAssetsData];
    
    [self loadUserData];
    self.cellStart = 0;
    [self loadHistoryData];

}

#pragma mark - 聊天框开始编辑 判断是否登陆
- (void)chatTextViewDidBeginEditing
{
    //聊天  开始编辑  如果没登陆   弹出登陆提示框  让键盘下去
    NSString *sessionID = [self.engine getSessionIdWithBlock:nil];
    if (sessionID == nil || [sessionID isEqualToString:@""]) {
        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
        
        [self presentViewController:navighaVC animated:YES completion:nil];
        [self.textLiveToolBar.inputTextView resignFirstResponder];
    }
}
- (void)tableViewDidScroll:(UIScrollView *)scrollView
{
    if (self.chooseIndex == 2) {
         [self updateScrollView:scrollView];
    }
}

- (void)stockViewDidScroll:(UIScrollView *)scrollView
{
    [self updateScrollView:scrollView];
}

- (void)updateScrollView:(UIScrollView *)scrollView
{
    
//    if (scrollView.contentOffset.y <= -(headerTopHig + segmentHig)) {
//        self.vipCenterView.frame = CGRectMake(0, 0, ScreenWidth, headerTopHig);
//        self.sementedBackView.frame = CGRectMake(0, headerTopHig, ScreenWidth, 44);
//        
//    }else if(scrollView.contentOffset.y > 0){
//        self.vipCenterView.frame = CGRectMake(0, -headerTopHig, ScreenWidth, headerTopHig);
//        self.sementedBackView.frame = CGRectMake(0, 64, ScreenWidth, 44);
//        
//    }else {
//        
//        CGRect oneFrame = self.vipCenterView.frame;
//        oneFrame.origin.y = -((oneFrame.size.height+44) + scrollView.contentOffset.y);
//        self.vipCenterView.frame = oneFrame;
//        
//        if (scrollView.contentOffset.y > -108) {
//            self.sementedBackView.frame = CGRectMake(0, 64, ScreenWidth, 44);
//        }else{
//            self.sementedBackView.frame = CGRectMake(0, CGRectGetMaxY(oneFrame), ScreenWidth, 44);
//        }
//        
////        if (scrollView.contentOffset.y > -190) {
////            self.navigationView.alpha = 1.0;
////        }else {
////            self.navigationView.alpha = 0.0;
////        }
//        
//        
//    }
}

- (void)loadUserData
{
    [self.baseToolManager GETBaseUserInfoWithPersonid:self.watchVideoInfo.name start:^{
        
    } fail:^(NSError *error) {
        
    } success:^(NSDictionary *modelDict) {
        self.watchVideoInfo = [EVWatchVideoInfo objectWithDictionary:modelDict];
        
        [self updateIsFollow:self.watchVideoInfo.followed];

    } sessionExpire:^{
        
    }];
    
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

- (void)addGiftAniView
{
    EVHVGiftAniView *hvGiftAniView = [[EVHVGiftAniView alloc] init];
    [self.view addSubview:hvGiftAniView];
    self.hvGiftAniView = hvGiftAniView;
    [hvGiftAniView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16];
    [hvGiftAniView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:16];
    [hvGiftAniView autoSetDimensionsToSize:CGSizeMake(80, 190)];
    [self.view bringSubviewToFront:self.hvGiftAniView];
    hvGiftAniView.backgroundColor = [UIColor clearColor];
    
    
    [self.view addSubview:self.eVSharePartView];
    
    //取消分享
    __weak typeof(self) weakSelf = self;
    self.eVSharePartView.cancelShareBlock = ^() {
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf chooseIndex:weakSelf.chooseIndex];
            weakSelf.eVSharePartView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
        }];
    };
}

- (void)shareViewShowAction
{
    self.textLiveToolBar.hidden = YES;
    self.stockTextView.hidden = YES;
    self.snapImage = [self snapshot:self.navigationController.view];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.eVSharePartView.frame = CGRectMake(0, 0, ScreenWidth,  ScreenHeight);
    }];
}

- (void)shareType:(EVLiveShareButtonType)type
{
    ShareType shareType = ShareTypeMineTextLive;
    
    
    
    [[EVShareManager shareInstance] shareContentWithPlatform:type shareType:shareType titleReplace:[EVLoginInfo localObject].nickname descriptionReplaceName:@"" descriptionReplaceId:nil URLString:nil image:self.snapImage outImage:self.snapImage];
    
}




- (void)shareClick:(UIButton *)share
{
    NSLog(@"share----");
    [self shareViewShowAction];
}

- (void)backClick:(UIButton *)back
{
    [self backButton];
}

- (void)loadMyAssetsData
{
    WEAK(self)
    [self.baseToolManager GETUserAssetsWithStart:^{
        
    } fail:^(NSError *error) {
        
    } success:^(NSDictionary *videoInfo) {
        
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

#pragma mark - 送礼物
- (void)sendMagicEmojiWithEmoji:(EVStartGoodModel *)magicEmoji num:(NSInteger)numOfEmoji
{
    WEAK(self)
    self.startGoodModel = magicEmoji;
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@"礼物"];
//    EMTextMessageBody * body = [[EMTextMessageBody alloc] initWithText:@"礼物"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    //生成Message
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:magicEmoji.name forKey:@"gnm"];
    [dict setValue:[EVLoginInfo localObject].nickname forKey:@"nk"];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:_conversation.conversationId from:from to:_conversation.conversationId body:body ext:dict];
    message.chatType = EMChatTypeChatRoom;
   

    
    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
    } completion:^(EMMessage *aMessage, EMError *aError) {
        if (!aError) {
            [self messageGiftDict:aMessage.ext];
        }
    }];
    [self.baseToolManager GETBuyPresentWithGoodsID:[NSString stringWithFormat:@"%ld", (long)magicEmoji.ID] number:numOfEmoji vid:self.chatroom.chatroomId name:self.watchVideoInfo.name start:^{
        
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
    } sessionExpire:^{
        EVRelogin(weakself);
    }];
}




- (void)messageGiftDict:(NSDictionary *)dict
{
    EVLog(@"dict----------   ------------------------------");
    NSMutableDictionary *giftDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    EVStartGoodModel *goodModel = [EVStartGoodModel modelWithDict:giftDict];
    [self.hvGiftAniView addStartGoodModel:goodModel];
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
    
    if ([_watchVideoInfo.name isEqualToString:[EVLoginInfo localObject].name]) {
        [self.baseToolManager POSTChatTextLiveID:self.liveVideoInfo.liveID from:message.from nk:ext[@"nk"] msgid:message.messageId msgtype:type msg:msg tp:ext[@"tp"] rct:ext[@"rct"] rnk:ext[@"rnk"] timestamp:time img:image success:^(NSDictionary *retinfo) {
            NSLog(@"成功--------------");
        } error:^(NSError *error) {
        }];
     }
    NSLog(@"不是主播");
}


//上拉加载
- (void)loadHistoryData
{
    WEAK(self)
    self.isRefresh = YES;
    NSDate * currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSince1970] *1000;
    _time = [NSString stringWithFormat:@"%.0f",timeInterval];
    [self.baseToolManager GETHistoryTextLiveStreamid:self.liveVideoInfo.liveID  count:@"20" start:[NSString stringWithFormat:@"%ld",self.cellStart] stime:self.time success:^(NSDictionary *retinfo)
    {
//        NSLog(@"retinfo:  %@",retinfo);
        [weakself.liveImageTableView endFooterRefreshing];
        if ([retinfo[@"reterr"] isEqualToString:@"OK"])
        {
            NSArray *msgsAry = retinfo[@"retinfo"][@"msgs"];
            [weakself.historyArray removeAllObjects];
            
                for (NSDictionary *msgDict in msgsAry)
                {
                    if ([msgDict[@"from"] isEqualToString:self.watchVideoInfo.name])
                    {
                        //直播内容
                        EVEaseMessageModel *messageModel = [[EVEaseMessageModel alloc] initWithHistoryMessage:msgDict];
                        [weakself.historyArray addObject:messageModel];
                    }
                }
            
                if (_cellStart == 0)
                {
                    [weakself.liveImageTableView.dataArray removeAllObjects];
                }
                    
                [weakself.liveImageTableView updateHistoryArray:self.historyArray];

            _cellStart = [retinfo[@"retinfo"][@"next"] integerValue];

             [weakself.liveImageTableView setFooterState:(msgsAry.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
             weakself.isRefresh = NO;
        }
        
    }
     error:^(NSError *error)
    {
        weakself.isRefresh = NO;
        [weakself.liveImageTableView endFooterRefreshing];
//        [weakself.textLiveChatTableView endHeaderRefreshing];
    }];
}
#pragma mark -- 直播菜单按钮点击
- (void)buttonTag:(UIButton *)tag
{
    switch (tag.tag) {
        case 9000:
        {
          
            EVLog(@"剪切");
            UIImage *snapImage = [self snapshot:self.navigationController.view];
            if (snapImage) {
                EVCutIgeShareViewController *cutIgeVC = [[EVCutIgeShareViewController alloc] init];
                cutIgeVC.cutImage = snapImage;
                [self.navigationController pushViewController:cutIgeVC animated:YES];
            }
            
           
        }
            break;
       
        case 9001:
        {
            NSLog(@"礼物");
            NSString *sessionID = [self.engine getSessionIdWithBlock:nil];
            
            if (sessionID == nil || [sessionID isEqualToString:@""]) {
                UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
                
                [self presentViewController:navighaVC animated:YES completion:nil];
                return;
            }
            
            [_magicEmojiView show];
            [self.view bringSubviewToFront:self.magicEmojiView];
        }
            break;
        
        default:
            break;
    }
}

- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)searchButton
{
    [self.baseToolManager getSearchInfosWith:self.stockTextView.stockTextFiled.text type:EVSearchTypeStock start:0 count:20 startBlock:nil fail:^(NSError *error) {
        
    } success:^(NSDictionary *dict) {
        
        NSArray *dataArr  = [EVStockBaseModel objectWithDictionaryArray:dict[@"data"]];
        [self.textLiveStockTableView removeAllAry];
        if (dataArr.count !=0) {

        }else {
            [EVProgressHUD showMessage:@"您的输入有误，请重新输入"];
        }
        self.textLiveStockTableView.dataArray = dataArr.mutableCopy;
    } sessionExpire:^{
        
    } reterrBlock:nil];
    [self.stockTextView.stockTextFiled resignFirstResponder];
}

#pragma mark - 发送聊天消息
- (void)sendMessageBtn:(UIButton *)btn textToolBar:(EVTextLiveToolBar *)textToolBar
{
    

    //消息体
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:textToolBar.inputTextView.text];
    
    NSString *from = [[EMClient sharedClient] currentUsername];
    //生成Message
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //内容类型（st，置顶消息；hl，高亮消息；nor，普通消息）
    [dict setValue:@"nor" forKey:@"tp"];
    //发消息人名字 为自己
    [dict setValue:[EVLoginInfo localObject].nickname forKey:@"nk"];
    
    EVLoginInfo * model = [EVLoginInfo localObject];
    //头像
    [dict setValue:model.logourl forKey:@"avatar"];
    //uid
    [dict setValue:model.name forKey:@"userid"];
    NSString * vip = [NSString stringWithFormat:@"%d",model.vip];
    [dict setValue:vip forKey:@"vip"];
    
    //环信
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

- (void)keyBoardShow:(NSNotification *)notification
{
    self.blackBackView.hidden = NO;
    
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (self.chooseIndex == 0) {
      
    }else if (self.chooseIndex == 1) {
        self.stockTextView.hidden = NO;
        self.textLiveToolBar.hidden = YES;
        self.stockTextView.frame = CGRectMake(0, ScreenHeight - 49 - frame.size.height, ScreenWidth, 49);
    }else if (self.chooseIndex == 2) {
         self.stockTextView.hidden = YES;
        self.textLiveToolBar.hidden = NO;
        self.toolBarTextBottonF.constant = -frame.size.height;

    }else if (self.chooseIndex == 3) {
        
    }
    [self chooseIndex:self.chooseIndex];
}



- (void)keyBoardHide:(NSNotification *)notification
{
    self.blackBackView.hidden = YES;
     _stockTextView.frame = CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49);
    self.toolBarTextBottonF.constant = 0;
    [self chooseIndex:self.chooseIndex];
}


- (void)backViewClick:(UIButton *)sender
{
    self.blackBackView.hidden = YES;
    [self.stockTextView.stockTextFiled resignFirstResponder];
    [self.textLiveToolBar.inputTextView resignFirstResponder];
    
}


- (void)_refreshAfterSentMessage:(EMMessage *)message
{
    EVEaseMessageModel *chatEaseMessageModel = [[EVEaseMessageModel alloc] initWithChatMessage:message];
    [self.textLiveChatTableView updateMessageModel:chatEaseMessageModel];
}

- (EVBaseToolManager *)engine
{
    if (!_engine)
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    
    return _engine;
}

#pragma mark - 关注按钮点击
- (void)followClick:(UIButton *)btn
{
    NSString *sessionID = [self.engine getSessionIdWithBlock:nil];
    
    if (sessionID == nil || [sessionID isEqualToString:@""]) {
        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
        
        [self presentViewController:navighaVC animated:YES completion:nil];
        return;
    }
    
    WEAK(self)
    BOOL followType = self.watchVideoInfo.followed ? NO : YES;
    [self.baseToolManager GETFollowUserWithName:self.watchVideoInfo.name followType:followType start:^{
        
    } fail:^(NSError *error) {
    } success:^{
        [weakself updateIsFollow:followType];
        weakself.watchVideoInfo.followed = followType;
    } essionExpire:^{
    }];
}


- (void)updateIsFollow:(BOOL)follow
{
    NSString *titleStr = follow ? @"已关注" : @"+关注";
    UIColor * backColor;
    if (follow)
    {
        backColor = [UIColor evBackGroundDeepGrayColor];
    }
    else
    {
        backColor = [UIColor evMainColor];
    }
    
    [self.headerView.followButton setBackgroundColor:backColor];
    [self.headerView.followButton setTitle:titleStr forState:(UIControlStateNormal)];
}

- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index
{
   
    CGFloat offsetX = index * self.view.frame.size.width;
    self.mainBackView.contentOffset = CGPointMake(offsetX, 0);
    [self chooseIndex:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.mainBackView) {
        NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
         [self chooseIndex:index];
          [self.topSView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
    }
}

- (void)chooseIndex:(NSInteger)index
{
    self.chooseIndex = index;
    switch (index) {
        case 0:
        {
            self.textLiveToolBar.hidden = YES;
            self.stockTextView.hidden = YES;
            self.hvtWatchBtnView.hidden = NO;
            self.hvGiftAniView.hidden = NO;
            [self updateScrollView:self.liveImageTableView];
            
        }
            break;
        case 1:
        {
            self.textLiveToolBar.hidden = YES;
            self.stockTextView.hidden = NO;
            self.hvtWatchBtnView.hidden = YES;
            self.hvGiftAniView.hidden = YES;
            [self updateScrollView:self.textLiveStockTableView];
        }
            break;
        case 2:
        {
            self.textLiveToolBar.hidden = NO;
            self.stockTextView.hidden = YES;
            self.hvtWatchBtnView.hidden = YES;
            self.hvGiftAniView.hidden = YES;
            [self updateScrollView:self.textLiveChatTableView];
        }
            break;
        case 3:
        {
            self.textLiveToolBar.hidden = YES;
            self.stockTextView.hidden = YES;
            self.hvtWatchBtnView.hidden = YES;
            self.hvGiftAniView.hidden = YES;
//            self.vipCenterView.frame = CGRectMake(0, 0, ScreenWidth, headerTopHig);
//            self.sementedBackView.frame = CGRectMake(0, headerTopHig, ScreenWidth, 44);
            
        }
            break;
            
        default:
            break;
    }
}
// 滚动结束请求数据
- (void)swipeTableViewDidEndDecelerating:(SwipeTableView *)swipeView {
    //    [self getDataAtIndex:swipeView.currentItemIndex];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.liveImageTableView updateWatchCount:self.liveVideoInfo.viewcount];
    EMError *error = nil;

    self.chatroom = [[EMClient sharedClient].roomManager joinChatroom:self.liveVideoInfo.liveID error:&error];
    
    self.liveVideoInfo.viewcount = self.chatroom.membersCount + 200;
    [self.liveImageTableView updateWatchCount:self.liveVideoInfo.viewcount];
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].roomManager addDelegate:self];
    _conversation = [[EMClient sharedClient].chatManager getConversation:_liveVideoInfo.liveID type:EMConversationTypeChatRoom createIfNotExist:YES];
}
- (void)reportButton
{
    [self shareViewShowAction];
}

- (void)setWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo
{
    _watchVideoInfo = watchVideoInfo;
    self.vipCenterView.watchVideoInfo = watchVideoInfo;
    self.headerView.inforModel = watchVideoInfo;
    NSString * watchCount = [NSString stringWithFormat:@"%d",watchVideoInfo.watching_count] ;
    self.nNameLabel.text = [NSString stringWithFormat:@"%@参与",[watchCount thousandsSeparatorString]];
    if ([watchVideoInfo.name isEqualToString:[EVLoginInfo localObject].name]) {
        self.followButton.hidden  = YES;
    }
}


- (void)setLiveVideoInfo:(EVWatchVideoInfo *)liveVideoInfo
{
    _liveVideoInfo = liveVideoInfo;
   
  
}
#pragma mark - ***************环信消息到来**************

- (void)messagesDidReceive:(NSArray *)aMessages
{


    
    
    for (EMMessage *umessage in aMessages)
    {
       
//        if ([aMessages indexOfObject:umessage] == 0)
//        {
//            self.time = [NSString stringWithFormat:@"%lld",umessage.timestamp];
//        }
        
        EVEaseMessageModel *easeMessageModel = [[EVEaseMessageModel alloc] initWithMessage:umessage];
        //直播页面的聊天记录是从自己的api获取   环信的只在聊天页面
//        if (easeMessageModel.state == EVEaseMessageTypeStateSt) {
//            [self.liveImageTableView updateTpMessageModel:easeMessageModel];
//        }
//        else
//        {
//            
//            if ([umessage.from isEqualToString:_liveVideoInfo.ownerid])
//            {
//                [self.liveImageTableView updateMessageModel:easeMessageModel];
//            }
//        }
        EVEaseMessageModel *chatEaseMessageModel = [[EVEaseMessageModel alloc] initWithChatMessage:umessage];
        [self.textLiveChatTableView updateMessageModel:chatEaseMessageModel];
    }
    //刷新自己服务器的数据
    self.cellStart = 0;
    [self loadHistoryData];
    
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
- (void)userDidJoinChatroom:(EMChatroom *)aChatroom
                       user:(NSString *)aUsername
{
    self.liveVideoInfo.viewcount++;
//    NSLog(@"self.liveVideoInfo.viewcount:%@",self.liveVideoInfo.viewcount);
    [self.liveImageTableView updateWatchCount:self.liveVideoInfo.viewcount];
}
- (void)userDidLeaveChatroom:(EMChatroom *)aChatroom
                        user:(NSString *)aUsername
{
    self.liveVideoInfo.viewcount--;
    [self.liveImageTableView updateWatchCount:self.liveVideoInfo.viewcount];
}

/** 充值火眼豆 */
- (void)rechargeYibi
{
    EVLog(@"充值火眼豆----");
    [self pushHuoYanCoin];
}

- (void)yibiNotEnough
{
    [self pushHuoYanCoin];
}
- (void)pushHuoYanCoin
{
    EVYunBiViewController *yibiVC = [[EVYunBiViewController alloc] init];
    yibiVC.asset = self.asset;
    yibiVC.delegate = self;
    [self.navigationController pushViewController:yibiVC animated:YES];
}

- (void)backButton
{
    EMError *error;
    EMChatroom *chatroom = [[EMClient sharedClient].roomManager leaveChatroom:_liveVideoInfo.liveID error:&error];
    EVLog(@"chatroom-------  %@ ---------  %d",chatroom,error.code);
    EVLog(@"_liveVideoInfo.liveID:%@",_liveVideoInfo.liveID);
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (EVLiveImageTableView *)liveImageTableView
{
    if (!_liveImageTableView) {
        _liveImageTableView = [[EVLiveImageTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:(UITableViewStyleGrouped)];
        _liveImageTableView.contentInset = UIEdgeInsetsMake(segmentHig + headerTopHig, 0, 0, 0);
    }
    return _liveImageTableView;
}

- (EVTextLiveStockTableView *)textLiveStockTableView
{
    if (!_textLiveStockTableView ) {
        _textLiveStockTableView = [[EVTextLiveStockTableView alloc] initWithFrame:CGRectMake(ScreenWidth  , 0, ScreenWidth, ScreenHeight - 49) style:(UITableViewStylePlain)];
        _textLiveStockTableView.contentInset = UIEdgeInsetsMake(segmentHig + headerTopHig, 0, 0, 0);
        
        
    }
    return _textLiveStockTableView;
}

- (EVTextLiveChatTableView *)textLiveChatTableView
{
    if (!_textLiveChatTableView) {
        _textLiveChatTableView = [[EVTextLiveChatTableView alloc] initWithFrame:CGRectMake(ScreenWidth * 2 , 0, ScreenWidth, ScreenHeight - 49) style:(UITableViewStylePlain)];
        _textLiveChatTableView.backgroundColor = [UIColor evBackgroundColor];
        _textLiveChatTableView.contentInset = UIEdgeInsetsMake(segmentHig + headerTopHig, 0, 0, 0);
        _textLiveChatTableView.tDelegate = self;
    }
    return _textLiveChatTableView;
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (EVSharePartView *)eVSharePartView {
    if (!_eVSharePartView) {
        _eVSharePartView = [[EVSharePartView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
        _eVSharePartView.backgroundColor = [UIColor colorWithHexString:@"#303030" alpha:0.7];
        _eVSharePartView.eVWebViewShareView.delegate = self;
    }
    return _eVSharePartView;
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

- (void)dealloc
{
    EMError *error;
    EMChatroom *chatroom = [[EMClient sharedClient].roomManager leaveChatroom:_liveVideoInfo.liveID error:&error];
    EVLog(@"chatroom-------  %@ ---------  %d",chatroom,error.code);
    EVLog(@"dealloc  -- EVHVWatchTextViewController");
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
