//
//  EVLimitViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLimitViewController.h"
#import "EVLimitHeaderView.h"
#import "EVLimitMenuCell.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVFriend.h"
#import "UIScrollView+GifRefresh.h"
#import <PureLayout.h>
#import "EVSettingLivingPWDView.h"
#import "EVSetLivingPaySumView.h"
#import "EVFriendItem.h"

#define kDefaultRequestFriendCount 10
#define kDefaultAnimationTime 0.5

#define kAnimationTime 0.2

// 付费直播 金额Key
#define kPayLivePriceKey        @"price"

@interface CCFriendListResponse : EVBaseObject

@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger next;
@property (nonatomic,assign) NSInteger start;
@property (nonatomic,strong) NSArray *friends;

@end

@implementation CCFriendListResponse

+ (NSDictionary *)gp_objectClassesInArryProperties{
    return @{@"friends": [EVFriendItem class]};
}

@end

@interface EVLimitViewController () <EVLimitHeaderViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *menuItemArray;

@property (nonatomic,strong) EVBaseToolManager *engine;

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) NSArray *friends;

@property (nonatomic,strong) NSMutableArray *filterFriends;

@property (nonatomic,weak) CCLimitMenuCellItem *someFriendCanSee;


@property (nonatomic, assign) BOOL filterFriend;

@property (nonatomic,weak) EVSettingLivingPWDView *passwordSettingView;

@end

@implementation EVLimitViewController

- (void)dealloc
{
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    
    EVLog(@"CCLimitViewController dealloc");
    [_engine cancelAllOperation];
    _engine = nil;
}

- (EVSettingLivingPWDView *)passwordSettingView
{
    if ( _passwordSettingView == nil )
    {
        EVSettingLivingPWDView *passwordSettingView = [[EVSettingLivingPWDView alloc] init];
        passwordSettingView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
        for ( CCLimitMenuCellItem *item in self.menuItemArray )
        {
            if ( item.permission == EVLivePermissionPassWord )
            {
                passwordSettingView.lastPwd = item.password;
            }
        }
        [self.view addSubview:passwordSettingView];
        _passwordSettingView = passwordSettingView;
    }
    return _passwordSettingView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( self.reuse )
    {
        return;
    }
    [self setUpViews];
}

- (NSMutableArray *)filterFriends
{
    if ( _filterFriends == nil )
    {
        _filterFriends = [[NSMutableArray alloc] init];
    }
    return _filterFriends;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    [self.searchCell endEditing];
}

- (void)show
{
    [self viewAnimationWithOffsetY:0];
}

- (void)hidden
{
    [self viewAnimationWithOffsetY:ScreenHeight];
}

- (void)viewAnimationWithOffsetY:(CGFloat)offsetY
{
    self.view.hidden = offsetY == 0;
    
    CGRect frame = self.view.frame;
    frame.origin.y = offsetY;
    [UIView animateWithDuration:kAnimationTime animations:^{
        self.view.frame = frame;
    }];
}

- (void)dimiss
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (NSArray *)menuItemArray
{
    if ( _menuItemArray == nil )
    {
        CCLimitMenuCellItem *item1 = [[CCLimitMenuCellItem alloc] init];
        item1.permission = EVLivePermissionSquare;
        item1.title = @"公开";
        item1.cellDescription = @"所有人可见";
        item1.selected = YES;
        
        CCLimitMenuCellItem *item2 = [[CCLimitMenuCellItem alloc] init];
        item2.permission = EVLivePermissionPrivate;
        item2.title = @"私密";
        item2.cellDescription = @"仅自己可见";
        
        CCLimitMenuCellItem *itempwd = [[CCLimitMenuCellItem alloc] init];
        itempwd.permission = EVLivePermissionPassWord;
        itempwd.title = @"直播密码";
        itempwd.cellDescription = @"仅密码可见";
        
        CCLimitMenuCellItem *itemPay = [[CCLimitMenuCellItem alloc] init];
        itemPay.title = @"付费直播";
        itemPay.permission = EVLivePermissionPay;
        itemPay.cellDescription = @"观众付费才能观看";
        
        
        
        _menuItemArray = @[item1, item2, itempwd, itemPay];
    }
    return _menuItemArray;
}

