//
//  EVTimeLineNewVideoViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVTimeLineNewVideoViewController.h"
#import <PureLayout.h>
#import "UIViewController+Extension.h"
#import "EVWatchVideoInfo.h"
#import "EVCircleRecordedModel.h"
#import "EVBaseToolManager+EVHomeAPI.h"
#import "UIScrollView+GifRefresh.h"
#import "EVVideoTopicItem.h"
#import "EVOtherPersonViewController.h"
#import "EVLiveVideoCollectionViewCell.h"
#import "EVHomeTabbar.h"
#import "EVBeatyCollectionViewCell.h"
#import "EVTimeLineNewVideoLayout.h"
#import "EVCycleScrollView.h"
#import "EVCarouselItem.h"
#import "EVDetailWebViewController.h"
#import "EVLoginInfo.h"
#import "NSString+Extension.h"
#import "EVCategoryViewController.h"
#import "EVHomeLiveVideoListCollectionViewCell.h"


#define TopicsViewHeight 65.0f
#define TopicsViewId @"TopicsViewId"
#define CircleHeaderViewId @"CircleHeaderViewId"
#define kTopicId_beauty @"10001"
#define kTopicId_all @"0"
#define kPushNextPage  @"pushNextPageCenter"

@interface EVTimeLineNewVideoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, CCLiveVideoViewDelegate,EVCycleScrollViewDelegate,EVCategoryViewControllerDelegate, EVHomeLiveVideoListCollectionViewCellDelegate>

@property (strong, nonatomic) EVTimeLineNewVideoLayout *layout; /**< collectionview布局 */
@property (weak, nonatomic) UICollectionView *collectionView;  /**< 数据展示列表 */
@property (strong, nonatomic) UICollectionReusableView *headerBannerView; /**< headerview 滚动视图 */
@property (strong, nonatomic) NSMutableDictionary *videoDictM; /**< 存放各个话题下对应的视频列表 */
@property (copy, nonatomic) NSString *currentSelectedTopicId;  /**< 当前选中的topic id */
@property (strong, nonatomic) EVBaseToolManager *engine; /**< 网络请求引擎 */
@property (nonatomic, assign) NSInteger lastNext;   /** 用于加载更多，下次开始加载的起始项 */
@property (assign, nonatomic) CGPoint oldPoint;


@property (nonatomic , weak) EVCycleScrollView *heardScrollV;

@property (nonatomic, strong) NSMutableArray *headScrollArray;

@property (nonatomic, strong) NSMutableArray *livingArray;

@property (nonatomic, strong) EVVideoTopicItem *topicItem;

@property (nonatomic, copy) NSString *starCount;

@end

@implementation EVTimeLineNewVideoViewController

@synthesize currentSelectedTopicId = _currentSelectedTopicId;

#pragma mark - life circle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor evBackgroundColor];
//    [CCNotificationCenter addObserver:self selector:@selector(pushNextPage) name:kPushNextPage object:nil];
    [self setUpUI];
  
    // 添加kvo
    [self addObserver];
    self.currentSelectedTopicId = 0;
    // 获取默认话题对应的视频列表数据
    [self loadDefaultData];
}

- (void)pushNextPage
{
    EVCategoryViewController *categoryVC =  [[EVCategoryViewController alloc]init];
    categoryVC.delegate = self;
    [categoryVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:categoryVC animated:YES];
}

