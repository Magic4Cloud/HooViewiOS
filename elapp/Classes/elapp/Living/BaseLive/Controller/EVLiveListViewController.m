//
//  EVLiveListViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/22.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVLiveListViewController.h"
#import "EVTextLiveListController.h"
#import "EVLiveVideoController.h"
#import "EVRecorededVideoListController.h"
#import "EVLiveTopView.h"
#import "EVSearchAllViewController.h"
#import "EVHVLiveView.h"
#import "UIViewController+Extension.h"
#import "EVLoginViewController.h"
#import "EVBaseToolManager.h"
#import "EVLoginInfo.h"
#import <AVFoundation/AVFoundation.h>
#import "EVAlertManager.h"
#import "EVMyTextLiveViewController.h"
#import "EVBaseToolManager+EVLiveAPI.h"

@interface EVLiveListViewController ()<UIScrollViewDelegate,EVLiveTopViewDelegate>

@property (nonatomic, weak) EVLiveTopView *topView;

@property (nonatomic, weak) UIScrollView *backScrollView;


@property (nonatomic, weak) NSLayoutConstraint *liveViewWid;
@property (nonatomic, weak) NSLayoutConstraint *liveViewHig;

@property (nonatomic, weak) EVHVLiveView *hvLiveView;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@end

@implementation EVLiveListViewController


- (instancetype)init {
    if (self = [super init]) {
        
        self.menuViewStyle = WMMenuViewStyleLine;
        float addFont = 0;
        if (ScreenWidth>375) {
            addFont = 1;
        }
        self.titleSizeSelected = 16.0+addFont;
        self.titleSizeNormal = 14.0+addFont;
        
        self.menuHeight = 44;
        self.titleColorSelected = [UIColor evMainColor];
        self.titleColorNormal = [UIColor evTextColorH2];
        self.menuItemWidth = 45;
        self.progressViewWidths = @[@16,@16,@16];
        //        self.progressViewIsNaughty = YES;
        self.titles = @[@"直播",@"图文",@"精品"];
        float margin = 12;
        if (ScreenWidth == 320) {
            margin = 0;
        }
        
        NSNumber * marginNum = [NSNumber numberWithFloat:margin];
        float lastMargin = ScreenWidth - 50-margin*2-45*3;
        NSNumber * number = [NSNumber numberWithFloat:lastMargin];
        self.itemsMargins = @[@50,marginNum,marginNum,number];
        self.menuBGColor = [UIColor whiteColor];
        self.menuViewStyle = WMMenuViewLayoutModeLeft;
    }
    return self;
}

#pragma mark - ♻️Lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if ([[EVLoginInfo localObject].sessionid isEqualToString:@""] || [EVLoginInfo localObject].sessionid == nil || [EVLoginInfo localObject].vip == 0) {
        self.hvLiveView.hidden = YES;
    }else {
        self.hvLiveView.hidden = NO;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self addUpView];
    [EVNotificationCenter addObserver:self selector:@selector(userLogoutSuccess) name:@"userLogoutSuccess" object:nil];
    [EVNotificationCenter addObserver:self selector:@selector(newUserRegisterSuccess) name:@"newUserRefusterSuccess" object:nil];
}

- (void)setupView {
    self.viewFrame = CGRectMake(0, 20, ScreenWidth, ScreenHeight);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(ScreenWidth - 44 -10, 20, 44,44);
    [searchButton setImage:[UIImage imageNamed:@"btn_news_search_n"] forState:(UIControlStateNormal)];
    [searchButton addTarget:self action:@selector(searchClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:searchButton];
    
    UIImageView * icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"huoyan_logo"]];
    icon.frame = CGRectMake(20, 30, 23, 23);
    [self.view addSubview:icon];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            //视频直播
            EVLiveVideoController *liveVideoVC = [[EVLiveVideoController alloc] init];
