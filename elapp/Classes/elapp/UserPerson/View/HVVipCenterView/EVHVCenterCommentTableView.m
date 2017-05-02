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
#import "EVHVCenterCommentModel.h"


@interface EVHVCenterCommentTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    int start;
}

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) EVNullDataView *nullDataView;

@property (nonatomic, strong) NSMutableArray *dataArray;


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
        [self addVipUI];
//        [self loadData];
        
    }
    return self;
}

- (void)addVipUI
{
    
    EVNullDataView *nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-400)];
    
    self.nullDataView = nullDataView;
    
    nullDataView.topImage = [UIImage imageNamed:@"ic_cry"];
    nullDataView.title = @"没有相关评论噢";
    self.tableFooterView = nullDataView;
}

- (void)loadData {
    start = 0;
    [EVProgressHUD showIndeterminateForView:self];
    [self.baseToolManager GETHVCenterCommentListWithUserid:nil personid:_WatchVideoInfo.name start:start count:20 startBlock:^{
        
    } fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:self];
        self.nullDataView.hidden =  NO;
        
    } success:^(NSDictionary *retinfo) {
        [EVProgressHUD hideHUDForView:self];
        NSArray * comments = retinfo[@"total"];
        [self.dataArray removeAllObjects];
        if ([comments isKindOfClass:[NSArray class]] && comments.count >0) {
            
            [comments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVHVCenterCommentModel * model = [EVHVCenterCommentModel yy_modelWithDictionary:obj];
                [self.dataArray addObject:model];
            }];
            
            if (comments.count<20)
            {
                [self hideFooter];
            }
            else
            {
                [self showFooter];
            }
            start += 20;
        }
        else
        {
            [self hideFooter];
        }
        [self reloadData];
        self.nullDataView.hidden = self.dataArray.count == 0? NO:YES;
    } essionExpire:^{
        [EVProgressHUD hideHUDForView:self];
        self.nullDataView.hidden =  NO;
    }];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVHVCenterCommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"EVHVCenterCommentTableViewCell" forIndexPath:indexPath];
    EVHVCenterCommentModel *model = _dataArray[indexPath.row];
    commentCell.commentModel = model;
    commentCell.selectionStyle = UIAccessibilityTraitNone;
    return commentCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVHVCenterCommentModel *model = _dataArray[indexPath.row];
    CGRect rect = [model.content boundingRectWithSize:CGSizeMake(ScreenWidth - 81, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    
    return rect.size.height + 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVHVCenterCommentModel *model = _dataArray[indexPath.row];
    if (self.commentBlock) {
        self.commentBlock(model.topic);
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
//    [self loadData];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}

@end
