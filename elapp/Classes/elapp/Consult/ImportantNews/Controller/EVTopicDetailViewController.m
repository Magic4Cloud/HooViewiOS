//
//  EVTopicDetailViewController.m
//  elapp
//
//  Created by 唐超 on 4/11/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVTopicDetailViewController.h"
#import "EVNewsDetailWebController.h"
#import "EVTopicHeaderView.h"
#import "EVBaseToolManager.h"

#import "EVTopicModel.h"

#import "EVOnlyTextCell.h"
#import "EVThreeImageCell.h"
#import "EVNewsListViewCell.h"

@interface EVTopicDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)EVTopicHeaderView * headerView;
@property (nonatomic, strong)EVTopicModel * topicModel;
@property (nonatomic, strong)UIActivityIndicatorView * activityView;
@property (nonatomic, strong)UIView * naviBarBgView;
@property (nonatomic, weak)UIButton * backButton;
@end

@implementation EVTopicDetailViewController
#pragma mark - ♻️Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNewData];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.naviBarBgView];
    
    UIButton *backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(4, 15, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"hv_back_return"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    _backButton = backBtn;
    
    [self.view addSubview:self.activityView];
    [self.activityView autoCenterInSuperview];
    self.activityView.hidden = YES;
    
}

- (void)setUpTableView
{
    self.naviBarBgView.alpha = 0;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [_backButton setImage:[UIImage imageNamed:@"personal_nav_icon_return"] forState:UIControlStateNormal];
    
    [self.view insertSubview:self.tableView atIndex:0];
    [self.tableView autoPinEdgesToSuperviewEdges];
    self.tableView.tableHeaderView = self.headerView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EVOnlyTextCell" bundle:nil] forCellReuseIdentifier:@"EVOnlyTextCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVThreeImageCell" bundle:nil] forCellReuseIdentifier:@"EVThreeImageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVSpecialTopicCell" bundle:nil] forCellReuseIdentifier:@"EVSpecialTopicCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVNewsListViewCell" bundle:nil] forCellReuseIdentifier:@"EVNewsListViewCell"];
}

#pragma mark - 🌐Networks
- (void)loadNewData
{
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
    [EVBaseToolManager GETNotVerifyRequestWithUrl:EVHVNewsTopicAPI parameters:@{@"id":_newsId} success:^(NSDictionary *successDict)
    {
        [self.activityView stopAnimating];
        self.topicModel = [EVTopicModel yy_modelWithDictionary:successDict];
        [self setUpTableView];
        [self.tableView reloadData];
        
    } fail:^(NSError *error)
    {
        [self.activityView stopAnimating];
    }];
}

#pragma mark -👣 Target actions
- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 🌺 TableView Delegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _topicModel.news.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVNewsModel * model = _topicModel.news[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //新闻列表
    EVNewsModel * newsModel = _topicModel.news[indexPath.row];
    
    if ([newsModel.type isEqualToString:@"0"])
    {
        //普通新闻
        if (newsModel.cover == nil || newsModel.cover.count == 0)
        {
            //没有图片
            EVOnlyTextCell * textCell = [tableView dequeueReusableCellWithIdentifier:@"EVOnlyTextCell"];
            textCell.newsModel = newsModel;
            return textCell;
        }
        else if (newsModel.cover.count == 1)
        {
            //一张图片
            EVNewsListViewCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsListViewCell"];
            newsCell.consultNewsModel = newsModel;
            return newsCell;
        }
        else if (newsModel.cover.count == 3)
        {
            //三张图片
            EVThreeImageCell * threeImageCell = [tableView dequeueReusableCellWithIdentifier:@"EVThreeImageCell"];
            threeImageCell.newsModel = newsModel;
            return threeImageCell;
        }
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //普通新闻
    EVNewsModel * newsModel = _topicModel.news[indexPath.row];
    
    EVNewsDetailWebController *newsWebVC = [[EVNewsDetailWebController alloc] init];
    newsWebVC.newsID = newsModel.newsID;
    newsWebVC.newsTitle = newsModel.title;
    if ([newsModel.newsID isEqualToString:@""] || newsModel.newsID == nil) {
        return;
    }
    [self.navigationController pushViewController:newsWebVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        float y = scrollView.contentOffset.y;
//        NSLog(@"y:%f",y);
        if (y>100) {
            [UIView animateWithDuration:0.5 animations:^{
                self.naviBarBgView.alpha = 1;
            } completion:^(BOOL finished) {
                [_backButton setImage:[UIImage imageNamed:@"hv_back_return"] forState:UIControlStateNormal];
                 [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.naviBarBgView.alpha = 0;
            } completion:^(BOOL finished) {
                [_backButton setImage:[UIImage imageNamed:@"personal_nav_icon_return"] forState:UIControlStateNormal];
                 [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            }];
        }
    }
}
#pragma mark - ✍️ Setters & Getters
- (UIView *)naviBarBgView
{
    if (!_naviBarBgView) {
        _naviBarBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
        _naviBarBgView.backgroundColor = [UIColor whiteColor];
    }
    return _naviBarBgView;
}
- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.hidesWhenStopped = YES;
        _activityView.tintColor = [UIColor purpleColor];
    }
    return _activityView;
}
- (void)setTopicModel:(EVTopicModel *)topicModel
{
    if (topicModel == nil) {
        return;
    }
//    topicModel.introduce = @"日前，西安交通大学、中央财经大学、上海财经大学、大连海事大学等多所高校研究生院发布消息：依据《财政部教育部关于进一步提高博士生国家助学金资助标准的通知》(财科教〔2017〕5号)文件要求，从2017年春季学期起，提高全国研究生招生计划内的全日制博士生(有固定工资收入的除外)国家助学金资助标准，其中中央高校博士生从每生每年12000元提高到15000元，即每生每月提高250元。";
//    topicModel.title = @"4月10日，国家主席习近平在北京人民大会堂同缅甸总统吴廷觉举行会谈。会谈前，习近平在人民大会堂东门外广场为吴廷觉举行欢迎仪式。新华社记者姚大伟摄";
    _topicModel = topicModel;
    
    NSString * detailString = _topicModel.introduce;
    //计算简介高度
    float labelHeight = [self getSpaceLabelHeight:detailString withFont:[UIFont systemFontOfSize:14] withWidth:ScreenWidth- 22];
    CGRect frame = _headerView.frame;
    frame.size.height = labelHeight + 227-60;
    
    self.headerView.topicModel = topicModel;
    self.headerView.frame = frame;
    
}

//计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 6;
//    paraStyle.hyphenationFactor = 1.0;
//    paraStyle.firstLineHeadIndent = 0.0;
//    paraStyle.paragraphSpacingBefore = 0.0;
//    paraStyle.headIndent = 0;
//    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (EVTopicHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[EVTopicHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 227)];
    }
    return _headerView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
