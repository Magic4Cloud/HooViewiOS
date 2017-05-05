//
//  EVLiveImageTableView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/13.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVLiveImageTableView.h"
#import "EVLiveIgeContentViewCell.h"
#import "NSString+Extension.h"


@interface EVLiveImageTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *watchLabel;

@end


@implementation EVLiveImageTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}


#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataArray.count;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    EVLiveIgeContentViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
    if (!Cell) {
        Cell = [[EVLiveIgeContentViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"chatCell"];
    }
    Cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    Cell.easeMessageModel = self.dataArray[indexPath.row];
    
    
    if (self.tpDataArray.count > 0 && indexPath.row == 0) {
        Cell.leftCircleIgeView.image = [UIImage imageNamed:@"ic_top"];
        Cell.lineView.backgroundColor = [UIColor colorWithHexString:@"#672f87"];
        Cell.contentLabel.textColor = [UIColor colorWithHexString:@"#672F87"];
    }
    return Cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollVBlock) {
        self.scrollVBlock(scrollView);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CGFloat cellh = [self.dataArray[indexPath.row] cellHeight];
    if (cellh<82) {
        return 82;
    }
    return [self.dataArray[indexPath.row] cellHeight] +15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    alphaView.backgroundColor = [UIColor colorWithHexString:@"#672F87"];
    alphaView.alpha = 0.05;
    [backView addSubview:alphaView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    contentView.backgroundColor = [UIColor clearColor];
    [backView addSubview:contentView];
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.frame = CGRectMake(12, 4, 100, 22);
    [contentView addSubview:dateLabel];
    dateLabel.text = [self stringWithData];
    dateLabel.font = [UIFont systemFontOfSize:16];
    dateLabel.textColor = [UIColor evTextColorH2];
    
//    [contentView addSubview:self.watchLabel];
    return backView;
}

- (UILabel * )watchLabel
{
    if (!_watchLabel) {
    
            _watchLabel = [[UILabel alloc] init];
            _watchLabel.frame = CGRectMake(0, 4, ScreenWidth - 12, 22);
            _watchLabel.text = @"200人气";
            _watchLabel.textAlignment = NSTextAlignmentRight;
            _watchLabel.font = [UIFont systemFontOfSize:16];
            _watchLabel.textColor = [UIColor evTextColorH2];
    
    }
    return _watchLabel;
}
- (NSString *)stringWithData
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

- (void)updateMessageModel:(EVEaseMessageModel *)easeModel
{
    if (self.tpDataArray.count >= 1) {
       [self.dataArray insertObject:easeModel atIndex:1];
    }else {
         [self.dataArray insertObject:easeModel atIndex:0];
    }
    [self reloadData];
    if (self.dataArray.count == 0) return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


- (void)updateStateModel:(EMMessage *)message
{
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
            EVEaseMessageModel *model = self.dataArray[i];
        if ([message.messageId isEqualToString:model.messageId]) {
            EVEaseMessageModel *newModel = [[EVEaseMessageModel alloc] initWithMessage:message];
            [self beginUpdates];
            [self.dataArray replaceObjectAtIndex:i withObject:newModel];
            [self reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self endUpdates];
        }
    }
}

- (void)updateTpMessageModel:(EVEaseMessageModel *)easeModel
{
    if (self.tpDataArray.count > 0) {
        [self updateMessageModel:[self.tpDataArray firstObject]];
    }
    [self.tpDataArray removeAllObjects];
    [self.tpDataArray insertObject:easeModel atIndex:0];
    [self.dataArray insertObject:easeModel atIndex:0];
    [self reloadData];
    if (self.tpDataArray.count == 0) return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)updateHistoryArray:(NSMutableArray *)array
{
    [self.dataArray addObjectsFromArray:array];
    
    [self updateTpArray:_dataArray];
    [self reloadData];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
//    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
//自己加的   从总数据中 找出置顶消息
- (void)updateTpArray:(NSMutableArray *)array
{
    NSInteger endCount = array.count;
    //只从前20条数据里取置顶的消息 其余的置顶消息忽略
    if (array.count>=20) {
        endCount = 20;
    }
    [self.tpDataArray removeAllObjects];
    for (int i = 0; i<endCount; i++) {
        EVEaseMessageModel * model = array[i];
        //如果为置顶消息
        if (model.state == EVEaseMessageTypeStateSt) {
            
            [self.tpDataArray addObject:model];
            if (i != 0) {
                NSArray * tempArray = [NSArray arrayWithArray:array];
                EVEaseMessageModel * tempModel = tempArray[i];
                [array removeObjectAtIndex:i];
                [array insertObject:tempModel atIndex:0];
                [self reloadData];
            }
            break;
        }
    }
}
- (void)updateWatchCount:(NSInteger)count
{
    count = count < 0 ? 0 : count;
    self.watchLabel.text = [NSString stringWithFormat:@"%@人气",[NSString numFormatNumber:count]];
    
}

- (void)setLiveWatchVideo:(EVWatchVideoInfo *)liveWatchVideo
{
    _liveWatchVideo = liveWatchVideo;
    
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray*)tpDataArray
{
    if (!_tpDataArray ) {
        _tpDataArray = [NSMutableArray array];
    }
    return _tpDataArray;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
