//
//  EVInformImGroupViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVInformImGroupViewController.h"
#import <PureLayout/PureLayout.h>
#import "EVBaseToolManager+EVAccountAPI.h"

@interface EVInformImGroupViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;  /**< 列表 */
@property (strong, nonatomic) NSArray *informReasons; /**< 举报原因 */
@property (strong, nonatomic) UITableViewCell *lastCell; /**< 上次选中的cell */
@property (strong, nonatomic) NSIndexPath *lastIndexPath; /**< 上次选中的行 */
@property (strong, nonatomic) UIButton *confirmBtn;  /**< 确认按钮 */
@property ( strong, nonatomic ) EVBaseToolManager   *engine;


@end

@implementation EVInformImGroupViewController

#pragma mark - life circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"举报原因";
    
    [self setUpViews];
    [self setUpDatas];
}

- (EVBaseToolManager *)engine
{
    if ( _engine == nil )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_informReasons count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *title = [[UIButton alloc] init];
    [title setTitleColor:[UIColor colorWithHexString:@"#403b37"]
                forState:UIControlStateNormal];
    title.alpha = 0.6f;
    title.titleLabel.font = [UIFont systemFontOfSize:14.f];
    title.frame = CGRectMake(0.f, 0.f, ScreenWidth, tableView.sectionHeaderHeight);
    [title setTitle:@"请选择举报原因"
           forState:UIControlStateNormal];
    title.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    title.contentEdgeInsets = UIEdgeInsetsMake(0.f, 15.f, 0.f, 0.f);
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *informGroupCellID = @"informGroupCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:informGroupCellID];
    if ( !cell )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:informGroupCellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#403b37"];
        cell.textLabel.font = CCNormalFont(15);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        UIImage *image = [UIImage imageNamed:@"living_ready_limit_icon_select"];
        cell.accessoryView = [[UIImageView alloc] initWithImage:image];
        cell.accessoryView.hidden = YES;
    }
    cell.textLabel.text = self.informReasons[indexPath.row];
    
    return cell;
}

- (CGFloat)             tableView:(UITableView *)tableView
         heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)             tableView:(UITableView *)tableView
          heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

- (void)                tableView:(UITableView *)tableView
          didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self changeAccessoryView:indexPath tableView:tableView];
}


#pragma mark - action responses

- (void)didClickComfirmBarButtonItem
{
    NSString *reason = self.informReasons[self.lastIndexPath.row];
    NSDictionary *params = @{kDescriptionKey:reason,KgroupidKey:self.groupId};
//    [self.engine baseRequestWithURI:CCGroupInformAPI params:params fail:^(NSError *error) {
//
//    } success:^(NSDictionary *imInfo) {
//        
//    } sessionExpire:^{
//        
//    }];
    
    [CCProgressHUD showSuccess:@"已提交"];
    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark - private methods

- (void)changeAccessoryView:(NSIndexPath *)indexPath
                  tableView:(UITableView *)tableView
{
    _confirmBtn.enabled = YES;
    _lastCell.accessoryView.hidden = YES;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView.hidden = NO;
    
    _lastIndexPath = indexPath;
    _lastCell = cell;
}

- (void)setUpViews
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView autoPinEdgesToSuperviewEdges];
    tableView.backgroundColor = CCBackgroundColor;
    tableView.separatorColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    
    // 导航栏右侧按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmButton.frame = CGRectMake(0, 0, 60, 40);
    [confirmButton setTitleColor:CCAppMainColor forState:UIControlStateNormal];
    [confirmButton setTitleColor:CCButtonDisableColor forState:UIControlStateDisabled];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    confirmButton.titleLabel.font = CCNormalFont(15);
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(didClickComfirmBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirmButton];
    [confirmButton setEnabled:NO];
    self.confirmBtn = confirmButton;

}

- (void)setUpDatas
{
    _informReasons = @[@"低俗色情",
                       @"欺诈骗钱",
                       @"违法信息",
                       @"其他问题"];
}

@end
