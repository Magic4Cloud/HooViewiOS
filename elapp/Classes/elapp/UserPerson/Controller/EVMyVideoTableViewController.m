//
//  EVMyVideoTableViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVMyVideoTableViewController.h"
#import "EVMyVideoTableViewCell.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVUserVideoModel.h"
#import "UIScrollView+GifRefresh.h"
#import "UIViewController+Extension.h"
#import "UzysImageCropperViewController.h"
#import "EVLiveShareView.h"
#import <PureLayout.h>
#import "EVShareManager.h"
#import "EVLoginInfo.h"
#import "EVLoadingView.h"
#import "EVTopicResponse.h"
#import "EVLiveViewController.h"
#import "EVWatchVideoInfo.h"
#import "EVNullDataView.h"
#import "EVAccountPhoneBindViewController.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"

#define tabandNav 113
#define cellsize 75

#define kShareViewHeight 202

static const NSString *const myVideoCellID = @"videoCell";


@interface EVMyVideoTableViewController ()< UIActionSheetDelegate, UIImagePickerControllerDelegate, UzysImageCropperDelegate, CCLiveShareViewDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource,CCLiveViewControllerDelegate>

/**< 数据列表视图 */
@property (weak, nonatomic  ) UITableView                    *tableView;
@property (strong, nonatomic) EVBaseToolManager                     *engine;
@property (strong, nonatomic) NSMutableArray                 *videos;
@property (strong, nonatomic) UIImagePickerController        *picker;
@property (strong, nonatomic) UzysImageCropperViewController *imageCropperViewController;
@property (strong, nonatomic) EVMyVideoTableViewCell         *currentOperationCell;
@property (copy, nonatomic  ) NSString                       *cellVideoTitle;

@property (nonatomic, weak  ) EVLiveShareView                *shareViewContainView;
@property (nonatomic, weak  ) UIView                         *noDataView;

/** 据此判断，如果是加载更多或下拉刷新，则indicator不出现 */
@property (assign, nonatomic) NSInteger                      times;

/**< 动画加载页面 */
@property (nonatomic, weak  ) EVLoadingView                  *loadingView;

/**< 话题分类容器视图 */
@property (weak, nonatomic  ) UIView                         *topicCategoryContainerView;


/**< 话题列表网络请求返回数据 */
@property (nonatomic,strong ) EVTopicResponse                *topicResponse;

/**< 返回顶部小火箭 */
@property (weak, nonatomic) UIButton *backTopBtn;

@end

@implementation EVMyVideoTableViewController

@synthesize times;

#pragma mark - life circle

- (instancetype)init{
    self = [super init];
    
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self getDataWithName:nil start:0 count:kCountNum];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.backTopBtn removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    _videos = nil;
}

