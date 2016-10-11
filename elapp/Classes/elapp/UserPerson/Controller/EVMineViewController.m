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
#import "EVLiveShareView.h"
#import "UIViewController+Extension.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"


#define ProfileCellID @"profileCell"
#define backgroudImageH  320.0f //267.0f
#define tableViewMinContentOffset -80.0f
#define KThisTimeScore @"thisTimeCurrentScore"
#define kBeyondTop 28  //  顶部图片超出屏幕之外的高度

static const NSString *const SettingCellID = @"settingCell";


@interface EVMineViewController ()<EVProfileDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,EVYiBiViewControllerDelegate, CCLiveShareViewDelegate>

@property (strong, nonatomic) EVBaseToolManager *engine;
@property (strong, nonatomic) EVUserModel *userModel;
@property (assign, nonatomic) BOOL isSendingSign;               /**< 是否正在发送签到请求 */
@property ( strong, nonatomic ) NSArray *dataArray;             /**< 数据源 */
@property ( strong, nonatomic ) UIImage *placeholderImage;      /**< 头部图片占位图 */
@property ( strong, nonatomic ) EVUserAsset *asset;

@end

@implementation EVMineViewController

#pragma mark - life circle
- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setUpData];
    [self loadData];
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
    CCLog(@"-------mine died!------%@--", self);
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
    [self.tableView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    [self.tableView removeFromSuperview];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.tableHeaderView.delegate = self;
    
    [self.collectionView registerClass:[EVSettingCollectionViewCell class] forCellWithReuseIdentifier:(NSString *)SettingCellID];
    [self.collectionView registerClass:[EVProfileHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SettingHeader"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SettingFooter"];
    
    self.collectionView.backgroundColor = [UIColor evBackgroundColor];
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
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SettingHeader" forIndexPath:indexPath];
        headerView.userModel = self.tableHeaderView.userModel;
        headerView.delegate = self;
        headerView.style = self.tableHeaderView.style;
        headerView.expectedHeight = self.tableHeaderView.expectedHeight;
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
        [CCProgressHUD showError:kE_GlobalZH(@"loading_data_please_trial") toView:self.view];
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


- (void)editBtnClick
{
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
    
    EVUserSettingViewController *reeditUserInfoVC = [EVUserSettingViewController userSettingViewController];
    reeditUserInfoVC.isReedit = YES;
    reeditUserInfoVC.title = kEdit_user_info;
    if (userInfo.name == nil || [userInfo.name isEqualToString:@""]) {
        [CCProgressHUD showError:kE_GlobalZH(@"please_later")];
        return;
    }
    reeditUserInfoVC.userInfo = userInfo;
    [self.navigationController pushViewController:reeditUserInfoVC animated:YES];
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
    [self biggerAvatar:image];
}
- (void)clickEditDataButton:(UIButton *)remarkButton {
    CCLog(@"编辑资料");
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
                weakself.tableHeaderView.userModel = model;
                [weakself.tableView reloadData];
            }
        }];
    }
}


- (void)setUpData
{
    __weak typeof(self) weakSelf = self;
    [self.engine GETUserInfoWithUname:nil orImuser:nil start:nil fail:^(NSError *error) {
         NSString *errorStr = [error errorInfoWithPlacehold:kE_GlobalZH(@"user_data_fail")];
         if (![errorStr isEqualToString:@""]) {
             // 默认从本地数据库中取数据
             [self getUserInfoFromDB];
         }
         [CCProgressHUD showError:errorStr toView:weakSelf.view];
         [CCProgressHUD hideHUDForView:weakSelf.view];
     } success:^(NSDictionary *modelDict) {
         CCLog(@"%@",modelDict);
         if ( modelDict && [modelDict allKeys].count > 0 ) {
             EVUserModel *model = [EVUserModel objectWithDictionary:modelDict];
             weakSelf.userModel = model;
             [weakSelf.userModel updateToLocalCacheComplete:nil];
             weakSelf.tableHeaderView.userModel = model;
             [weakSelf.collectionView reloadData];
             
             
             dispatch_async(dispatch_get_global_queue(0, 0), ^ {
                                EVLoginInfo *loginInfo = [EVLoginInfo localObject];
                                loginInfo.name = weakSelf.userModel.name;
                                loginInfo.nickname = weakSelf.userModel.nickname;
                                loginInfo.invite_url = modelDict[kInvite_url];
                                loginInfo.logourl = modelDict[kLogourl];
                                loginInfo.location = modelDict[kLocation];
                                loginInfo.auth = [NSArray arrayWithArray:model.auth];
                                [loginInfo synchronized];
                            });
         }
     } sessionExpire:^ {
         CCRelogin(weakSelf);
     }];
}

//用户资产
- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    
    
    [self.engine GETUserAssetsWithStart:nil fail:^(NSError *error) {
         
     } success:^(NSDictionary *videoInfo) {
        EVUserAsset *asset = [EVUserAsset objectWithDictionary:videoInfo];
         weakSelf.asset = asset;
     } sessionExpire:^{
         
     }];
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

@end