- (void)liveCategoryViewDidSelectItem:(EVVideoTopicItem *)item
{
    if (item == nil || ![item isKindOfClass:[item class]]) {
        return;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObject:item forKey:@"topicItem"];
    self.topicItem = item;
    [CCNotificationCenter  postNotificationName:@"postTopicItem" object:nil userInfo:dict];
    if (item == nil || ![item isKindOfClass:[item class]]) {
    
        
    }else{
        self.viewControllerItem.title = item.title;
        self.currentSelectedTopicId = item.topic_id;
        [self.collectionView startHeaderRefreshing];
        [self loadTopicVideoDataWithTopicId:item.topic_id start:0 count:kCountNum];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [CCNotificationCenter removeObserver:self];
    [_engine cancelAllOperation];
    _engine = nil;
    [_collectionView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
}

#pragma mark - EVCycleScrollViewDelegate
- (void)cycleScrollViewDidSelected:(EVCarouselItem *)item index:(NSInteger)index
{
    if ( [item isKindOfClass:[EVCarouselItem class]] )
    {
        // TODO: 检查活动类型
        EVCarouselItem *carousItem = item;
        if (carousItem.activetyID && ![carousItem.activetyID isEqualToString:@""])
        {
            
        }
        else
        {
            [self gotoActivityWebViewPageWithTitle:carousItem.title activityUrl:carousItem.web_url activityId:carousItem.activetyID shareImage:carousItem.image imageStr:carousItem.thumb isEnd:NO];
        }
        
    }
    
}

// H5活动详情
- (void)gotoActivityWebViewPageWithTitle:(NSString *)title
                             activityUrl:(NSString *)activityUrl
                              activityId:(NSString *)activityId
                              shareImage:(UIImage *)shareImage
                                imageStr:(NSString *)coverImageStr
                                   isEnd:(BOOL)isEnd
{
    if (activityUrl == nil || [activityUrl isEqualToString:@""]) {
        return;
    }
    EVLoginInfo *loginF = [EVLoginInfo localObject];
    activityUrl = ![activityUrl cc_rangeString:@"sessionid="] ? [NSString stringWithFormat:@"%@?session=%@",activityUrl,loginF.sessionid] : activityUrl;
    EVDetailWebViewController *detailVC = [EVDetailWebViewController activityDetailWebViewControllerWithURL:activityUrl];
    detailVC.activityTitle = title;
    detailVC.image = shareImage;
    detailVC.imageStr = coverImageStr;
    detailVC.activityId = activityId;
    detailVC.isEnd = isEnd;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - EVHomeLiveVideoListCollectionViewCellDelegate

- (void)toOtherPersonalUserCenter:(EVCircleRecordedModel *)model
{
                EVOtherPersonViewController *otherVC = [EVOtherPersonViewController instanceWithName:model.name];
                otherVC.fromLivingRoom = NO;
                [self.navigationController pushViewController:otherVC animated:YES];
}
- (void)playVideo:(EVCircleRecordedModel *)model
{
        EVWatchVideoInfo *videoInfo = [[EVWatchVideoInfo alloc] init];
        videoInfo.vid = model.vid;
        videoInfo.play_url = model.play_url;
        videoInfo.thumb = model.thumb;
        [self playVideoWithVideoInfo:videoInfo permission:model.permission];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

        return self.livingArray.count;
    
  
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusabelView = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        if ( indexPath.section == 0 )
        {
            /**
             *  edit by 刘传瑞
             *  >> 避免 headerView 刷新时，内容视图出现‘漂移’
             */
            if (_headerBannerView == nil) {
                _headerBannerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:TopicsViewId forIndexPath:indexPath];
                EVCycleScrollView *cycleScrollView = [[EVCycleScrollView alloc] initWithFrame:_headerBannerView.frame];
                cycleScrollView.delegate = self;
                cycleScrollView.items    = self.headScrollArray;
                self.heardScrollV        = cycleScrollView;
                [_headerBannerView addSubview:cycleScrollView];
            }
            reusabelView = self.headerBannerView;
            
        }
    }
    return reusabelView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//     预加载
    if ( self.livingArray.count > 0 &&
             self.livingArray.count < 5 &&
             indexPath.section == 0 &&
             indexPath.row == self.livingArray.count)
    {
        [self handleRefreshRequestWithStart:self.lastNext];
    }

    EVCircleRecordedModel * model = nil;
    if ( indexPath.row < self.livingArray.count ) {
            model = self.livingArray[indexPath.row];
    }
    // change by 佳南
//    EVBeatyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[EVBeatyCollectionViewCell cellIdentifier] forIndexPath:indexPath];
//    if ( indexPath.row >= self.livingArray.count ) {
//                    return cell;
//    }
//    cell.model = model;
//    __weak typeof(self) weakself = self;
//    cell.avatarClick = ^(EVCircleRecordedModel *model){
//            EVOtherPersonViewController *otherVC = [EVOtherPersonViewController instanceWithName:model.name];
//            otherVC.fromLivingRoom = NO;
//            [weakself.navigationController pushViewController:otherVC animated:YES];
//    };
    EVHomeLiveVideoListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EVHomeLiveVideoListCollectionViewCell class]) forIndexPath:indexPath];
    if ( indexPath.row >= self.livingArray.count ) {
                            return cell;
    }
    cell.delegate = self;
    cell.model = model;
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // delete by 佳南
//    CCLog(@"--Video be clicked!--");
// 
//    if ( indexPath.row >= self.livingArray.count )
//    {
//        return;
//    }
//
//    EVBeatyCollectionViewCell *cell = (EVBeatyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    EVWatchVideoInfo *videoInfo = [[EVWatchVideoInfo alloc] init];
//    videoInfo.vid = cell.model.vid;
//    videoInfo.play_url = cell.model.play_url;
//    videoInfo.thumb = cell.model.thumb;
//    [self playVideoWithVideoInfo:videoInfo permission:cell.model.permission];
}