//            liveVideoVC.view.frame = CGRectMake(0,0, ScreenWidth, EVContentHeight);
            return liveVideoVC;
        }
            break;
        case 1:
        {
            //图文直播
            EVTextLiveListController *liveImageVC = [[EVTextLiveListController alloc] init];
//            liveImageVC.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, EVContentHeight);
            return liveImageVC;
        }
        case 2:
        {
            //精品视频
            EVRecorededVideoListController *recoredVideoVC = [[EVRecorededVideoListController alloc] init];
//            recoredVideoVC.view.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, EVContentHeight);
            return recoredVideoVC;
        }
        
        default:
        {
            return nil;
        }
            break;
    }
    
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}

#pragma mark -👣 Target actions
- (void)searchClick
{
    EVSearchAllViewController *searchVC = [[EVSearchAllViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}



- (void)userLogoutSuccess
{
    [EVNotificationCenter postNotificationName:@"chooseMarketCommit" object:nil];
    self.hvLiveView.hidden = YES;
}

- (void)newUserRegisterSuccess
{
    self.hvLiveView.hidden = NO;
}

- (void)addUpView
{
//    EVLiveTopView *topView = [[EVLiveTopView alloc] init];
//    topView.frame = CGRectMake(0, 0, ScreenWidth, 108);
//    topView.delegate = self;
//    topView.backgroundColor = [UIColor evBackgroundColor];
//    [self.view addSubview:topView];
//    self.topView = topView;
//    
//    UIScrollView *backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 108, ScreenWidth, EVContentHeight)];
//    backScrollView.backgroundColor = [UIColor evBackgroundColor];
//    backScrollView.delegate = self;
//    [self.view addSubview:backScrollView];
//    self.backScrollView = backScrollView;
//    backScrollView.pagingEnabled = YES;
//    backScrollView.showsHorizontalScrollIndicator = NO;
//    backScrollView.contentSize = CGSizeMake(ScreenWidth * 3, EVContentHeight);
//    
//    //视频直播
//    EVLiveVideoController *liveVideoVC = [[EVLiveVideoController alloc] init];
//    [self addChildViewController:liveVideoVC];
//    [backScrollView addSubview:liveVideoVC.view];
//    liveVideoVC.view.frame = CGRectMake(0,0, ScreenWidth, EVContentHeight);
//    
//    //图文直播
//    EVTextLiveListController *liveImageVC = [[EVTextLiveListController alloc] init];
//    [self addChildViewController:liveImageVC];
//    [backScrollView addSubview:liveImageVC.view];
//    liveImageVC.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, EVContentHeight);
//    
//    //精品视频
//    EVRecorededVideoListController *recoredVideoVC = [[EVRecorededVideoListController alloc] init];
//    [self addChildViewController:recoredVideoVC];
//    [backScrollView addSubview:recoredVideoVC.view];
//    recoredVideoVC.view.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, EVContentHeight);
//    
    
    
    EVHVLiveView *liveButton = [[EVHVLiveView alloc] init];
    [self.view addSubview:liveButton];
    self.hvLiveView = liveButton;
    [liveButton setBackgroundColor:[UIColor clearColor]];
    WEAK(self)
    //TODO:开启直播
    liveButton.buttonBlock = ^(EVLiveButtonType type, UIButton *btn) {
       
        if (type == EVLiveButtonTypeLive) {
            if (btn.selected == YES) {
                weakself.liveViewWid.constant = 108;
                weakself.liveViewHig.constant = 108;
            }else {
                weakself.liveViewWid.constant = 44;
                weakself.liveViewHig.constant = 44;
            }
        }
        if (type == EVLiveButtonTypeVideo) {
            NSString *sessionID = [self.baseToolManager getSessionIdWithBlock:nil];
            if (sessionID == nil || [sessionID isEqualToString:@""]) {
                [weakself loginView];
                return;
            }
            [weakself checkAndRequestMicPhoneAndCameraUserAuthed:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself liveButtonClick];
                });
            } userDeny:nil];
          
        }else if (type == EVLiveButtonTypePic ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself loadTextLiveData];
            });
           
           
        }
    };
    [liveButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:54];
    self.liveViewWid =    [liveButton autoSetDimension:ALDimensionWidth toSize:44];
    self.liveViewHig =   [liveButton autoSetDimension:ALDimensionHeight toSize:44];
    [liveButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    
    if ([[EVLoginInfo localObject].sessionid isEqualToString:@""] || [EVLoginInfo localObject].sessionid == nil || [EVLoginInfo localObject].vip == 0) {
        self.hvLiveView.hidden = YES;
    }else {
        self.hvLiveView.hidden = NO;
    }
    
}

