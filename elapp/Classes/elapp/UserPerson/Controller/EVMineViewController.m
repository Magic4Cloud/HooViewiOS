//
//  EVMineViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//
 //
//  EVMineViewController


#import "EVMineViewController.h"
#import "EVFansOrFocusesTableViewController.h"
#import "EVMyVideoTableViewController.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVUserModel.h"
#import "EVUserSettingViewController.h"
#import "EVLoginInfo.h"
#import "EVAuthSettingViewController.h"
#import "EVHeaderView.h"
#import "EVProfileControl.h"
#import "EVSettingItem.h"
#import "EVProfileHeaderView.h"
#import "EVMyEarningsCtrl.h"
#import "EVSettingCollectionViewCell.h"
#import "EVYunBiViewController.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVUserAsset.h"
#import "UIViewController+Extension.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import <PureLayout.h>
#import "EVMineBackgroundView.h"
#import "EVLoginViewController.h"
#import "EVHVUserSettingController.h"
#import "EVLiveViewController.h"
#import "EVHVPrePareController.h"
#import "EVHVLiveViewController.h"
#import "EVNotifyListViewController.h"
#import "EVBaseToolManager+EVMessageAPI.h"
#import "EVNotifyItem.h"
#import "EVMyVideoTableViewController.h"
#import "EVFeedbackTableViewController.h"
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import "NSString+Extension.h"
#import "EVHVLiveView.h"
#import "EVHVBiViewController.h"
#import "EVNewsCollectViewController.h"
#import "EVHVHistoryViewController.h"
#import "EVRelationWith3rdAccoutModel.h"
#import "SegmentSuperViewController.h"


#define ProfileCellID @"profileCell"
#define backgroudImageH  320.0f //267.0f
#define tableViewMinContentOffset -80.0f
#define KThisTimeScore @"thisTimeCurrentScore"
#define kBeyondTop 28  //  顶部图片超出屏幕之外的高度

static const NSString *const SettingCellID = @"settingCell";


@interface EVMineViewController ()<EVProfileDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,EVYiBiViewControllerDelegate,EVMineBackgroundViewDelegate>

@property (strong, nonatomic) EVBaseToolManager *engine;
@property (strong, nonatomic) EVUserModel *userModel;
@property (assign, nonatomic) BOOL isSendingSign;               /**< 是否正在发送签到请求 */
@property ( strong, nonatomic ) NSArray *dataArray;             /**< 数据源 */
@property ( strong, nonatomic ) UIImage *placeholderImage;      /**< 头部图片占位图 */
@property ( strong, nonatomic ) EVUserAsset *asset;
@property (nonatomic, strong) EVMineBackgroundView *mineBgView;
@property ( strong, nonatomic ) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, weak) UIButton *personalButton;
@property (nonatomic, weak) UIButton *rightButton;

@property (nonatomic, strong) NSMutableArray *msgMessages;


@property (nonatomic, strong) YWFeedbackKit *feedbackKit;

@property (nonatomic, weak) EVHVLiveView *hvLiveView;


@property (nonatomic, weak) NSLayoutConstraint *liveViewWid;
@property (nonatomic, weak) NSLayoutConstraint *liveViewHig;


@end

@implementation EVMineViewController
//lock vertical
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self addLeftBarButtonItem];
    [self addRightBarButton];
    [self setUpView];
    [self setUpData];
    [self loadMsgData];
 
    [EVNotificationCenter addObserver:self selector:@selector(newUserRegisterSuccess) name:@"newUserRefusterSuccess" object:nil];
    [EVNotificationCenter addObserver:self selector:@selector(actionOfLogout:) name:NotifyOfLogout object:nil];
    [EVNotificationCenter addObserver:self selector:@selector(actionOfLogin:) name:NotifyOfLogin object:nil];
    [EVNotificationCenter addObserver:self selector:@selector(userLogoutSuccess) name:@"userLogoutSuccess" object:nil];
    [EVNotificationCenter addObserver:self selector:@selector(modifyUserInfoSuccess) name:@"modifyUserInfoSuccess" object:nil];
    [EVNotificationCenter addObserver:self selector:@selector(updateAuth:) name:EVUpdateAuthStatusNotification object:nil];
}

