//
//  EVHVEyesDetailView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/15.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVEyesDetailView.h"
#import "EVNewsListViewCell.h"
#import "EVRefreshSuccessView.h"


@interface EVHVEyesDetailView ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) NSMutableArray *eyesDataArray;

@property (nonatomic, copy) NSString *start;

@property (nonatomic, weak) UILabel *successLabel;
@end

@implementation EVHVEyesDetailView

- (instancetype)initWithFrame:(CGRect)frame model:(EVHVEyesModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpView];
        self.eyesModel = model;
        [self loadEyesStart:@"0" count:@"20" eyesModel:model];
    }
    return self;
}

- (void)successLoadViewStr:(NSString *)str
{
    UIView *successView = [[UIView alloc] init];
    [self addSubview:successView];
    successView.frame = CGRectMake(0, 20, ScreenWidth, 20);
    successView.backgroundColor = [UIColor evMainColor];
    successView.alpha = 0.7;
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"最后更新: YYYY/MM/dd hh:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    UILabel *successLabel = [[UILabel alloc] init];
    [successView addSubview:successLabel];
    self.successLabel  = successLabel;
    successLabel.frame = CGRectMake(0, 0, ScreenWidth, 20);
    successLabel.textColor = [UIColor whiteColor];
    [successLabel setText:dateString];
    successLabel.backgroundColor = [UIColor clearColor];
    successLabel.font   = [UIFont systemFontOfSize:14];
    successLabel.textAlignment = NSTextAlignmentCenter;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [successView removeFromSuperview];
    });
}

- (void)addUpView
{
    UITableView *iNewsTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-108) style:(UITableViewStyleGrouped)];
    iNewsTableview.delegate = self;
    iNewsTableview.dataSource = self;
    [self addSubview:iNewsTableview];
    iNewsTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _detailTableView = iNewsTableview;
    _detailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    WEAK(self)
    [_detailTableView addRefreshHeaderWithRefreshingBlock:^{
        [weakself loadEyesStart:@"0" count:@"20" eyesModel:weakself.eyesModel];
    }];
    [_detailTableView addRefreshFooterWithRefreshingBlock:^{
        [weakself loadEyesStart:weakself.start count:@"20" eyesModel:weakself.eyesModel];
    }];
    
    _detailTableView.mj_footer.hidden = YES;
}


- (void)loadEyesStart:(NSString *)start count:(NSString *)count eyesModel:(EVHVEyesModel *)eyesModel
{
    [self.baseToolManager GETEyesNewsRequestChannelid:self.eyesID Programid:eyesModel.eyesID start:start count:count Success:^(NSDictionary *retinfo) {
        [_detailTableView endFooterRefreshing];
        [_detailTableView endHeaderRefreshing];
        if ([start integerValue]== 0) {
            [self.eyesDataArray removeAllObjects];
        }
        self.start = retinfo[@"start"];
        NSArray *eyesArr =   [EVHVEyesModel objectWithDictionaryArray:retinfo[@"news"]];
        if (eyesArr.count > 0) {
            [EVRefreshSuccessView showRefreshSuccessViewTo:self newsCount:eyesArr.count];
        }
        [self.eyesDataArray addObjectsFromArray:eyesArr];
        [self.detailTableView reloadData];
        _detailTableView.mj_footer.hidden = NO;
        [self.detailTableView setFooterState:(eyesArr.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
    } error:^(NSError *error) {
        [_detailTableView endFooterRefreshing];
        [_detailTableView endHeaderRefreshing];
        [EVProgressHUD showError:@"加载失败"];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eyesDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVNewsListViewCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"eyesCell"];
    if (!newsCell) {
        
        newsCell = [[NSBundle mainBundle] loadNibNamed:@"EVNewsListViewCell" owner:nil options:nil].firstObject;
    }
    newsCell.eyesModel = self.eyesDataArray[indexPath.row];
    newsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return newsCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVHVEyesModel *eyesModel = self.eyesDataArray[indexPath.row];
    if (self.eyesBlock) {
        self.eyesBlock(eyesModel);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.detailTableView reloadData];
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}


- (NSMutableArray *)eyesDataArray
{
    if (!_eyesDataArray) {
        _eyesDataArray = [NSMutableArray array];
    }
    return _eyesDataArray;
}
@end
