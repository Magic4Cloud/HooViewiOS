//
//  EVPersonCenterViewController.m
//  elapp
//
//  Created by 唐超 on 4/17/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVPersonCenterViewController.h"
#import "EVUserSettingViewController.h"
#import "EVHVUserSettingController.h"
#import "EVLoginViewController.h"
#import "EVHVHistoryViewController.h"
#import "EVNewsCollectViewController.h"
#import "EVHVBiViewController.h"
#import "EVNotifyListViewController.h"


#import "EVMineTableViewCell.h"
#import "EVPersonHeadCell.h"

#import "EVBaseToolManager.h"
#import "EVLoginInfo.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"

#import "EVUserModel.h"
@interface EVPersonCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * cellTitlesArray;
    NSArray * cellTitleIconsArray;
}
@property (strong, nonatomic) EVUserModel * userModel;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) EVUserAsset * asset;
@property (strong, nonatomic) EVBaseToolManager *engine;
@end

@implementation EVPersonCenterViewController

#pragma mark - ♻️Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
    
    [self loadPersonalInfor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadAssetData];
}
#pragma mark - 🙄 Private methods
- (void)initData
{
    cellTitlesArray = @[@"我的消息",@"我的余额",@"我的发布",@"我的购买",@"我的收藏",@"历史记录",];
   
    cellTitleIconsArray = @[@"",@"",@"",@"",@"",@""];
}

- (void)getUserInfoFromDB
{
    NSString *name = [EVLoginInfo localObject].name;
    if ( !self.userModel && name && ![name isEqualToString:@""]) {
        __weak typeof(self) weakself = self;
        [EVUserModel getUserInfoModelWithName:name complete:^(EVUserModel *model) {
            if ( model ) {
                weakself.userModel = model;
            }
        }];
    }
}

#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIButton *personalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    personalButton.frame = CGRectMake(10.f, 10.f, 100.f, 30.f);
    [personalButton setImage:[UIImage imageNamed:@"huoyan_logo"] forState:(UIControlStateNormal)];
    personalButton.userInteractionEnabled = NO;
    
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
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_setting_n"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVPersonHeadCell" bundle:nil] forCellReuseIdentifier:@"EVPersonHeadCell"];
}


#pragma mark - 🌐Networks
//用户资产信息
- (void)loadAssetData
{
    [self.engine GETUserAssetsWithStart:nil fail:^(NSError *error) {
        
    } success:^(NSDictionary *videoInfo) {
        self.asset = [EVUserAsset objectWithDictionary:videoInfo];
    } sessionExpire:^{
    }];
}

//用户基本资料
- (void)loadPersonalInfor
{
    __weak typeof(self) weakSelf = self;
    [self.engine GETUserInfoWithUname:nil orImuser:nil start:nil fail:^(NSError *error)
    {
        NSString *errorStr = [error errorInfoWithPlacehold:kE_GlobalZH(@"user_data_fail")];
        if (![errorStr isEqualToString:@""]) {
            // 默认从本地数据库中取数据
            [self getUserInfoFromDB];
        }
        [EVProgressHUD showError:errorStr toView:weakSelf.view];
        [EVProgressHUD hideHUDForView:weakSelf.view];
    } success:^(NSDictionary *modelDict) {
        
        if ( modelDict && [modelDict allKeys].count > 0 ) {
            EVUserModel *model = [EVUserModel objectWithDictionary:modelDict];
            weakSelf.userModel = model;
            
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
        }
    } sessionExpire:^ {
        EVRelogin(weakSelf);
    }];
}
#pragma mark - 📢Notifications

#pragma mark - 🌺 TableView Delegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellTitlesArray.count+1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 145;
    }
    if ([EVLoginInfo hasLogged] || [EVLoginInfo localObject].vip == 1)
    {
        //是大v
    }
    else
    {
        //不是大v
        if (indexPath.row == 3) {
            //没有我的发布
            return 0.01;
        }
    }
    
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        EVPersonHeadCell * headerCell = [tableView dequeueReusableCellWithIdentifier:@"EVPersonHeadCell"];
        if ([EVLoginInfo hasLogged]) {
            headerCell.userModel = self.userModel;
        }
        else
        {
            headerCell.userModel = nil;
        }
        
        return headerCell;
    }
    
    EVMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineCell"];
    if (!cell) {
        cell = [[EVMineTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"mineCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    [cell setCellImage:cellTitleIconsArray[indexPath.row-1] name:cellTitlesArray[indexPath.row-1]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![EVLoginInfo hasLogged]) {
        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
        [self presentViewController:navighaVC animated:YES completion:nil];
        return;
    }
    switch (indexPath.row) {
        case 0:
        {
            //头像
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
            break;
        case 1:
        {
            //我的消息
            EVNotifyListViewController *notiflast = [[EVNotifyListViewController alloc]init];
            notiflast.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:notiflast animated:YES];
        }
            break;
        case 2:
        {
            //我的余额
            EVHVBiViewController *hvBiVC = [[EVHVBiViewController alloc] init];
            hvBiVC.asset = self.asset;
            [self.navigationController pushViewController:hvBiVC animated:YES];
        }
            break;
        case 3:
        {
            //我的发布
            [EVProgressHUD showMessage:@"暂未实现"];
        }
            break;
        case 4:
        {
            //我的购买
            [EVProgressHUD showMessage:@"暂未实现"];
        }
            break;
        case 5:
        {
            //我的收藏
            EVNewsCollectViewController *newsCollectVC = [[EVNewsCollectViewController alloc] init];
            [self.navigationController pushViewController:newsCollectVC animated:YES];
        }
            break;
        case 6:
        {
            //历史记录
            EVHVHistoryViewController *historyVC = [[EVHVHistoryViewController alloc] init];
            [self.navigationController pushViewController:historyVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([EVLoginInfo hasLogged] || [EVLoginInfo localObject].vip == 1)
    {
        //是大v
        if (indexPath.row == 3) {
            //有我的发布
            for (UIView * subViews in cell.contentView.subviews) {
                subViews.hidden = NO;
            }
        }
    }
    else
    {
        //不是大v
        if (indexPath.row == 3) {
            //没有我的发布
            for (UIView * subViews in cell.contentView.subviews) {
                subViews.hidden = YES;
            }
        }
    }
}

#pragma mark - 👣 Target actions
- (void)rightClick
{
    if ([EVBaseToolManager userHasLoginLogin]) {
        EVHVUserSettingController *userSettingVC = [[EVHVUserSettingController alloc] init];
        userSettingVC.userModel = self.userModel;
        [self.navigationController pushViewController:userSettingVC animated:YES];
    }else {
        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
        [self presentViewController:navighaVC animated:YES completion:nil];
    }
}



#pragma mark - ✍️ Setters & Getters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 -49) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (EVBaseToolManager *)engine
{
    if (!_engine)
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    
    return _engine;
}

- (void)setUserModel:(EVUserModel *)userModel
{
    if (userModel) {
        _userModel = userModel;
        [self.tableView reloadData];
    }
}
#pragma mark - 🗑 CleanUp
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