- (void)updateAuth:(NSNotification *)notify {
    NSString *obj = notify.object;
    NSDictionary *userInfo = notify.userInfo;
    
    EVRelationWith3rdAccoutModel *currentModel;
    for (EVRelationWith3rdAccoutModel *model in self.userModel.auth) {
        if ([model.type isEqualToString:obj]) {
            currentModel = model;
        }
    }
    
    if (currentModel) {
        currentModel.token = userInfo[@"accessToken"];
    }
    else {
        NSMutableArray *tempArray = @[].mutableCopy;
        [tempArray addObjectsFromArray:self.userModel.auth];
        currentModel = [EVRelationWith3rdAccoutModel new];
        currentModel.token = userInfo[@"accessToken"];
        currentModel.type = obj;
        [tempArray addObject:currentModel];
        self.userModel.auth = tempArray.copy;
    }
}

- (void)modifyUserInfoSuccess
{
    [self setUpData];
}
- (void)actionOfLogout:(NSNotification *)notify {
    self.mineBgView.userModel = nil;
    self.mineBgView.isSession = NO;
}
- (void)actionOfLogin:(NSNotification *)notify {
    [self setUpData];
}

- (void)newUserRegisterSuccess
{
    self.hvLiveView.hidden = NO;
    [self setUpData];
    [self loadMsgData];
}