#pragma mark - CCLiveVideoViewDelegate

- (void)clickHeadImageForVideo:(EVCircleRecordedModel *)video
{
    [self push_2_OtherPersonWithName:video.name];
}

#pragma mark - CCVideoViewDelegate

- (void)clickLogoBtnWithName:(NSString *)name
{
    [self push_2_OtherPersonWithName:name];
}

#pragma mark - private methods

- (void)push_2_OtherPersonWithName:(NSString *)name
{
    if ( name == nil || [name isEqualToString:@""] )
    {
        return;
    }
    
    EVOtherPersonViewController *otherPersonVC = [EVOtherPersonViewController instanceWithName:[name mutableCopy]];
    otherPersonVC.fromLivingRoom = NO;
    [self.navigationController pushViewController:otherPersonVC animated:YES];
}


- (void)setUpUI
{
    UIView *containerV = [[UIView alloc] init];
    [self.view addSubview:containerV];
    containerV.backgroundColor = [UIColor evBackgroundColor];
    [containerV autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    
    // tableView header
    CGFloat whRate  = BannerWidthHeightRate;
    CGFloat headerW = ScreenWidth;
    CGFloat banderH = headerW / whRate;
    // 切换成collectionview的形式展示
    EVTimeLineNewVideoLayout *layout = [[EVTimeLineNewVideoLayout alloc] init];
    layout.headHeight = banderH;
    layout.firstSectionItemHeight = [EVHomeLiveVideoListCollectionViewCell cellSize].height;
    layout.secondSectionItemHeight = (ScreenWidth - 10 * 3) / 2 + 48;
    self.layout = layout;
      layout.firstSectionItemHeight = [EVHomeLiveVideoListCollectionViewCell cellSize].height;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[EVLiveVideoCollectionViewCell class] forCellWithReuseIdentifier:[EVLiveVideoCollectionViewCell cellIdentifier]];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([EVHomeLiveVideoListCollectionViewCell class])  bundle:[NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([EVHomeLiveVideoListCollectionViewCell class])];
    [collectionView registerClass:[EVBeatyCollectionViewCell class] forCellWithReuseIdentifier:[EVBeatyCollectionViewCell cellIdentifier]];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TopicsViewId];
    [containerV addSubview:collectionView];
    containerV.backgroundColor = [UIColor evBackgroundColor];
    [collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    collectionView.contentInset = UIEdgeInsetsMake(64, 0, HOMETABBAR_HEIGHT, 0);
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    
    // fix by 马帅伟 上下拉刷新保护
    __weak typeof(self) weakself = self;
    [collectionView addRefreshHeaderWithRefreshingBlock:^
     {
         [weakself loadImageCarousel];
         if ([self.currentSelectedTopicId isEqualToString:@""] || self.currentSelectedTopicId  == nil) {
             [weakself loadTopicVideoDataWithTopicId:@"0" start:0 count:kCountNum];
         }else{
            [weakself loadTopicVideoDataWithTopicId:weakself.currentSelectedTopicId start:0 count:kCountNum];
         }
         
     }];
    [collectionView addRefreshFooterWithRefreshingBlock:^
     {
         if ([self.currentSelectedTopicId isEqualToString:@""] || self.currentSelectedTopicId  == nil) {
             [weakself loadTopicVideoDataWithTopicId:@"0" start:weakself.lastNext count:kCountNum];
         }else{
             [weakself loadTopicVideoDataWithTopicId:weakself.currentSelectedTopicId start:weakself.lastNext count:kCountNum];
         }
     }];
    
}

#pragma mark - 轮播图
// 请求轮播图
- (void)loadImageCarousel
{
    WEAK(self)
    [self.engine GETCarouselInfoWithStart:^{
        
    } success:^(NSDictionary *info) {
        [weakself handleCommonAfterRequest];
        [weakself getCarouseInfoSuccess:info];
    } fail:^(NSError *error) {
        
    } sessionExpire:^{
        CCRelogin(weakself);
    }];
}

