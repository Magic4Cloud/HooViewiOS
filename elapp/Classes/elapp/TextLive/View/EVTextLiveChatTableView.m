//
//  EVTextLiveChatTableView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/23.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVTextLiveChatTableView.h"
#import "EVChatViewCell.h"
#import "NSString+Extension.h"

@interface EVTextLiveChatTableView ()<UITableViewDelegate,UITableViewDataSource,EVChatViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak) UILabel *watchLabel;

@end



@implementation EVTextLiveChatTableView

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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVEaseMessageModel *model = self.dataArray[indexPath.row];
    return model.chatCellHight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatTextCell"];
    if (!cell) {
        cell = [[EVChatViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"chatTextCell"];
        cell.delegate = self;
    }
    
    cell.easeMessageModel = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor evBackgroundColor];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tDelegate && [self.tDelegate respondsToSelector:@selector(tableViewDidScroll:)]) {
        [self.tDelegate tableViewDidScroll:scrollView];
    }
}

#pragma mark - 长按回复
- (void)longPressCell:(EVChatViewCell *)cell easeModel:(EVEaseMessageModel *)easeModel
{
    if (self.tDelegate && [self.tDelegate respondsToSelector:@selector(longPressModel:)]) {
        [self.tDelegate longPressModel:easeModel];
    }
}

- (NSString *)stringWithData
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

- (void)updateMessageModel:(EVEaseMessageModel *)model
{
    if (model.bodyType == EMMessageBodyTypeText) {
        [self.dataArray addObject:model];
        [self reloadData];
        if (self.dataArray.count == 0) return;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


- (void)updateHistoryArray:(NSMutableArray *)array
{
    for (EVEaseMessageModel *model in array) {
        [self.dataArray insertObject:model atIndex:0];
    }
    [self reloadData];
    if (self.dataArray.count == 0) return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)updateWatchCount:(NSInteger)count
{
     self.watchLabel.text = [NSString stringWithFormat:@"%@人数",[NSString numFormatNumber:count]];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
