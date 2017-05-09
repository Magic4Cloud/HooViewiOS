//
//  EVHVChatView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVChatView.h"
#import "EVChatViewCell.h"
#import "EVHVChatModel.h"
#import "EVLoginInfo.h"
#import "UIWindow+Extension.h"
#import "EVtextLiveHChatCell.h"
#import "EVJoinChatCell.h"
@interface EVHVChatView ()<UITableViewDelegate,UITableViewDataSource, EVChatViewCellDelegate,EVtextLiveHChatCellDelegate>


@property (nonatomic, strong) EVHVChatModel *chatModel;
@end


@implementation EVHVChatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpViewFrame:frame];
    }
    return self;
}


- (void)receiveSystemMessage:(NSString *)message
{
    
    
//    NSDictionary *dict = @{@"contentStr":message};
//    [self.chatModel addSpecifiedItem:dict messageFrom:EVMessageFromSystem isHistory:NO];
//    [self.chatTableView reloadData];
//    [self tableViewScrollToBottom];
}


- (void)receiveChatContent:(NSString *)content nickName:(NSString *)nickName isHistory:(BOOL)isHistory
{
    if (nickName == nil || content == nil) {
        return;
    }
    if ([nickName isEqualToString:[EVLoginInfo localObject].nickname]) {
        NSDictionary *dict = @{@"contentStr":content,@"name":@"我"};
        [self.chatModel addSpecifiedItem:dict messageFrom:EVMessageFromMe isHistory:isHistory];
    }else {
        NSDictionary *dict = @{@"contentStr":content,@"name":nickName};
        [self.chatModel addSpecifiedItem:dict messageFrom:EVMessageFromOther isHistory:isHistory];
    }
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];

}

- (void)receiveChatContent:(NSString *)content nickName:(NSString *)nickName isHistory:(BOOL)isHistory extDic:(NSDictionary *)dic
{
    if (nickName == nil || content == nil) {
        return;
    }
    
    if ([nickName isEqualToString:[EVLoginInfo localObject].nickname]) {
//        NSDictionary *dict = @{@"contentStr":content,@"name":@"我"};
        NSMutableDictionary * tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [tempDic setValue:content forKey:@"contentStr"];
        [tempDic setValue:nickName forKey:@"name"];
        [self.chatModel addSpecifiedItem:tempDic messageFrom:EVMessageFromMe isHistory:isHistory];
    }else {
//        NSDictionary *dict = @{@"contentStr":content,@"name":nickName};
        NSMutableDictionary * tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [tempDic setValue:content forKey:@"contentStr"];
        [tempDic setValue:nickName forKey:@"name"];
        [self.chatModel addSpecifiedItem:tempDic messageFrom:EVMessageFromOther isHistory:isHistory];
    }
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
    
}

- (void)addUpViewFrame:(CGRect)frame
{
    self.chatModel = [[EVHVChatModel alloc] init];
    UITableView *chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, frame.size.height - 49) style:(UITableViewStylePlain)];
    chatTableView.delegate = self;
    chatTableView.dataSource = self;
    [self addSubview:chatTableView];
    chatTableView.backgroundColor = [UIColor evBackgroundColor];
    chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [chatTableView registerNib:[UINib nibWithNibName:@"EVJoinChatCell" bundle:nil] forCellReuseIdentifier:@"EVJoinChatCell"];
    _chatTableView = chatTableView;
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    UILabel * warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 40)];
    warningLabel.textColor = [UIColor evBackGroundDeepGrayColor];
    warningLabel.numberOfLines = 0;
    warningLabel.text = @"温馨提示：涉及色情，低俗，暴力等聊天内容将被封停账号。文明聊天，从我做起!";
    warningLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:warningLabel];
    chatTableView.tableHeaderView = headerView;
}

- (void)inputTextChatMessage:(NSString *)str
{
   
}

- (void)tableViewScrollToBottom
{
    if (self.chatModel.dataSource.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    EVChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
//    if (!cell) {
//        cell = [[EVChatViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"chatCell"];
//        cell.backgroundColor = [UIColor evBackgroundColor];
//    }
//    [cell setMessageCellModel:self.chatModel.dataSource[indexPath.row]];
//    cell.delegate = self;
//    return cell;
    
    EVHVMessageCellModel * model = self.chatModel.dataSource[indexPath.row];
    //    EVEaseMessageModel * model = self.chatModel.dataSource[indexPath.row];
    if (model.state == EVEaseMessageTypeStateGift || model.state == EVEaseMessageTypeStateJoin) {
        EVJoinChatCell * joinCell = [tableView dequeueReusableCellWithIdentifier:@"EVJoinChatCell"];
        joinCell.videoMessageModel = model;
        return joinCell;
    }

    
    EVtextLiveHChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatTextCell"];
    if (!cell) {
        cell = [[EVtextLiveHChatCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"chatTextCell"];
        cell.backgroundColor = [UIColor evBackgroundColor];
        cell.delegate = self;
    }
    cell.videoMessageModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

#pragma mark - EVChatViewCellDelegate
- (void)longPressCell:(EVChatViewCell *)cell easeModel:(EVEaseMessageModel *)easeModel {
    if ([cell.messageCellModel.message.nameStr isEqualToString:@"我"]) {
        return;
    }
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"是否举报" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alerController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        action;
    })];
    [alerController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [EVProgressHUD showSuccess:@"举报成功"];
        }];
        action;
    })];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIViewController *rootVC = [keyWindow visibleViewController];
    if (!rootVC) {
        rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    }
    [rootVC presentViewController:alerController animated:YES completion:nil];
}

@end