- (void)loadTextLiveData
{
    NSString *sessionID = [self.baseToolManager getSessionIdWithBlock:nil];
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    
    WEAK(self)
    if (sessionID == nil || [sessionID isEqualToString:@""]) {
        [weakself loginView];
        return;
    }
    if ([EVTextLiveModel textLiveObject].streamid.length > 0) {
        [self pushLiveImageVCModel:[EVTextLiveModel textLiveObject]];
        return;
    }
    NSString *easemobid = loginInfo.imuser.length <= 0 ? loginInfo.name : loginInfo.imuser;
    [self.baseToolManager GETCreateTextLiveUserid:loginInfo.name nickName:loginInfo.nickname easemobid:easemobid success:^(NSDictionary *retinfo) {
        EVLog(@"LIVETEXT--------- %@",retinfo);
        dispatch_async(dispatch_get_main_queue(), ^{
            EVTextLiveModel *textLiveModel = [EVTextLiveModel objectWithDictionary:retinfo[@"retinfo"][@"data"]];
            [textLiveModel synchronized];
            [weakself pushLiveImageVCModel:textLiveModel];
        });
    } error:^(NSError *error) {
//         [weakself pushLiveImageVCModel:nil];
        [EVProgressHUD showMessage:@"创建失败"];
    }];
}

#pragma mark - 跳转到我的直播间
- (void)pushLiveImageVCModel:(EVTextLiveModel *)model
{
    EVMyTextLiveViewController *myLiveImageVC = [[EVMyTextLiveViewController alloc] init];
    UINavigationController *navigationVc = [[UINavigationController alloc] initWithRootViewController:myLiveImageVC];
    [self presentViewController:navigationVc animated:YES completion:nil];
    myLiveImageVC.textLiveModel = model;
}

- (void)loginView
{
    UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
    
    [self presentViewController:navighaVC animated:YES completion:nil];
}

- (void)liveButtonClick
{
    //    EVHVPrePareController *prePareVC  = [[EVHVPrePareController alloc] init];
    //    [self presentViewController:prePareVC animated:YES completion:nil];
    [self requestNormalLivingPageForceImage:NO allowList:nil];
    
    //    EVHVLiveViewController *hvLiveVC = [[EVHVLiveViewController alloc] init];
    //    [self presentViewController:hvLiveVC animated:YES completion:nil];
    
}


#pragma mark - 开始普通直播
- (void)requestNormalLivingPageForceImage:(BOOL)forceImage
                                allowList:(NSArray *)allowList
{
    
    [self requestNormalLivingPageForceImage:forceImage allowList:allowList audioOnly:NO];
    
}

- (void)requestNormalLivingPageForceImage:(BOOL)forceImage
                                allowList:(NSArray *)allowList
                                audioOnly:(BOOL)audioOnly
{
    
    [self requestNormalLivingPageForceImage:forceImage allowList:allowList audioOnly:audioOnly delegate:self];
}

//- (void)segmentedDidSeletedIndex:(NSInteger)index
//{
//    CGFloat offsetX = index * self.view.frame.size.width;
//    self.backScrollView.contentOffset = CGPointMake(offsetX, 0);
//}

//- (void)didSearchButton
//{
//    EVSearchAllViewController *searchVC = [[EVSearchAllViewController alloc] init];
//    [self.navigationController pushViewController:searchVC animated:YES];
//}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self.topView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
//}
//

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}


