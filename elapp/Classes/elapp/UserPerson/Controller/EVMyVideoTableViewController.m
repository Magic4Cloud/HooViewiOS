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
#import "NSString+Extension.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVStreamer+Extension.h"
#import "AFNetworking.h"
#import "EVHVWatchViewController.h"
#import "EVNullDataView.h"
#import "EVHVCenterLiveView.h"
#import "EVTextLiveModel.h"
#import "EVHVWatchTextViewController.h"


#define tabandNav 113
#define cellsize 75

typedef enum:NSInteger {
    EVActionSheetTypeAll = 1001, //总的修改
    EVActionSheetTypePhoto, //图片资源修改
    EVActionSheetTypeDelete,
}EVActionSheetType;

static const NSString *const myVideoCellID = @"videoCell";


@interface EVMyVideoTableViewController ()< UIActionSheetDelegate, UIImagePickerControllerDelegate, UzysImageCropperDelegate, CCLiveShareViewDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource,CCLiveViewControllerDelegate,EVMyVideoCellDelegate>

/**< 数据列表视图 */
@property (weak, nonatomic  ) UITableView                    *tableView;
@property (strong, nonatomic) EVBaseToolManager              *engine;
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

/**< 返回顶部小火箭 */
@property (weak, nonatomic) UIButton *backTopBtn;

@property (nonatomic, weak ) EVNullDataView *nullDataView;

@property (nonatomic, weak ) EVNullDataView *liveDataView;

@property (nonatomic, strong) EVHVCenterLiveView *hvCenterLiveView;
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
    [self loadIsHaveTextLive];
//    [self getDataWithName:nil start:0 count:kCountNum];
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
    cell.delegate = self;
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

- (void)imageCropper:(UzysImageCropperViewController *)cropper didFinishCroppingWithImage:(UIImage *)image
{
    UIImage *videoUpdatingThumb = [UIImage scaleImage:image scaleSize:CGSizeMake(960, 540)];
    // TO DO : upload picture
    [self uploadImage:videoUpdatingThumb ForCell:self.currentOperationCell];
    [_imageCropperViewController dismissViewControllerAnimated:YES completion:nil];
    
    // 更改by：mashuaiwei，释放照片剪切控制器，释放内存
    _imageCropperViewController = nil;
}

#pragma mark - EVLiveShareViewDelegate
- (void)liveShareViewDidClickButton:(EVLiveShareButtonType)type
{
    NSString *nickName = [EVLoginInfo localObject].nickname;
    NSString *videoTitle = self.currentOperationCell.videoModel.title;
    NSString *shareUrlString = self.currentOperationCell.videoModel.share_url;
    UIImage *shareImage = self.currentOperationCell.videoShot.image;
    if ( type == EVLiveShareSinaWeiBoButton )
    {
        shareImage = nil;
    }
    [[EVShareManager shareInstance] shareContentWithPlatform:type shareType:ShareTypeNewsWeb titleReplace:nickName descriptionReplaceName:videoTitle descriptionReplaceId:nil URLString:shareUrlString image:shareImage outImage:nil];
}

#pragma mark - event response

- (void)backToTop
{
    [UIView animateWithDuration:0.3f animations:^{
        self.tableView.contentOffset = CGPointMake(0, 1);
    }];
}


#pragma mark - private methods
- (void)loadTextLiveData:(EVUserModel *)userModel
{
    WEAK(self)
    [self.engine GETCreateTextLiveUserid:userModel.name nickName:userModel.nickname easemobid:userModel.name success:^(NSDictionary *retinfo) {
        EVLog(@"LIVETEXT--------- %@",retinfo);
        dispatch_async(dispatch_get_main_queue(), ^{
            EVTextLiveModel *textLiveModel = [EVTextLiveModel objectWithDictionary:retinfo[@"retinfo"][@"data"]];
            [weakself pushLiveImageVCModel:textLiveModel userModel:userModel];
        });
    } error:^(NSError *error) {
        [EVProgressHUD showMessage:@"创建失败"];
    }];
}


- (void)loadIsHaveTextLive
{
    [self.engine GETIsHaveTextLiveOwnerid:[EVLoginInfo localObject].name streamid:nil success:^(NSDictionary *retinfo) {
        
    } error:^(NSError *error) {
        
    }];
}