- (void)userLogoutSuccess
{
    self.hvLiveView.hidden = YES;
    self.mineBgView.ecoin = 0;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[EVLoginInfo localObject].sessionid isEqualToString:@""] || [EVLoginInfo localObject].sessionid == nil || [EVLoginInfo localObject].vip == 0) {
        self.hvLiveView.hidden = YES;
    }else {
        self.hvLiveView.hidden = NO;
    }
    [self loadData];
    [self setUpData];
    if ([EVLoginInfo localObject].vip) {
//        [self loadTagsData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc{
    [_engine cancelAllOperation];
    [EVNotificationCenter removeObserver:self];
    EVLog(@"-------mine died!------%@--", self);
    [self hideCoverImageView];
    _engine = nil;
    _userModel = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setUI
- (void)setUpView
{
    self.mineBgView = [[EVMineBackgroundView alloc] init];
    [self.view addSubview:self.mineBgView];
    self.mineBgView.delegate = self;
    self.mineBgView.backgroundColor = [UIColor evBackgroundColor];
    [self.mineBgView setFrame:CGRectMake(0, 1, ScreenWidth, ScreenHeight)];
    
    
   
//    EVHVLiveView *liveButton = [[EVHVLiveView alloc] init];
//    [self.view addSubview:liveButton];
//    self.hvLiveView = liveButton;
//    [liveButton setBackgroundColor:[UIColor clearColor]];
//    liveButton.buttonBlock = ^(EVLiveButtonType type, UIButton *btn) {
//        if (btn.tag == EVLiveButtonTypeLive) {
//            if (btn.selected == YES) {
//                self.liveViewWid.constant = 108;
//                self.liveViewHig.constant = 108;
//            }else {
//                self.liveViewWid.constant = 44;
//                self.liveViewHig.constant = 44;
//            }
//        }
//        
//        if (type == EVLiveButtonTypeVideo) {
//            [self liveButtonClick];
//            
//        }else if (type == EVLiveButtonTypePic ) {
//            
//            [EVProgressHUD showError:@"暂未实现 敬请期待"];
//        }
//    };
//    [liveButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:54];
//    self.liveViewWid =    [liveButton autoSetDimension:ALDimensionWidth toSize:44];
//    self.liveViewHig =   [liveButton autoSetDimension:ALDimensionHeight toSize:44];
//    [liveButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
//    
//    if ([[EVLoginInfo localObject].sessionid isEqualToString:@""] || [EVLoginInfo localObject].sessionid == nil || [EVLoginInfo localObject].vip == 0) {
//        self.hvLiveView.hidden = YES;
//    }else {
//        self.hvLiveView.hidden = NO;
//    }
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
#pragma mark - backGroundviewdelegate

- (void)didButtonClickType:(UIMineClickButtonType)type
{
    NSString *sessionID = [self.engine getSessionIdWithBlock:nil];
    
    if (sessionID == nil || [sessionID isEqualToString:@""]) {
        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
        
        [self presentViewController:navighaVC animated:YES completion:nil];
    }else {
        switch (type) {
            case UIMineClickButtonTypeHeadImage:
                
                break;
            case UIMineClickButtonTypeRemindMsg:
            {
//                EVNotifyItem *notifyItem = [self.msgMessages objectAtIndex:0];
                //  小秘书
                EVNotifyListViewController *notiflast = [[EVNotifyListViewController alloc]init];
               
                notiflast.hidesBottomBarWhenPushed = YES;
                //                notiflast.notiItem = notifyItem;
                [self.navigationController pushViewController:notiflast animated:YES];
            }
                break;
                
            case UIMineClickButtonTypeMyLive:
            {
                EVFansOrFocusesTableViewController *fansVC = [[EVFansOrFocusesTableViewController alloc] init];
                fansVC.type = FANS;
                [self.navigationController pushViewController:fansVC animated:YES];
            }
                break;
                
            case UIMineClickButtonTypeMyNews:
                
            {
                EVFansOrFocusesTableViewController *fansVC = [[EVFansOrFocusesTableViewController alloc] init];
                fansVC.type = FOCUSES;
                [self.navigationController pushViewController:fansVC animated:YES];
            }
                break;
                
            case UIMineClickButtonTypeEditMsg:
            {
                [self editBtnClick];
              
            }
                break;
            case UIMineClickButtonTypeMyCoin:
            {
                EVLog(@"我的余额");
                EVHVBiViewController *hvBiVC = [[EVHVBiViewController alloc] init];
                hvBiVC.asset = self.asset;
//                hvBiVC.delegate = self;
                [self.navigationController pushViewController:hvBiVC animated:YES];
                
//                EVYunBiViewController *yibiVC = [[EVYunBiViewController alloc] init];
//                yibiVC.asset = self.asset;
//                yibiVC.delegate = self;
//                [self.navigationController pushViewController:yibiVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    
}


- (void)editBtnClick
{
  
    if (![EVLoginInfo hasLogged]) {
        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
        [self presentViewController:navighaVC animated:YES completion:nil];
        return;
    }
    EVLoginInfo *userInfo = [[EVLoginInfo alloc] init];
    userInfo.name = self.userModel.name;
    userInfo.nickname = self.userModel.nickname;
    userInfo.logourl = self.userModel.logourl;
    userInfo.signature = self.userModel.signature;
    userInfo.birthday = self.userModel.birthday;
    userInfo.authtype = self.userModel.authtype;
    userInfo.gender = self.userModel.gender;
    userInfo.auth = self.userModel.auth;
    userInfo.location = self.userModel.location;
    userInfo.credentials = self.userModel.credentials;
    
    
    EVUserSettingViewController *reeditUserInfoVC = [EVUserSettingViewController userSettingViewController];
    reeditUserInfoVC.isReedit = YES;
    reeditUserInfoVC.title = kEdit_user_info;
    reeditUserInfoVC.userInfo = userInfo;
    reeditUserInfoVC.tagsAry = self.userModel.tags;
    [self.navigationController pushViewController:reeditUserInfoVC animated:YES];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sessionID = [self.engine getSessionIdWithBlock:nil];
    
    if (sessionID == nil || [sessionID isEqualToString:@""]) {
        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
        [self presentViewController:navighaVC animated:YES completion:nil];
    }else{
        if (indexPath.section == 1) {
            switch (indexPath.row) {
                case 0:
                {
                    EVMyVideoTableViewController *myVideoVC = [[EVMyVideoTableViewController alloc] init];
                    myVideoVC.userModel = self.userModel;
                    [self.navigationController pushViewController:myVideoVC animated:YES];
                }
                    break;
                case 1:
                {
                    [EVProgressHUD showMessage:@"暂未实现 敬请期待"];
                }
                    
                    break;
                case 2:
                {
                    EVLog(@"我的收藏");
//                    [EVProgressHUD showError:@"暂未实现 敬请期待"];
                    EVNewsCollectViewController *newsCollectVC = [[EVNewsCollectViewController alloc] init];
                    [self.navigationController pushViewController:newsCollectVC animated:YES];
                }
                    
                    break;
                case 3:
                {
                    EVLog(@"阅读历史");
                    EVHVHistoryViewController *historyVC = [[EVHVHistoryViewController alloc] init];
                    [self.navigationController pushViewController:historyVC animated:YES];
                }
                default:
                    break;
            }
        }else if (indexPath.section == 2) {
            EVLog(@"意见反馈");
            [self gotoFeedbackPage];
            
        }else {
            return;
        }
    }
    
}


- (void)gotoFeedbackPage
{
    
    self.feedbackKit = [[YWFeedbackKit alloc]initWithAppKey:ALI_FEEDBACK_APP_KEY];
    // 提取手机号
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    
    self.feedbackKit.customUIPlist = @{@"avatar":loginInfo.logourl};
    NSMutableDictionary *user_new = [NSMutableDictionary dictionary];
    
    if ( loginInfo.phone && ![loginInfo.phone isEqualToString:@""] )
    {
        self.feedbackKit.contactInfo = loginInfo.phone;
        [user_new setValue:loginInfo.phone forKey:@"phone"];
    }
    if (loginInfo.birthday && ![loginInfo.birthday isEqualToString:@""]) {
        NSString *age = [NSString ageFromDateStr:loginInfo.birthday];
        [user_new setValue:age forKey:@"age"];
    }
    
    if (loginInfo.name) {
        [user_new setValue:loginInfo.name forKey:@"name"];
    }
    if (loginInfo.nickname) {
        [user_new setValue:loginInfo.nickname forKey:@"nickname"];
    }
    if (loginInfo.gender) {
        [user_new setValue:loginInfo.gender forKey:@"gender"];
    }
    self.feedbackKit.extInfo = user_new;
    WEAK(self)
    [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWLightFeedbackViewController *viewController, NSError *error) {
        viewController.title = kE_GlobalZH(@"opinion_feedback");
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:nav animated:YES completion:nil];
        
        viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:weakself action:@selector(actionQuitFeedback)];
        
    }];
    
}

- (void)actionQuitFeedback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 280 + EVProfileHeaderViewRoomHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 20);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    EVProfileHeaderView * headerView;
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
//        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SettingHeader" forIndexPath:indexPath];
//        headerView.userModel = self.tableHeaderView.userModel;
//        headerView.delegate = self;
//        headerView.style = self.tableHeaderView.style;
//        headerView.expectedHeight = self.tableHeaderView.expectedHeight;
    } else {
        UICollectionReusableView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SettingFooter" forIndexPath:indexPath];
        return footerView;
    }
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth, 60);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVSettingCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:(NSString *)SettingCellID forIndexPath:indexPath];
    EVSettingItem *item = self.dataArray[indexPath.row];
    cell.upImage.image = [UIImage imageNamed:item.iconName];
    cell.downLabel.text = item.title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.userModel)
    {
        [EVProgressHUD showError:kE_GlobalZH(@"loading_data_please_trial") toView:self.view];
        return;
    }
    
    EVSettingItem *item = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([item.title isEqualToString:kE_GlobalZH(@"me_earnings")])
    {
        EVMyEarningsCtrl *myEarnVC = [[EVMyEarningsCtrl alloc] init];
        [self.navigationController pushViewController:myEarnVC animated:YES];
    }

    if ([item.title isEqualToString:kE_GlobalZH(@"ecoin_recharge")])
    {
        EVYunBiViewController *yibiVC = [[EVYunBiViewController alloc] init];
        yibiVC.asset = self.asset;
        yibiVC.delegate = self;
        [self.navigationController pushViewController:yibiVC animated:YES];
    }
    
    if ([item.title isEqualToString:kE_GlobalZH(@"me_setting")])
    {
        EVAuthSettingViewController *authSettingVC = [[EVAuthSettingViewController alloc] init];
        authSettingVC.userModel = self.userModel;
        [self.navigationController pushViewController:authSettingVC animated:YES];
    }

}


