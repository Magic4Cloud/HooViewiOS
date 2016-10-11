//
//  EVMngUserListController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVMngUserListController.h"
#import "EVFantuanContributorTableViewCell.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVMngUserListModel.h"
#import "EVNullDataView.h"

@interface EVMngUserListController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) EVBaseToolManager *engine; /**< 网络请求管理模块 */

@property (strong,nonatomic) EVNullDataView *nilManagerV;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *adminListArray;
@property (nonatomic,strong)NSMutableArray *adminLissNameArray;

@end

@implementation EVMngUserListController


- (NSMutableArray *)adminListArray
{
    if (!_adminListArray) {
        _adminListArray = [NSMutableArray array];
    }
    return _adminListArray;
}

- (NSMutableArray *)adminLissNameArray
{
    if (!_adminLissNameArray) {
        _adminLissNameArray = [NSMutableArray array];
    }
    return _adminLissNameArray;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-94) style:(UITableViewStylePlain)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 65.0;
        _tableView.sectionHeaderHeight = 30;
        _tableView.backgroundColor = CCBackgroundColor;
    }
    return _tableView;
}

- (void)addUpTableView
{
    [self.view addSubview:self.tableView];
    UIView* footView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footView;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([_tableView respondsToSelector:@selector(setLayoutMargins:)]){
        
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kE_GlobalZH(@"manager_list");

    // Do any additional setup after loading the vie
    
     self.view.backgroundColor = CCBackgroundColor;
  
    [self addUpData];
    [self addUpTableView];
    [self addUpAdminView];
}


- (void)addUpAdminView
{
    EVNullDataView *adminV = [[EVNullDataView alloc]initWithFrame:CGRectMake(0, 70,ScreenWidth,ScreenWidth)];
    adminV.topImage = [UIImage imageNamed:@"home_pic_findempty"];
    adminV.title = kE_GlobalZH(@"no_manager");
    adminV.backgroundColor = [UIColor clearColor];
    [adminV show];
    [self.view addSubview:adminV];
    self.nilManagerV = adminV;
}

- (void)addUpData
{

    
}

- (EVBaseToolManager *)engine
{
    if ( !_engine )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    
    return _engine;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.adminListArray.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kE_GlobalZH(@"e_yi_delete");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EVMngUserListModel *listModel = self.adminListArray[indexPath.row];
        WEAK(self)
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, ScreenHeight)];
    view.backgroundColor = CCBackgroundColor;
    
    UILabel *labelNum = [[UILabel alloc]init];
    labelNum.frame = CGRectMake(20,0,ScreenWidth,30);
    labelNum.text = [NSString stringWithFormat:@"%@ %ld/5",kE_GlobalZH(@"current_manager"),(unsigned long)self.adminListArray.count];
    labelNum.font = [UIFont boldSystemFontOfSize:14.f];
    [view addSubview:labelNum];
    
    return view;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVFantuanContributorTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"cellIndentifier"];
    if (!Cell) {
        Cell = [[EVFantuanContributorTableViewCell
                 alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cellIndentifier"];
    }
   Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Cell.backgroundColor = [UIColor whiteColor];
    Cell.listModel =  self.adminListArray[indexPath.row];
    
    return Cell;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ([self.delegate respondsToSelector:@selector(mngUserListArray:)]) {
        [self.delegate mngUserListArray:self.adminLissNameArray];
    }
}

- (void)dealloc
{
    [_engine cancelAllOperation];
    _engine = nil;
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
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
