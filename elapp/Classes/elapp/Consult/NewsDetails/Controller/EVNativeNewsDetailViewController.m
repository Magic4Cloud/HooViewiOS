//
//  EVNativeNewsDetailViewController.m
//  elapp
//
//  Created by 唐超 on 5/8/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVNativeNewsDetailViewController.h"
#import "EVStockDetailBottomView.h"
#import "EVSharePartView.h"

@interface EVNativeNewsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,EVStockDetailBottomViewDelegate,EVWebViewShareViewDelegate>
@property (nonatomic, strong)UITableView * tableView;

@property (nonatomic, strong) EVStockDetailBottomView *detailBottomView;

@property (nonatomic, strong) EVSharePartView *eVSharePartView;
@end

@implementation EVNativeNewsDetailViewController

#pragma mark - ♻️Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:49];
    
    [self.view addSubview:self.detailBottomView];
    [self.view addSubview:self.eVSharePartView];
    
}

#pragma mark - 🌐Networks
- (void)loadNewData
{
    
}
#pragma mark -👣 Target actions

#pragma mark - delegate
- (void)shareType:(EVLiveShareButtonType)type
{
    
}

- (void)detailBottomClick:(EVBottomButtonType)type button:(UIButton *)btn
{
    
}

#pragma mark - 🌺 TableView Delegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifer = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - ✍️ Setters & Getters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 100;
    }
    return _tableView;
}

- (EVSharePartView *)eVSharePartView {
    if (!_eVSharePartView) {
        _eVSharePartView = [[EVSharePartView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - 49)];
        _eVSharePartView.backgroundColor = [UIColor colorWithHexString:@"#303030" alpha:0.7];
        _eVSharePartView.eVWebViewShareView.delegate = self;
        __weak typeof(self) weakSelf = self;
        _eVSharePartView.cancelShareBlock = ^() {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.eVSharePartView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-49);
            }];
        };

    }
    return _eVSharePartView;
}

- (EVStockDetailBottomView *)detailBottomView
{
    if (!_detailBottomView) {
        _detailBottomView = [[EVStockDetailBottomView alloc] initWithFrame: CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49) isBottomBack:YES];
        NSArray *titleArray = @[@"分享",@"收藏",@"评论"];
        NSArray *seleteTitleArr = @[@"分享",@"已收藏",@"评论"];
        NSArray *imageArray = @[@"btn_share_n",@"btn_news_collect_n",@"btn_news_comment_n"];
        NSArray *seleteImageArr = @[@"btn_share_n",@"btn_news_collecte_s",@"btn_news_comment_n"];
        [_detailBottomView addButtonTitleArray:titleArray seleteTitleArr:seleteTitleArr imageArray:imageArray seleteImage:seleteImageArr];
        _detailBottomView.backgroundColor = [UIColor whiteColor];
        _detailBottomView.delegate = self;
        __weak typeof(self) weakSelf = self;
        _detailBottomView.backButtonClickBlock = ^()
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _detailBottomView;
}
@end