- (void)videoScan
{
    EVMyVideoTableViewController *myVideoTVC = [[EVMyVideoTableViewController alloc] init];
    [self.navigationController pushViewController:myVideoTVC animated:YES];
}

- (void)fanScan
{
    [self pushViewControllerWithControllerType:FANS];
}

- (void)focusScan
{
    [self pushViewControllerWithControllerType:FOCUSES];
}

- (void)changeBackgroundImage:(UIImage *)image
{
    self.placeholderImage = image;

}

- (void)changeBackgroundPlaceholderImage:(UIImage *)placeholderImage bgURL:(NSString *)url
{
    if ( self.placeholderImage == nil )
    {
        self.placeholderImage = placeholderImage;
    }
}

#pragma mark - profile cell delegate

// 点击底部四个control
- (void)clickProfileControl:(EVProfileControl *)control
{
    if ( [control.title isEqualToString:CCProfileControlTitleVideo] )
    {
        [self videoScan];
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
//    [self biggerAvatar:image];
}
- (void)clickEditDataButton:(UIButton *)remarkButton {
    EVLog(@"编辑资料");
    [self editBtnClick];
}

#pragma mark - private methods

- (void)getUserInfoFromDB
{
    NSString *name = [EVLoginInfo localObject].name;
    if ( !self.userModel && name && ![name isEqualToString:@""]) {
        __weak typeof(self) weakself = self;
        [EVUserModel getUserInfoModelWithName:name complete:^(EVUserModel *model) {
            if ( model ) {
                weakself.userModel = model;
//                weakself.tableHeaderView.userModel = model;
//                [weakself.tableView reloadData];
            }
        }];
    }
}


- (void)setUpData
{
    NSString *sessionID = [self.engine getSessionIdWithBlock:nil];
    if (sessionID) {
        self.mineBgView.isSession = YES;
    }else {
        self.mineBgView.isSession = NO;
    }
    __weak typeof(self) weakSelf = self;
    [self.engine GETUserInfoWithUname:nil orImuser:nil start:nil fail:^(NSError *error) {
         NSString *errorStr = [error errorInfoWithPlacehold:kE_GlobalZH(@"user_data_fail")];
         if (![errorStr isEqualToString:@""]) {
             // 默认从本地数据库中取数据
             [self getUserInfoFromDB];
         }
         [EVProgressHUD showError:errorStr toView:weakSelf.view];
         [EVProgressHUD hideHUDForView:weakSelf.view];
     } success:^(NSDictionary *modelDict) {
         EVLog(@"%@",modelDict);
         if ( modelDict && [modelDict allKeys].count > 0 ) {
             EVUserModel *model = [EVUserModel objectWithDictionary:modelDict];
             weakSelf.mineBgView.userModel = model;
             weakSelf.userModel = model;
             weakSelf.mineBgView.isSession = model.sessionid;
             [weakSelf.userModel updateToLocalCacheComplete:nil];
             weakSelf.mineBgView.dataArray = model.tags.mutableCopy;
             dispatch_async(dispatch_get_global_queue(0, 0), ^ {
                                EVLoginInfo *loginInfo = [EVLoginInfo localObject];
                                loginInfo.name = weakSelf.userModel.name;
                                loginInfo.nickname = weakSelf.userModel.nickname;
                                loginInfo.logourl = modelDict[kLogourl];
                                loginInfo.location = modelDict[kLocation];
                                loginInfo.auth = [NSArray arrayWithArray:model.auth];
                                loginInfo.vip = [modelDict[@"vip"] integerValue];
                                [loginInfo synchronized];
                            });
             
             if ([model.sessionid isEqualToString:@""] ||model.sessionid == nil || model.vip == 0) {
                 self.hvLiveView.hidden = YES;
             }else {
                 self.hvLiveView.hidden = NO;
             }
         }
        
     } sessionExpire:^ {
         EVRelogin(weakSelf);
     }];
}

- (void)loadTagsData
{
//    [self.engine GETUserTagsListfail:^(NSError *error) {
//        
//    } success:^(NSDictionary *info) {
//        NSArray *tagArray = info[@"tags"];
//        NSMutableArray *titleAry = [NSMutableArray array];
//        for (NSDictionary *dict in tagArray) {
//            [titleAry addObject:dict[@"tagname"]];
//        }
//       
////        EVUserSettingCell *firstGroupCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:1]];
////        
////        firstGroupCell.userTagsView.dataArray = titleAry;
//        
//    }];
}
//用户资产
- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    
    [self.engine GETUserAssetsWithStart:nil fail:^(NSError *error) {
         
     } success:^(NSDictionary *videoInfo) {
         self.asset = [EVUserAsset objectWithDictionary:videoInfo];
         weakSelf.mineBgView.ecoin = videoInfo[@"ecoin"];
     } sessionExpire:^{
         
     }];
}

