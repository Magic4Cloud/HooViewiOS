//
//  EVHVVideoCommentView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVVideoCommentView.h"
#import "EVCommentViewCell.h"
#import "EVHVVideoCommentModel.h"
#import "EVBaseToolManager+EVHomeAPI.h"

@interface EVHVVideoCommentView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, copy) NSString *start;
@end

@implementation EVHVVideoCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    UITableView *commentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    commentTableView.delegate = self;
    commentTableView.dataSource = self;
    [self addSubview:commentTableView];
    self.commentTableView = commentTableView;
    [commentTableView autoPinEdgesToSuperviewEdges];
    
    commentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_commentTableView addRefreshFooterWithRefreshingBlock:^{
        [self loadDataVid:self.watchVideoInfo.vid start:self.start count:@"20"];
    }];
}

- (void)loadDataVid:(NSString *)vid start:(NSString *)start count:(NSString *)count
{
    [self.baseToolManager GETVideoCommentListVid:vid start:start count:count start:^{
        
    } fail:^(NSError *error) {
        [EVProgressHUD showError:@"加载失败"];
    } success:^(NSDictionary *retinfo) {
        self.start = retinfo[@"retinfo"][@"next"];
        [_commentTableView endFooterRefreshing];
        NSArray *commentArr = [EVHVVideoCommentModel objectWithDictionaryArray:retinfo[@"retinfo"][@"posts"]];
        if ([retinfo[@"retinfo"][@"start"] integerValue] == 0) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:commentArr];
        [self.commentTableView reloadData];
        [self.commentTableView setFooterState:(commentArr.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVCommentViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    if (!Cell) {
        Cell = [[EVCommentViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"commentCell"];
    }
    Cell.videoCommentModel = self.dataArray[indexPath.row];
    return Cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVHVVideoCommentModel *commentModel = self.dataArray[indexPath.row];
    return commentModel.cellHeight < 87 ? 87 : commentModel.cellHeight;
}

//- (void)setDataArray:(NSMutableArray *)dataArray
//{
//    _dataArray = dataArray;
//    [self.commentTableView reloadData];
//}

- (void)setWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo
{
    _watchVideoInfo = watchVideoInfo;
    [self loadDataVid:self.watchVideoInfo.vid start:@"0" count:@"20"];
    
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
