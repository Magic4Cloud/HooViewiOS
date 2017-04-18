//
//  EVOtherPersonViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVOtherPersonViewController.h"
#import "EVOtherPersonVideoTableViewCell.h"
#import "EVFansOrFocusesTableViewController.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVUserModel.h"
#import "UIScrollView+GifRefresh.h"
#import "UIViewController+Extension.h"
#import "EVUserVideoModel.h"
#import "EVShareManager.h"
#import "EVLoginInfo.h"
#import "EVNotifyConversationItem.h"
#import "EVWatchVideoInfo.h"
#import "EVProfileHeaderView.h"
#import "EVProfileControl.h"
#import "EVAlertManager.h"
#import "EVNullDataView.h"
#import "NSString+Extension.h"
#import "EVOtherPersonBottomView.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"

#define tabandNav 113
#define cellsize 97
#define kBeyondTop 28  //  顶部图片超出屏幕之外的高度

static NSString *const ProfileCellID          = @"profileCell";
static NSString *const otherForecastCellID    = @"otherForecastCell";
static NSString *const otherPersonVideoCellID = @"otherPersonVideoCell";
static CGFloat const profileCellHeight       = 381.0f;
static CGFloat const messageButtonHeight     = 45.0f;
static CGFloat const backToTopButtonHeight   = 40.0f;

@interface EVOtherPersonViewController ()<UITableViewDataSource, UITableViewDelegate,EVProfileDelegate,EVButtonDelegete>

@property (nonatomic, strong) EVBaseToolManager *engine;
@property (nonatomic, strong) EVUserModel *userModel;

@property (nonatomic, strong) EVOtherPersonBottomView *bottomView;  /**< 底部关注、私信、拉黑视图 */
@property (nonatomic, weak  ) UIView *background;                   /**< 背景图片容器 */
@property (nonatomic, weak  ) UIView *navBottomLine;                /**< 导航条下的黑线 */
@property (nonatomic, weak  ) UIButton *top;
@property (nonatomic, weak  ) UIButton *messageSendButton;          /**< 私信发送按钮 */
@property (nonatomic, weak  ) UIButton *pullBlackButton;            /**< 拉黑按钮 */
@property (nonatomic, weak  ) UILabel *topTitle;                    /**< titleLabel */
@property (nonatomic, weak  ) UIImageView *backgroudImageV;

@property (nonatomic, strong) NSMutableArray *videos;
@property (nonatomic, strong) NSString *shareUrl;                   /**< 分享出去的url */
@property (nonatomic, assign) BOOL isScrolling;                     /**< 是否正在滚动 */

@end

@implementation EVOtherPersonViewController

#pragma mark - class and instance methods
+ (instancetype)instanceWithName:(NSString *)name {
    EVOtherPersonViewController *otherPersonVC = [[EVOtherPersonViewController alloc] init];
    otherPersonVC.name = name;
    return otherPersonVC;
}

- (instancetype)initWithName:(NSString *)name{
    return [EVOtherPersonViewController instanceWithName:name];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self fetchOtherPersonVCData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tableHeaderView.userModel = self.userModel;
    [self.tableView reloadData];
    
    // 默认从本地数据库中读取数据
    [self getUserInfoFromDB];
    
    // 为了进入房间返回后，刷新tableView
    if (self.videos.count > 0) {
        NSInteger requestCount = self.videos.count;
        [self getVidedesDataWithName:self.name start:0 count:requestCount isRefresh:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tableHeaderView.userModel = self.userModel;
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self isMovingFromParentViewController]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(modifyUserModel:)]) {
            [self.delegate modifyUserModel:self.userModel];
        }
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    _userModel = nil;
    _videos = nil;
}