- (void)loadMsgData
{
    //发送请求
    __weak typeof(self) weakSelf = self;
    [self.engine GETMessagegrouplistStart:^{
    } fail:^(NSError *error) {
        if ( error.userInfo[kCustomErrorKey] ){
        } else {
            EVLog(@"更新未读信息失败");
        }
//        [weakSelf calculateUnread];
//        [weakSelf.tableView reloadData];
    } success:^(NSDictionary *messageData) {
        id groups = messageData[@"groups"];
        if ( [groups isKindOfClass:[NSArray class]] )
        {
            NSArray *messageGroupsTemp = (NSArray *)groups;
            NSArray *messageGroups = [EVNotifyItem objectWithDictionaryArray:messageGroupsTemp];
            for (int i = 0; i < 2; i++) {
                EVNotifyItem *item = messageGroups[i];
//                if (i == 1) {
//                    [weakSelf.msgMessages addObject:item];
//                }
//                else {
//                    [weakSelf.msgMessages replaceObjectAtIndex:1 withObject:item];
//                }
//                [weakSelf calculateUnread];
//                [weakSelf.tableView reloadData];
            }
            
            
        }
    } sessionExpired:^{
        EVRelogin(weakSelf);
    } ];
}


- (void)pushViewControllerWithControllerType:(controllerType)type
{
    EVFansOrFocusesTableViewController *fansOrFocusesTVC = [[EVFansOrFocusesTableViewController alloc] init];
    fansOrFocusesTVC.type = type;
    [self.navigationController pushViewController:fansOrFocusesTVC animated:YES];
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

- (void)buySuccessWithEcoin:(NSInteger)ecoin
{
    [self loadData];
}

- (NSArray *)dataArray
{
    if ( _dataArray == nil )
    {
        NSArray * iconArray = [NSArray arrayWithObjects:@"personal_icon_recharge",@"personal_icon_money",@"personal_icon_setting", nil];
        NSArray * titleArray = [NSArray arrayWithObjects:kE_GlobalZH(@"ecoin_recharge"),kE_GlobalZH(@"me_earnings"),kE_GlobalZH(@"me_setting"), nil];
        NSMutableArray * dataArray = [[NSMutableArray alloc] init];
        for ( int i = 0; i < iconArray.count; i++ )
        {
            NSString * imageStr = iconArray[i];
            NSString * title = titleArray[i];
            EVSettingItem *settingItem = [EVSettingItem itemWithIconName:imageStr title:title subTitle:nil type:EVSettingItemTypeDefault];
            [dataArray addObject:settingItem];
        }
        
        self.dataArray = [NSArray arrayWithArray:dataArray];
    }
    return _dataArray;
}


- (void)addLeftBarButtonItem
{
    
    if (self.leftBarButtonItem == nil)
    {
        UIButton *personalButton = [[UIButton alloc] init];
        personalButton.frame = CGRectMake(10.f, 10.f, 100.f, 30.f);
        [personalButton setImage:[UIImage imageNamed:@"huoyan_logo"] forState:(UIControlStateNormal)];
        personalButton.userInteractionEnabled = NO;
        self.personalButton = personalButton;
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:personalButton];
        [personalButton setTitle:@" 个人中心" forState:(UIControlStateNormal)];
        personalButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [personalButton setTitleColor:[UIColor evMainColor] forState:(UIControlStateNormal)];
        CGFloat offset = 10;
        if ( ScreenWidth <= 375 )
        {
            offset = 6;
        }
        personalButton.contentEdgeInsets = UIEdgeInsetsMake(0, -offset, 0, offset);
        self.leftBarButtonItem = leftBarButtonItem;
    }
    //    [self.personalButton cc_setImageURL:[EVLoginInfo localObject].logourl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar"]];
    self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
}