#pragma mark - uitil
// 摄像头 和 麦克风授权
- (void)checkAndRequestMicPhoneAndCameraUserAuthed:(void(^)())userAuthed
                                          userDeny:(void(^)())userDeny
{
    [self requestCameraAuthedUserAuthed:^{
        [self requestMicPhoneAuthedUserAuthed:userAuthed userDeny:userDeny];
    } userDeny:userDeny];
}

// 摄像头授权
- (void)requestCameraAuthedUserAuthed:(void(^)())userAuthed
                             userDeny:(void(^)())userDeny
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus cameraAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if ( cameraAuthStatus == AVAuthorizationStatusAuthorized )
    {
        
        if ( userAuthed )
        {
            userAuthed();
        }
        
    }
    else if ( cameraAuthStatus == AVAuthorizationStatusNotDetermined )
    {
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if ( granted )
            {
                if ( userAuthed )
                {
                    userAuthed();
                }
            }
            else
            {
                if ( userDeny )
                {
                    userDeny();
                }
            }
        }];
    }
    else if ( cameraAuthStatus == AVAuthorizationStatusDenied || cameraAuthStatus == AVAuthorizationStatusRestricted )
    {
        if ( [UIDevice currentDevice].systemVersion.floatValue < 8.0 )
        {
            [[EVAlertManager shareInstance] performComfirmTitle:@"提示" message:@"火眼财经请求访问您的摄像机和麦克风,请到设置->隐私->相机 | 麦克风 -> 火眼财经 进行相应的授权" cancelButtonTitle:@"取消" comfirmTitle:@"确定" WithComfirm:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
            } cancel:nil];
        }
        else
        {
            [[EVAlertManager shareInstance] performComfirmTitle:@"提示" message:@"火眼财经请求访问您的摄像头" cancelButtonTitle:@"不允许" comfirmTitle:@"允许" WithComfirm:^{
                BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != nil);
                if (canOpenSettings)
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            } cancel:^{
                if ( userDeny )
                {
                    userDeny();
                }
            }];
        }
    }
}

// 麦克风授权
- (void)requestMicPhoneAuthedUserAuthed:(void(^)())userAuthed
                               userDeny:(void(^)())userDeny
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ( [audioSession respondsToSelector:@selector(recordPermission)] )
    {
        AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
        switch ( permission )
        {
            case AVAudioSessionRecordPermissionGranted:
                
                if ( userAuthed )
                {
                    userAuthed();
                }
                break;
                
            case AVAudioSessionRecordPermissionDenied:
            {
                [[EVAlertManager shareInstance] performComfirmTitle:@"提示" message:@"火眼财经请求访问您的麦克风" cancelButtonTitle:@"不允许" comfirmTitle:@"允许" WithComfirm:^{
                    BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != nil);
                    if (canOpenSettings)
                    {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                } cancel:^{
                    if ( userDeny )
                    {
                        userDeny();
                    }
                }];
            }
                break;
                
            case AVAudioSessionRecordPermissionUndetermined:
            {
                [self askForMicAuthedUserAuthed:userAuthed userDeny:userDeny];
            }
                break;
                
            default:
                break;
        }
    }
    else if ( [[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)] )
    {
        [self askForMicAuthedUserAuthed:userAuthed userDeny:userDeny];
    }
}

/**
 *  使用系统默认的方式请求麦克风授权 只适配 iOS 7 以上的手机
 *
 *  @param userAuthed 用户授权成功
 *  @param userDeny   用户授权拒绝
 */
- (void)askForMicAuthedUserAuthed:(void(^)())userAuthed
                         userDeny:(void(^)())userDeny
{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if ( granted )
        {
            if ( userAuthed )
            {
                userAuthed();
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[EVAlertManager shareInstance] performComfirmTitle:@"提示" message:@"火眼财经请求访问您的麦克风,请到设置->隐私-> 麦克风 -> 火眼财经 进行相应的授权" cancelButtonTitle:@"取消" comfirmTitle:@"确定" WithComfirm:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
                } cancel:nil];
            });
        
            
        }
    }];
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