- (void)pushLiveImageVCModel:(EVTextLiveModel *)model userModel:(EVUserModel *)usermodel
{
    EVHVWatchTextViewController *watchImageVC = [[EVHVWatchTextViewController alloc] init];
    
    EVWatchVideoInfo *watchVideoInfo = [[EVWatchVideoInfo alloc] init];
    watchVideoInfo.liveID = model.streamid;
    watchVideoInfo.name = model.name;
    watchVideoInfo.viewcount = model.viewcount;
    watchVideoInfo.nickname = usermodel.nickname;
    watchImageVC.watchVideoInfo = watchVideoInfo;
    watchImageVC.liveVideoInfo = watchVideoInfo;
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:watchImageVC];
    [self presentViewController:navigationVC animated:YES completion:nil];
}
- (void)setUI
{
    self.title = kE_GlobalZH(@"我的直播");
   
    EVUserModel *WatchVideoInfo = [[EVUserModel alloc] init];
    WatchVideoInfo.nickname = [EVLoginInfo localObject].nickname;
    WatchVideoInfo.name = [EVLoginInfo localObject].imuser;
    self.hvCenterLiveView.userModel = WatchVideoInfo;
    [self.view addSubview:self.hvCenterLiveView];
    WEAK(self)
    _hvCenterLiveView.textLiveBlock = ^ (EVUserModel *watchVideoInfo) {
        EVLog(@"图文直播间");
        [weakself loadTextLiveData:watchVideoInfo];
    };
    _hvCenterLiveView.videoBlock = ^ (EVWatchVideoInfo *videoModel) {
        EVHVWatchViewController *watchViewVC = [[EVHVWatchViewController alloc] init];
        watchViewVC.watchVideoInfo = videoModel;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:watchViewVC];
        [weakself presentViewController:nav animated:YES completion:nil];
    };
    
}