- (void)dealloc{
    [self.tableView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    [_engine cancelAllOperation];
    _engine = nil;
    _userModel = nil;
    _videos = nil;
}


#pragma mark - build UI
/**
 *  界面构建
 */
- (void)setUI{
    self.title = kE_GlobalZH(@"other_people");
    self.collectionView.backgroundColor = [UIColor evBackgroundColor];
    [self.collectionView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    [self.collectionView removeFromSuperview];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableHeaderView.delegate = self;
    self.tableHeaderView.style = EVProfileHeaderViewStyleOtherPerson;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EVOtherPersonVideoTableViewCell" bundle:nil] forCellReuseIdentifier:otherPersonVideoCellID];
  
    // 返回顶部
    [self addBackToTopButton];
    
    __weak typeof(self) weakself = self;
    [self.tableView addRefreshFooterWithRefreshingBlock:^{
        [weakself getVidedesDataWithName:self.name start:weakself.videos.count count:kCountNum isRefresh:NO];
    }];
    [self.tableView hideFooter];
    
    [self.view addSubview:self.bottomView];
//    [[EVEaseMob sharedInstance].chatManager asyncFetchBlockedListWithCompletion:^(NSArray *blockedList, EMError *error) {
//        if (!error) {
//            self.bottomView.pullBlackButton.selected = [blockedList containsObject:self.userModel.imuser];
//        }
//    } onQueue:nil];
}

/**
 *  添加返回顶部按钮
 */
- (void)addBackToTopButton
{
    UIButton *top = [UIButton buttonWithType:UIButtonTypeCustom];
    top.frame = CGRectMake(ScreenWidth - 15.0f - backToTopButtonHeight, self.view.bounds.size.height - messageButtonHeight - backToTopButtonHeight - 15.0f, backToTopButtonHeight, backToTopButtonHeight);
    [top setImage:[UIImage imageNamed:@"personal_top"] forState:UIControlStateNormal];
    [top addTarget:self action:@selector(backToTop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:top];
    top.hidden = YES;
    self.top = top;
}

- (void)bottomButtonType:(EVBottomButtonType)buttonType button:(UIButton *)button
{
    switch (buttonType) {
        case EVBottomButtonTypeMessage: {
            [self sendMessageToOtherPerson];
            break;
        }
        case EVBottomButtonTypeFollow: {
            
            [self editProfileOrAddToFocus:button];
            break;
        }
        case EVBottomButtpnTypePullBack:
        {
            [self clickPullBlackButton:button];
            break;
        }
            
        default: {
            
            break;
        }
    }
}

#pragma mark - fetch data
/**
 *  从本地数据库中读取数据
 */
- (void)getUserInfoFromDB
{
    NSString *name = self.name;
    if ( name && ![name isEqualToString:@""])
    {
        __weak typeof(self) weakself = self;
        [EVUserModel getUserInfoModelWithName:name complete:^(EVUserModel *model) {
            if ( model )
            {
                weakself.userModel = model;
                weakself.tableHeaderView.userModel = model;
                [self.tableView reloadData];
            }
            
            // 获取网络请求，在读取数据库成功里发送网络请求保证网络请求在数据库操作成功后执行
            [self setUpData];
        }];
    }
}
/**
 *  从网络获取数据
 */
- (void)setUpData
{
    if ( [NSString isBlankString:self.name] )
    {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.engine GETUserInfoWithUname:self.name
                          orImuser:nil
                             start:nil
                              fail:nil
                           success:^(NSDictionary *modelDict)
     {
         EVUserModel *model = [EVUserModel objectWithDictionary:modelDict];
         weakSelf.userModel = model;
         [model updateToLocalCacheComplete:nil];
         self.bottomView.followButton.selected = model.followed;
         self.tableHeaderView.userModel =  model;
         [weakSelf.tableView reloadData];
         
         
         // 如果是当前用户，隐藏加关注按钮
         if ( [EVLoginInfo checkCurrUserByName:weakSelf.userModel.name] )
         {
             [weakSelf.tableHeaderView hiddenEditMarkButton:YES];
         }
     }
                     sessionExpire:^
     {
         EVRelogin(weakSelf);
     }];
}

- (void)fetchOtherPersonVCData {
    [self getVidedesDataWithName:self.name start:0 count:kCountNum isRefresh:NO];
}

/**
 *  根据用户的云播号，获取用户的视频列表
 *
 *  @param name  云播号
 *  @param isRefresh 是否只是为了刷新当前页(只在-viewWillAppear中用到)
 */
- (void)getVidedesDataWithName:(NSString *)name start:(NSInteger)start count:(NSInteger)count isRefresh:(BOOL)YorN {
    __weak typeof(self) weakself = self;
    [self.engine GETUserVideoListWithName:name type:@"all" start:start count:count startBlock:^{
        
    } fail:^(NSError *error) {
        [weakself.tableView endFooterRefreshing];
        // TO DO :
        
    } success:^(NSArray *videos) {
        if (YorN) {
            [weakself.videos removeAllObjects];
        }
        [weakself.videos addObjectsFromArray:videos];
        if (weakself.videos.count > 0) {
            BOOL YorN = [(EVUserVideoModel *)weakself.videos[0] living];
            [weakself.tableHeaderView setOtherContreIsLiving:YorN];
        }
        [weakself.tableView endFooterRefreshing];
        [weakself.tableView reloadData];
        
        // 处理数据列表为空的情况，当前页面显示为没有视频
        if ( weakself.videos.count )
        {
            [weakself.tableView showFooter];
        }
        else
        {
            [weakself.tableView hideFooter];
        }
        if (weakself.videos.count) {
            if (videos.count < count) {
                [weakself.tableView setFooterState:CCRefreshStateNoMoreData];
            } else {
                [weakself.tableView setFooterState:CCRefreshStateIdle];
            }
            //数据没有满一频目的时候盈藏加载更多
            if((ScreenHeight - tabandNav) / cellsize >= weakself.videos.count && videos.count < count)
            {
                [weakself.tableView hideFooter];
            }else
            {
                [weakself.tableView showFooter];
            }
        }
    } essionExpire:^{
        [weakself.tableView endFooterRefreshing];
        
        EVRelogin(weakself);
    }];
}


#pragma mark - actions
/**
 *  返回顶部动画
 */
- (void)backToTop {
    
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

/**
 *  push到下个页面：粉丝或关注页面
 */
- (void)pushViewControllerWithControllerType:(controllerType)type
{
    EVFansOrFocusesTableViewController *fansOrFocusesTVC = [[EVFansOrFocusesTableViewController alloc] init];
    fansOrFocusesTVC.type = type;
    fansOrFocusesTVC.name = self.name;
    [self.navigationController pushViewController:fansOrFocusesTVC animated:YES];
}
// 私信拉黑
- (void)clickPullBlackButton:(UIButton *)button
{
    button.enabled = NO;
    if ( button.selected == YES )
    {
//        [[EVEaseMob sharedInstance].chatManager asyncUnblockBuddy:self.userModel.imuser withCompletion:^(NSString *username, EMError *error) {
//            if ( !error )
//            {
//                [EVProgressHUD showSuccess:kE_GlobalZH(@"relieve_blacklist_success")];
//                button.selected = NO;
//            }
//            else
//            {
//                [EVProgressHUD showError:kE_GlobalZH(@"relieve_blacklist_fail")];
//            }
//            button.enabled = YES;
//            
//        } onQueue:nil];
    }
    else
    {
        NSString *title = kE_GlobalZH(@"to_blacklist_not_receive_message");
        [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:title cancelButtonTitle:kCancel comfirmTitle:kOK WithComfirm:^{
            
//            [[EVEaseMob sharedInstance].chatManager asyncBlockBuddy:self.userModel.imuser relationship:eRelationshipFrom withCompletion:^(NSString *username, EMError *error) {
//                if ( !error )
//                {
//                    //                     NSString *remarks = [[CCUserRemarks shareInstance] remarksForName:self.userModel.name nickName:self.userModel.nickname];
//                    //                    NSString *msg = [NSString stringWithFormat:@"%@已经列入黑名单,可以在\"个人中心-设置-黑名单\"中解除.",remarks];
//                    [EVProgressHUD showSuccess:kE_GlobalZH(@"add_blacklist_success")];
//                    button.selected = YES;
//                }
//                else
//                {
//                    [EVProgressHUD showError:kE_GlobalZH(@"add_blacklist_fail")];
//                }
//                button.enabled = YES;
//            } onQueue:nil];
            
        } cancel:^{
            button.enabled = YES;
        }];
    }
}

/**< 关注/取消关注 */
- (void)editProfileOrAddToFocus:(UIButton *)sender
{
    __weak typeof(self) weakself = self;
    __weak typeof(sender) button = sender;
    [self.engine GETFollowUserWithName:self.userModel.name followType:!self.userModel.followed start:nil fail:^(NSError *error) {
        
    } success:^{
        weakself.userModel.followed = !weakself.userModel.followed;
        [weakself.userModel updateToLocalCacheComplete:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakself.userModel.followed)
            {
                [EVProgressHUD showSuccess:kE_GlobalZH(@"follow_success")];
                button.selected = NO;
            }
            else
            {
                [EVProgressHUD showSuccess:kE_GlobalZH(@"e_cancel_follow")];
                button.selected = YES;
            }
            
            button.selected = weakself.userModel.followed;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInterestingGuys" object:nil];
        });
    } essionExpire:^{
        EVRelogin(weakself);
    }];
}
/**< 发送私信 */
- (void)sendMessageToOtherPerson
{
    EVLog(@"向别人发消息！");
    // 如果是私信聊天页面过来的，则退回聊天页面
    if ( self.dismissMsgBtn )
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    // 如果用户有环信账号，则可以进入聊天页面
    if ( self.userModel.imuser.length )
    {
        if ( self.userModel.imuser == nil || [self.userModel.imuser isEqualToString:@""])
        {
            [EVProgressHUD showError:kE_GlobalZH(@"failChat")];
            return;
        }
//        EVNotifyConversationItem *conversationItem = [[EVNotifyConversationItem alloc] init];
//        conversationItem.userModel = self.userModel;
//        conversationItem.conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.userModel.imuser conversationType:eConversationTypeChat];
//        EVChatViewController *chatVC = [[EVChatViewController alloc] init];
//        chatVC.conversationItem = conversationItem;
//        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

- (void)back
{
    if ( self.navigationController.childViewControllers.count > 1 )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ( self.navigationController.childViewControllers.count == 1 )
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - Delegates
#pragma mark - fore cast delegate

- (void)_foreCastPlayVideoWithForecastModel:(CCForeShowItem *)forecastMdoel
{
    __weak typeof(self) wself = self;
    
    [wself requestForecastLivingWithForecastItem:forecastMdoel delegate:wself];
}



#pragma mark - CCProfileDelegate
// 点击底部四个control
- (void)clickProfileControl:(EVProfileControl *)control
{
    if ( [control.title isEqualToString:CCProfileControlTitleVideo] )
    {
         //[self radioScan];
    }

    if ( [control.title isEqualToString:CCProfileControlTitleFocus] )
    {
        [self focusScan];
    }
    if ( [control.title isEqualToString:CCProfileControlTitleFans] )
    {
        [self fanScan];
    }
}

// 点击头像
- (void)clickHeaderButton:(EVHeaderButton *)button image:(UIImage *)image
{
    if ( image == nil )
    {
        return;
    }
    [self biggerAvatar:image];
}

- (void)changeBackgroundImage:(UIImage *)image
{
}



// 点击‘房间视图’进入房间
- (void)clickRoomView {
    /**
     *  self.videos[0] 就是“正在直播”的数据
     */
    
    if (self.fromLivingRoom) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        EVWatchVideoInfo *videoInfo = [[EVWatchVideoInfo alloc] init];
        if (self.videos.count > 0) {
            EVUserVideoModel *model = (EVUserVideoModel *)self.videos[0];
            videoInfo.mode = model.mode;
            videoInfo.vid = model.vid;
            videoInfo.password = model.password;
            videoInfo.play_url = model.play_url;
        }
        videoInfo.thumb = self.userModel.logourl;
        videoInfo.name = self.name;
        [self playVideoWithVideoInfo:videoInfo permission:EVLivePermissionSquare];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        EVOtherPersonVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)otherPersonVideoCellID];
        if (indexPath.row >= self.videos.count)
        {
            return cell;
        }
        cell.model = self.videos[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.videos.count || self.userModel.video_count != 0) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    } else {
        CGFloat noDataViewH = ScreenHeight - profileCellHeight;
        EVNullDataView *nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, noDataViewH)];
        nullDataView.topImage = [UIImage imageNamed:@"home_pic_findempty"];
        nullDataView.title = kE_GlobalZH(@"null_data");
        [nullDataView show];
        return nullDataView;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if ( indexPath.section == 0 )
    {
        return 96.f;
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerH;
    if (self.videos.count == 0 && self.userModel.video_count == 0) {
        headerH = ScreenHeight - profileCellHeight;
    } else {
        headerH = CGFLOAT_MIN;
    }
    return headerH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (self.fromLivingRoom) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            EVWatchVideoInfo *videoInfo = [[EVWatchVideoInfo alloc] init];
            EVOtherPersonVideoTableViewCell *cell = (EVOtherPersonVideoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            videoInfo.mode = cell.model.mode;
            videoInfo.vid = cell.model.vid;
//            videoInfo.password = cell.model.password;
            videoInfo.mode = cell.model.mode;
            videoInfo.play_url = cell.model.play_url;
            videoInfo.thumb = self.userModel.logourl;
            videoInfo.name = self.name;
            [self playVideoWithVideoInfo:videoInfo permission:cell.model.permission];
    }
}

#pragma mark - scrow view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat offsetY = 0.0f;
    if ( scrollView.contentOffset.y - offsetY > 0 && scrollView.contentOffset.y > 0)
    {
        // 给发私信按钮一个隐藏到底部的动画
        if ( !self.isScrolling )
        {
            __weak typeof(self) weakself = self;
            [UIView animateWithDuration:.4f animations:^{
                weakself.bottomView.frame = CGRectMake(.0f, self.view.bounds.size.height, ScreenWidth, messageButtonHeight);
            } completion:^(BOOL finished) {
                
            }];
        }
        self.isScrolling = YES;
    }
    
    self.top.hidden = scrollView.contentOffset.y > 0 ? NO : YES;
    self.top.alpha = (scrollView.contentOffset.y - ScreenWidth) / ScreenWidth;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 给发私信按钮一个从底部显示动画
    if ( self.isScrolling )
    {
        __weak typeof(self) weakself = self;
        [UIView animateWithDuration:.4f animations:^{
            weakself.bottomView.frame = CGRectMake(.0f, self.view.bounds.size.height - messageButtonHeight, ScreenWidth, messageButtonHeight);
        } completion:^(BOOL finished) {
            
        }];
        self.isScrolling = NO;
    }
}

#pragma mark - CCOtherProfileTableViewCellDelegate

- (void)fanScan
{
    [self pushViewControllerWithControllerType:FANS];
}

- (void)focusScan
{
    [self pushViewControllerWithControllerType:FOCUSES];
}


#pragma mark - getters and setters
- (EVBaseToolManager *)engine
{
    if (!_engine)
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    
    return _engine;
}

- (NSMutableArray *)videos{
    if (!_videos)
    {
        _videos = [NSMutableArray array];
    }
    
    return _videos;
}


- (void)setUserModel:(EVUserModel *)userModel {
    _userModel = userModel;
    
    NSString *title = self.userModel.nickname;
    self.title = title;
    self.topTitle.text = userModel.nickname;
    
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    
    if ( [loginInfo.name isEqualToString:self.userModel.name])
    {
        self.bottomView.hidden = YES;
    }
    else
    {
        self.bottomView.hidden = NO;
    }
}

- (EVOtherPersonBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[EVOtherPersonBottomView alloc] initWithFrame:CGRectMake(0, ScreenHeight - bottomViewHeight, ScreenWidth, bottomViewHeight)];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

@end