- (void)addRightBarButton
{
    UIButton *rightButton = [[UIButton alloc] init];
 
    [rightButton setImage:[UIImage imageNamed:@"btn_setting_n"] forState:(UIControlStateNormal)];
    rightButton.frame = CGRectMake(0, 0, rightButton.imageView.image.size.width, rightButton.imageView.image.size.height);
    self.rightButton = rightButton;
    [rightButton addTarget:self action:@selector(rightClick:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
 
}

- (NSMutableArray *)msgMessages
{
    if (!_msgMessages) {
        _msgMessages = [NSMutableArray array];
    }
    return _msgMessages;
}
- (void)rightClick:(UIButton *)btn
{
    if ([EVBaseToolManager userHasLoginLogin]) {
        EVHVUserSettingController *userSettingVC = [[EVHVUserSettingController alloc] init];
        userSettingVC.userModel = self.userModel;
        [self.navigationController pushViewController:userSettingVC animated:YES];
    }else {
        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
        [self presentViewController:navighaVC animated:YES completion:nil];
    }
    
//    UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
//
//    [self presentViewController:navighaVC animated:YES completion:nil];
}
//- (void)setUpNavigationBar
//{
//    self.navationBar = [[EVNavigationBar alloc] init];
//    [self.view addSubview:self.navationBar];
//    [self.navationBar autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
//    [self.navationBar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
//    [self.navationBar autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
//    [self.navationBar autoSetDimension:ALDimensionHeight toSize:64];
//}

@end