- (void)addVipUI
{
    EVNullDataView *nullDataView = [[EVNullDataView alloc] init];
    [self.view addSubview:nullDataView];
    self.nullDataView = nullDataView;
    [nullDataView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    nullDataView.topImage = [UIImage imageNamed:@"ic_cry"];
    nullDataView.title = @"您还不是主播噢";
    nullDataView.buttonTitle = @"成为主播";
    [nullDataView addButtonTarget:self action:@selector(nullDataClick) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)nullDataClick
{
    [EVProgressHUD showError:@"暂未实现 敬请期待"];
}

- (void)liveDataClick
{
    [EVProgressHUD showError:@"暂未实现 敬请期待"];
}

//上传封面
- (void)uploadImage:(UIImage *)image ForCell:(EVMyVideoTableViewCell *)cell
{
    if(![EVBaseToolManager userHasLoginLogin])
    {
        return;
    }
    WEAK(self)
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    NSString *fileName = [NSString stringWithFormat:@"file"];
    postParams[kFile] = fileName;
    [self.engine upLoadVideoThumbWithiImage:image vid:cell.videoModel.vid fileparams:postParams success:^(NSDictionary *dict) {
        [EVProgressHUD showSuccess:@"更改成功"];
        NSIndexPath *indexPath = [weakself.tableView indexPathForCell:cell];
        NSString *newVideoShotURL  = [NSString stringWithFormat:@"%@",dict[@"retinfo"][@"videologo"]];
        cell.videoModel.thumb = [newVideoShotURL copy];
        
        if (indexPath && indexPath.row < self.videos.count)
        {
            [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } sessionExpire:^{
        EVRelogin(self);
    }];
}

- (void)videoTableViewButton:(UIButton *)button videoCell:(EVMyVideoTableViewCell *)videoCell
{
    EVLog(@"更改权限");
    self.currentOperationCell = videoCell;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"修改标题", @"修改封面",@"分享",@"删除",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.tag = EVActionSheetTypeAll;
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case EVActionSheetTypeAll:
            switch (buttonIndex) {
                case 0:
                {
                    EVLog(@"标题修改");
                    [self modifyVideoTitle];
                }
                    break;
                case 1:
                {
                    EVLog(@"封面修改");
                    [self motifyVideoCover];
                }
                
                    break;
                case 2:
                {
                    EVLog(@"分享");
                    [self shareVideo];
                }
                    break;
                case 3:
                {
                     EVLog(@"删除");
                    [self deleteVideo];
                }
                    
                    break;
                default:
                    break;
            }
            break;
        case EVActionSheetTypePhoto:
        {
            switch (buttonIndex) {
                case 0:
                {
                    [EVStreamer requestCameraAuthedUserAuthed:^{
                        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        [self.navigationController presentViewController:self.picker animated:YES completion:nil];
                    } userDeny:nil];
                }
                    break;
                case 1:
                {
                    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self.navigationController presentViewController:self.picker animated:YES completion:nil];
                    
                }
                    
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case EVActionSheetTypeDelete:
        {
            if (buttonIndex == 0) {
                if (buttonIndex == 0)
                {
                   WEAK(self)
                    [self.engine GETAppdevRemoveVideoWith:self.currentOperationCell.videoModel.vid start:^{
                         [EVProgressHUD showMessage:@"正在删除，请稍侯！" toView:weakself.view];
                    } fail:^(NSError *error) {
                        NSString *errorStr = [error errorInfoWithPlacehold:@"对此视频操作失败"];
                        [EVProgressHUD hideHUDForView:weakself.view];
                        [EVProgressHUD showError:errorStr toView:self.view];
                    } success:^{
                        [EVProgressHUD hideHUDForView:weakself.view];
                        [weakself.videos removeObject:weakself.currentOperationCell.videoModel];
                        [weakself.tableView reloadData];
                    } sessionExpire:^{
                        
                    }];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:     // cancel changing
        {
            self.cellVideoTitle = nil;
            
            break;
        }
            
        case 1:     // confirm changing
        {
            UITextField *textField = [alertView textFieldAtIndex:0];
            if ( [textField.text numOfWordWithLimit:20] > 20 )
            {
                [EVProgressHUD showError:@"不能超过20个字符！"];
                return;
            }
            self.cellVideoTitle = textField.text;
            
            // 更新视频标题
            [self updateVideoTitle];
            
            break;
        }
    }
}



#pragma mark - UIImagePickerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image =  [info objectForKey:UIImagePickerControllerOriginalImage];
    //    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    if ( image == nil )
    {
        [EVProgressHUD showError:@"请检查该图片是否存在本机相册中"];
        return;
    }
    
    _imageCropperViewController = [[UzysImageCropperViewController alloc] initWithImage:image andframeSize:_picker.view.frame.size andcropSize:CGSizeMake(1280, 720)];
    _imageCropperViewController.delegate = self;
    [_picker pushViewController:_imageCropperViewController animated:YES];
    [_picker setNavigationBarHidden:YES];
}


- (void)modifyVideoTitle
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请输入标题"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    alert.delegate = self;
    self.cellVideoTitle = [self.currentOperationCell.videoModel.title mutableCopy];
    
    textField.text = self.cellVideoTitle;
    
    [alert show];
}

- (void)motifyVideoCover
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"相册",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.tag = EVActionSheetTypePhoto;
    [actionSheet showInView:self.view];
}

- (void)shareVideo
{
    if (!self.shareViewContainView) {
        EVLiveShareView *shareView = [[EVLiveShareView alloc] initWithParentView:self.view];
        shareView.delegate = self;
        [self.view addSubview:shareView];
        self.shareViewContainView = shareView;
    }
    
    [self.shareViewContainView show];
}

- (void)deleteVideo
{
    UIActionSheet *confirmMenu = [[UIActionSheet alloc] initWithTitle:@"确定要删除这个视频吗，亲？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    confirmMenu.tag = EVActionSheetTypeDelete;
    [confirmMenu showInView:self.view];
}



- (void)updateVideoTitle
{
    WEAK(self)
    [self.engine GETVideosettitleWithVid:self.currentOperationCell.videoModel.vid title:self.cellVideoTitle start:^{
        
    } fail:^(NSError *error) {
        [EVProgressHUD showError:@"修改错误"];
    } success:^{
        NSIndexPath *indexPath = [self.tableView indexPathForCell:weakself.currentOperationCell];
        weakself.currentOperationCell.videoModel.title = weakself.cellVideoTitle;
        
        if (indexPath && indexPath.row < self.videos.count)
        {
            [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        [EVProgressHUD showSuccess:@"修改成功"];
    } sessionExpire:^{
        EVRelogin(self);
    }];
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
        [EVProgressHUD hideHUDForView:weakself.view];
        
        if (start == 0)
        {
            [weakself.videos removeAllObjects];
        }
        [weakself.videos addObjectsFromArray:videos];
        [weakself.tableView reloadData];
        [weakself.tableView endHeaderRefreshing];
        [weakself.tableView endFooterRefreshing];
        
        if ( weakself.videos.count )
        {
            [weakself.tableView showFooter];
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
        
        if (weakself.videos.count <= 0) {
            if (self.userModel.vip == 1) {
                self.tableView.hidden = YES;
                self.liveDataView.hidden = NO;
                self.nullDataView.hidden = YES;
            }else {
                self.tableView.hidden = YES;
                self.liveDataView.hidden = YES;
                self.nullDataView.hidden = NO;
            }
        }else {
            self.tableView.hidden = NO;
            self.liveDataView.hidden = YES;
            self.nullDataView.hidden = YES;
        }
        
    } essionExpire:^{
        [weakself.tableView endHeaderRefreshing];
        [weakself.tableView endFooterRefreshing];
        EVRelogin(weakself);
    }];
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

- (void)setUserModel:(EVUserModel *)userModel
{
    _userModel = userModel;
    if (userModel.vip == 1) {
        
        self.nullDataView.hidden = YES;
        self.liveDataView.hidden = NO;
    }else {
        self.nullDataView.hidden = NO;
        self.liveDataView.hidden = YES;
    }
}

- (EVHVCenterLiveView *)hvCenterLiveView
{
    if (_hvCenterLiveView == nil) {
        _hvCenterLiveView = [[EVHVCenterLiveView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:(UITableViewStyleGrouped)];
        _hvCenterLiveView.backgroundColor = [UIColor evBackgroundColor];
    }
    return _hvCenterLiveView;
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