- (void)setUpViews
{
    // 顶部类似导航条
    UIView *navBarV = [[UIView alloc] initWithFrame:CGRectZero];
    navBarV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navBarV];
    [navBarV autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0f, .0f, .0f, .0f) excludingEdge:ALEdgeBottom];
    [navBarV autoSetDimension:ALDimensionHeight toSize:64];
    
    EVLimitHeaderView *headerView = [EVLimitHeaderView limitHeaderView];
    headerView.delegate = self;
    [navBarV addSubview:headerView];
    [headerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0f, .0f, .0f, .0f) excludingEdge:ALEdgeTop];
    [headerView autoSetDimension:ALDimensionHeight toSize:44];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:headerView];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EVLimitMenuCell" bundle:nil] forCellReuseIdentifier:@"EVLimitMenuCell"];
    
}

- (EVBaseToolManager *)engine
{
    if ( _engine == nil )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}


#pragma mark - EVLimitHeaderViewDelegate
- (void)limitHeaderViewDidClickButton:(EVLimitHeaderViewButtonType)type
{
    if ( type == EVLimitHeaderViewButtonComfirm )
    {
        NSDictionary *params = nil;
        EVLivePermission permission = EVLivePermissionSquare;
        CCLimitMenuCellItem *selectItem = nil;
        for (CCLimitMenuCellItem *item in _menuItemArray)
        {
            if ( item.selected )
            {
                permission = item.permission;
                selectItem = item;
            }
        }

        if ( permission == EVLivePermissionPassWord )
        {
            params = @{kPassword : selectItem.password };
        } else if (permission == EVLivePermissionPay) {
            params = @{kPayLivePriceKey : selectItem.price};
        }
        
        if ( [self.delegate respondsToSelector:@selector(limitViewControllerDidComfirmWithPermission:params:)] )
        {
            [self.delegate limitViewControllerDidComfirmWithPermission:permission params:params];
        }
        
    }

    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }];
}

#pragma mark - CCLimitSearchCellDelegate

- (void)limitCellDidCancelItem:(EVFriendItem *)item
{
    self.filterFriend = NO;
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.menuItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        EVLimitMenuCell *cell = (EVLimitMenuCell *)[tableView dequeueReusableCellWithIdentifier:@"EVLimitMenuCell"];
        CCLimitMenuCellItem *item = self.menuItemArray[indexPath.row];
        cell.menuCellItem = item;
        return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        CCLimitMenuCellItem *item = self.menuItemArray[indexPath.row];
        [self p_didSelectedCell:item];
        
        [tableView reloadData];
    
}

- (void)p_didSelectedCell:(CCLimitMenuCellItem *)item {
    for (CCLimitMenuCellItem *item1 in self.menuItemArray)
    {
        item1.selected = NO;
        item1.extend = NO;
        item1.showRightNotice = NO;
    }
    item.selected = YES;
    if ( item.hasIndecator )
    {
        item.extend = YES;
    }
    
    __weak typeof(self) wself = self;
    // 跳转密码设置页
    if ( item.permission == EVLivePermissionPassWord )
    {
        [self.passwordSettingView showAndCatchResult:^(NSString *password) {
            if ( password.length == 0 )
            {
                item.selected        = NO;
                item.showRightNotice = NO;
                CCLimitMenuCellItem *firstItem = wself.menuItemArray[0];
                firstItem.selected = YES;
            }
            else
            {
                item.selected        = YES;
                item.showRightNotice = YES;
                item.password        = password;
            }
            [wself.tableView reloadData];
        }];
    } else if (item.permission == EVLivePermissionPay) {
        [EVSetLivingPaySumView showSetLivingPaySumViewToSuperView:self.view complete:^(NSString *sum, BOOL isCancel) {
            if (sum.length == 0 || isCancel) {
                item.selected        = NO;
                item.showRightNotice = NO;
                CCLimitMenuCellItem *firstItem = wself.menuItemArray[0];
                firstItem.selected = YES;
            } else {
                item.selected        = YES;
                item.showRightNotice = YES;
                item.price           = sum;
            }
            [wself.tableView reloadData];
        }];
    }
}

@end