// 处理得到的轮播图
- (void)getCarouseInfoSuccess:(NSDictionary *)info
{
    NSArray *items = [EVCarouselItem objectWithDictionaryArray:info[kObjects]];
    self.heardScrollV.items = items;
    self.headScrollArray = [items mutableCopy];
    [self.collectionView reloadData];
}

/**
 *  处理刷新时的网络请求
 *
 *  @param start 请求数据开始项
 */
- (void)handleRefreshRequestWithStart:(NSInteger)start
{
    [self.engine cancelAllOperation];
    if ( start == 0 )
    {
        [self.collectionView endFooterRefreshing];
    }
    else
    {
        [self.collectionView endHeaderRefreshing];
    }
    

    [self loadTopicVideoDataWithTopicId:self.currentSelectedTopicId start:start count:kCountNum];
}

- (void)addObserver
{
    // 监听tableview的滑动
    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}

// 监听偏移量变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( context == NULL && [keyPath isEqualToString:@"contentOffset"] )
    {
        
        CGPoint newPoint = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        // 上滑
        if ( newPoint.y - _oldPoint.y > 0 && newPoint.y > 0 )
        {
            [self.homeScrollView homeScrollViewControllerHideBar];
        }
        else if (newPoint.y - _oldPoint.y < 0 )
        {
            [self.homeScrollView homeScrollViewControllerShowBar];
        }
        self.oldPoint = newPoint;
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)loadDefaultData
{
    [self loadTopicVideoDataWithTopicId:self.currentSelectedTopicId start:0 count:kCountNum];
    [self loadImageCarousel];

}

- (void)handleRequestSuccesWithVideoInfo:(NSDictionary *)info
                            requestStart:(NSInteger)start
                                 topicId:(NSString *)topicId
{
    [self handleCommonAfterRequest];
    NSInteger lastNext = [info[kNext] integerValue];
    self.lastNext = lastNext;
    self.starCount = info[kStart];
    NSArray *videosTemp = info[@"videos"];
    NSArray *videos_model_temp = [EVCircleRecordedModel objectWithDictionaryArray:videosTemp];
    
    if ( start == 0 )
    {
        [self.livingArray removeAllObjects];
    }
    
    [self.collectionView setFooterState:(videos_model_temp.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
    
    // 对本次获取到的数据进行分组分别插入推荐(推荐中保存包含推荐、直播视频)、非推荐视频(纯录播)数组中
    [self.livingArray addObjectsFromArray:videos_model_temp];
    [self.collectionView reloadData];
}


//获取热门数据
- (void)loadTopicVideoDataWithTopicId:(NSString *)topicId
                                start:(NSInteger)start
                                count:(NSInteger)count
{
    __weak typeof(self) weakself = self;
   [self.engine GETTopicVideolistStart:start count:count topicid:topicId start:^{
        
    } fail:^(NSError *error) {
        [weakself handleCommonAfterRequest];
    } success:^(NSDictionary *videoInfo) {
        [weakself handleRequestSuccesWithVideoInfo:videoInfo
                                      requestStart:start
                                           topicId:topicId];
    } sessionExpired:^{
        [weakself handleCommonAfterRequest];
        CCRelogin(weakself);
    }];
}

- (void)handleCommonAfterRequest
{
    [self.collectionView endHeaderRefreshing];
    [self.collectionView endFooterRefreshing];
}

- (void)addDataToDictionaryWithArray:(NSArray *)arr
                         withTopicId:(NSString *)topicId
{
    NSArray *arr_new = [NSArray arrayWithArray:arr];
    [self.videoDictM setValue:arr_new forKey:topicId];
}

#pragma mark - setters and getters
- (EVBaseToolManager *)engine
{
    if ( !_engine )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    
    return _engine;
}

- (NSString *)currentSelectedTopicId
{
    if ( _currentSelectedTopicId == nil || [_currentSelectedTopicId isEqualToString:@""] )
    {

            _currentSelectedTopicId = kTopicId_all;
    }
    
    return _currentSelectedTopicId;
}

//直播数组
- (NSMutableArray *)livingArray
{
    if (!_livingArray) {
        _livingArray = [NSMutableArray array];
    }
    return _livingArray;
}

//轮播图数组
- (NSMutableArray *)headScrollArray
{
    if (_headScrollArray == nil) {
        _headScrollArray = [NSMutableArray array];
    }
    return _headScrollArray;
}

@end
