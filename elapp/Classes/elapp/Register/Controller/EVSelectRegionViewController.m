//
//  EVSelectRegionViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVSelectRegionViewController.h"
#import "EVRegionCodeTableViewCell.h"
#import "EVRegionCodeModel.h"


NSString *const regionCodeCell = @"regionCodeCell";

@interface EVSelectRegionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *regionTable;
@property (nonatomic, strong) NSArray *regionGroups;
@property (nonatomic, weak) UIView *navBar;
@property (nonatomic, weak) UIButton *backBtn;

@end

@implementation EVSelectRegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpData];
}

- (void)dealloc
{
    _regionTable.dataSource = nil;
    _regionTable.delegate = nil;
    _regionTable = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (NSArray *)regionGroups
{
    if ( _regionGroups == nil )
    {
        _regionGroups = [CCRegionCodeGroup regionCodeGroups];
    }
    return _regionGroups;
}

- (void)setUpData
{
    self.title = kInternational_area_code;
    [self regionGroups];
    [self.regionTable reloadData];
    
    if ( self.navigationController == nil ) {
        [self navBar];
        [self backBtn];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

#pragma mark - UITabelView delegate

#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.regionGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.regionGroups[section] items].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVRegionCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:regionCodeCell];
    if ( !cell )
    {
        cell = [[EVRegionCodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:regionCodeCell];
    }
    
    CCRegionCodeGroup *region = self.regionGroups[indexPath.section];
    EVRegionCodeModel *model = region.items[indexPath.row];
    cell.regionCodeModel = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCRegionCodeGroup *region = self.regionGroups[indexPath.section];
    EVRegionCodeModel *model = region.items[indexPath.row];
    if ( _delegate && [_delegate respondsToSelector:@selector(selectRegiton:)] )
    {
        [_delegate selectRegiton:model];
    }
    if ( self.navigationController == nil ) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.regionGroups[section] group_name];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (CCRegionCodeGroup *item in self.regionGroups)
    {
        [array addObject:item.group_name];
    }
    return array;
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setter getter
- (UITableView *)regionTable
{
    if ( !_regionTable )
    {
        CGRect frame = self.view.bounds;
        if ( self.navigationController == nil )
        {
            frame.size.height -= self.navBar.bounds.size.height;
            frame.origin.y += self.navBar.bounds.size.height ;
        }
        UITableView *regionTable = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        regionTable.delegate = self;
        regionTable.dataSource = self;
        [self.view addSubview:regionTable];
//        if ( self.navigationController == nil ) {
            regionTable.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
//        }
        _regionTable = regionTable;
    }
    return _regionTable;
}

- (UIView *)navBar
{
    if ( !_navBar )
    {
        UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
        navBar.backgroundColor = [UIColor evBackgroundColor];
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, navBar.bounds.size.height - 0.5, navBar.bounds.size.width, 0.5)];
        bottomView.backgroundColor = [UIColor lightGrayColor];
        [navBar addSubview:bottomView];
        [self.view addSubview:navBar];
        _navBar = navBar;
    }
    return _navBar;
}

- (UIButton *)backBtn
{
    if ( !_backBtn )
    {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 20, 80, self.navBar.bounds.size.height - 20);
        [backBtn setTitle:kEBack forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"nav_icon_return"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.navBar addSubview:backBtn];
        _backBtn = backBtn;
    }
    return _backBtn;
}

@end
