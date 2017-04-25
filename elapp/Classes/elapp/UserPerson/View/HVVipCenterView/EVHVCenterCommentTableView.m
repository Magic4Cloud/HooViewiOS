//
//  EVHVCenterCommentTableView.m
//  elapp
//
//  Created by 周恒 on 2017/4/24.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVCenterCommentTableView.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVLoginInfo.h"
#import "EVNullDataView.h"
#import "EVBaseToolManager+EVNewsAPI.h"
#import "EVNewsModel.h"
#import "EVNewsDetailWebController.h"

#import "EVOnlyTextCell.h"
#import "EVThreeImageCell.h"
#import "EVNewsListViewCell.h"
#import "EVHVCenterCommentTableViewCell.h"


@interface EVHVCenterCommentTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) NSMutableArray *fansOrFollowers;

@property (nonatomic, strong) EVNullDataView *nullDataView;


@end

@implementation EVHVCenterCommentTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"EVHVCenterCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"EVHVCenterCommentTableViewCell"];
        
        
        self.tableFooterView = [UIView new];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self addVipUI];

        
    }
    return self;
}

- (void)addVipUI
{
    
    EVNullDataView *nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 300, ScreenWidth, ScreenHeight-108)];
    
    [self addSubview:nullDataView];
    self.nullDataView = nullDataView;
    
    nullDataView.topImage = [UIImage imageNamed:@"ic_smile"];
    nullDataView.title = @"没有相关文章奥";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVHVCenterCommentTableViewCell *fansCell = [tableView dequeueReusableCellWithIdentifier:@"EVHVCenterCommentTableViewCell" forIndexPath:indexPath];
    
    return fansCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 186;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVNewsModel *articleModel = self.fansOrFollowers[indexPath.row];
    if (self.ArticleBlock) {
        self.ArticleBlock(articleModel);
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (void)setWatchVideoInfo:(EVWatchVideoInfo *)WatchVideoInfo
{
    _WatchVideoInfo = WatchVideoInfo;
}


- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}

@end