- (void)dealloc
{
    [_engine cancelAllOperation];
    
    _engine = nil;
    _videos = nil;
    _picker = nil;
    _cellVideoTitle = nil;
    [_shareViewContainView removeFromSuperview];
    
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVMyVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)myVideoCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.videos.count > indexPath.row)
    {
        EVUserVideoModel *model = self.videos[indexPath.row];
        cell.videoModel = model;
    }

    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IOS8_OR_LATER)
    {
        cell.preservesSuperviewLayoutMargins = NO;
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:(ScreenWidth > 320 ?  UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f) : UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f))];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:(ScreenWidth > 320 ?  UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f) : UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f))];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVMyVideoTableViewCell *cell = (EVMyVideoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ( cell.videoModel.status != 2 )
    {
        NSString *vid = cell.videoModel.vid;
        EVWatchVideoInfo *videoInfo = [[EVWatchVideoInfo alloc] init];
        videoInfo.vid = vid;
        videoInfo.password = cell.videoModel.password;
        videoInfo.play_url = cell.videoModel.play_url;
        videoInfo.mode = cell.videoModel.mode;
        videoInfo.thumb = cell.videoModel.thumb;
        [self playVideoWithVideoInfo:videoInfo permission:cell.videoModel.permission];
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.backTopBtn.hidden = scrollView.contentOffset.y > 0 ? NO : YES;
    self.backTopBtn.alpha = (scrollView.contentOffset.y - ScreenWidth) / ScreenWidth;
}



#pragma mark - UzysImageCropperDelegate



- (void)imageCropperDidCancel:(UzysImageCropperViewController *)cropper
{
    [_imageCropperViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CCLiveShareViewDelegate
- (void)liveShareViewDidClickButton:(CCLiveShareButtonType)type
{
    NSString *nickName = [EVLoginInfo localObject].nickname;
    NSString *videoTitle = self.currentOperationCell.videoModel.title;
    NSString *shareUrlString = self.currentOperationCell.videoModel.share_url;
    UIImage *shareImage = self.currentOperationCell.videoShot.image;
    if ( type == CCLiveShareSinaWeiBoButton )
    {
        shareImage = nil;
    }
    [[EVShareManager shareInstance] shareContentWithPlatform:type shareType:ShareTypeMineVideo titleReplace:nickName descriptionReplaceName:videoTitle descriptionReplaceId:nil URLString:shareUrlString image:shareImage];
}




#pragma mark - event response

- (void)backToTop
{
    [UIView animateWithDuration:0.3f animations:^{
        self.tableView.contentOffset = CGPointMake(0, 1);
    }];
}


#pragma mark - private methods

- (void)setUI
{
    self.title = kE_GlobalZH(@"living_video");
   
    self.view.backgroundColor = [UIColor evBackgroundColor];
    // 添加tableview
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    [tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView = tableView;
    
    self.tableView.backgroundColor = [UIColor evBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = 96.0f;
    self.tableView.separatorColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVMyVideoTableViewCell_6" bundle:nil] forCellReuseIdentifier:(NSString *)myVideoCellID];
    tableView.dataSource = self;
    tableView.delegate = self;
    __weak typeof(self) weakself = self;
    [self.tableView addRefreshHeaderWithRefreshingBlock:^{
        [weakself getDataWithName:nil start:0 count:kCountNum];
    }];
    [self.tableView addRefreshFooterWithRefreshingBlock:^{
        [weakself getDataWithName:nil start:weakself.videos.count count:kCountNum];
    }];
    EVLiveShareView *shareViewContainView = [EVLiveShareView liveShareViewToTargetView:self.navigationController.view menuHeight:kShareViewHeight delegate:self];
    self.shareViewContainView = shareViewContainView;
    
    [self.tableView hideFooter];
}

- (void)getDataWithName:(NSString *)name start:(NSInteger)start count:(NSInteger)count
{
    if (self.videos.count == 0)
    {
        [self.loadingView showLoadingView];
    }
    
    times ++;
    
    NSString *type = @"video";
  
    
    __weak typeof(self) weakself = self;
    [self.engine GETUserVideoListWithName:name type:type start:start count:count startBlock:^{

    } fail:^(NSError *error) {
        [weakself.tableView endHeaderRefreshing];
        [weakself.tableView endFooterRefreshing];
        
        if (self.videos.count == 0)
        {
            [weakself.loadingView showFailedViewWithClickBlock:^{
                [weakself getDataWithName:name start:start count:count];
            }];
        }
        
    } success:^(NSArray *videos) {
        [CCProgressHUD hideHUDForView:weakself.view];
        
        if (start == 0)
        {
            weakself.videos = nil;
        }
        [weakself.videos addObjectsFromArray:videos];
        [weakself.tableView reloadData];
        [weakself.tableView endHeaderRefreshing];
        [weakself.tableView endFooterRefreshing];
        
        if ( weakself.videos.count )
        {
            [weakself.tableView showFooter];
//            [weakself addGestureGuideCoverviewWithImageNamed:@"cue_personal_video"];
        }
        else
        {
            [weakself.tableView hideFooter];
        }
        if (weakself.videos.count)
        {
            weakself.noDataView.hidden = YES;
            [weakself.noDataView removeFromSuperview];
            
            if (videos.count < count)
            {
                [weakself.tableView setFooterState:CCRefreshStateNoMoreData];
            }
            else
            {
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
        else
        {
            weakself.noDataView.hidden = NO;
        }
        
        [weakself.loadingView removeFromSuperview];
        weakself.loadingView = nil;
        
    } essionExpire:^{
//        [CCProgressHUD hideHUDForView:weakself.view];
        [weakself.tableView endHeaderRefreshing];
        [weakself.tableView endFooterRefreshing];
        CCRelogin(weakself);
    }];
}

/**
 * 更改封面，上传图片
 * 创建    马帅伟                  先获取上传路径，然后进行上传
 */
- (void)uploadImage:(UIImage *)image ForCell:(EVMyVideoTableViewCell *)cell
{
    if(![EVBaseToolManager userHasLoginLogin])
    {
        return;
    }
}

/**
 *  更新话题数据
 *
 *  @param response 新获取的数据
 */
- (void)updateTopicResponse:(EVTopicResponse *)response
{
    if ( response.count < kCountNum )
    {
  
        self.topicResponse.noMore = YES;
    }
    else
    {
    }
    
    if ( self.topicResponse == nil )
    {
        self.topicResponse = response;
    }
    else
    {
        [response.topics addObjectsFromArray:self.topicResponse.topics];
        self.topicResponse = response;
    }
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

- (NSMutableArray *)videos
{
    if (!_videos)
    {
        _videos = [NSMutableArray array];
    }
    
    return _videos;
}

- (UIImagePickerController *)picker
{
    if (!_picker)
    {
        _picker = [[UIImagePickerController alloc] init];
        _picker.allowsEditing = NO;
        _picker.delegate = self;
    }
    
    return _picker;
}

- (UIView *)noDataView
{
    if (!_noDataView)
    {
        EVNullDataView *nulldataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self.tableView addSubview:nulldataView];
        nulldataView.title = kE_GlobalZH(@"null_data");
        nulldataView.topImage = [UIImage imageNamed:@"home_pic_findempty"];
        nulldataView.buttonTitle = kE_GlobalZH(@"send_go_living");
        self.noDataView = nulldataView;
        [nulldataView addButtonTarget:self action:@selector(noDataViewButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _noDataView;
}

// 点击空列表按钮
- (void)noDataViewButtonDidClicked:(UIButton *)button
{
    [self requestNormalLivingPageForceImage:NO  allowList:nil audioOnly:NO delegate:self];
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

- (EVLoadingView *)loadingView
{
    if (!_loadingView)
    {
        EVLoadingView *loadingView = [[EVLoadingView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:loadingView];
        
        _loadingView = loadingView;
    }
    return _loadingView;
}

- (UIButton *)backTopBtn
{
    if ( !_backTopBtn )
    {
        _backTopBtn = [self addBackToTopButtonToSuperView:self.view OffsetYToBottom:.0f action:@selector(backToTop)];
    }
    
    return _backTopBtn;
}

@end
