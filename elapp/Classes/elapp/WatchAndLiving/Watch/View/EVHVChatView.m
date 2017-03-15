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

@interface EVHVChatView ()<UITableViewDelegate,UITableViewDataSource, EVChatViewCellDelegate>


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
    NSDictionary *dict = @{@"contentStr":message};
    [self.chatModel addSpecifiedItem:dict messageFrom:EVMessageFromSystem isHistory:NO];
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
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
- (void)addUpViewFrame:(CGRect)frame
{
    self.chatModel = [[EVHVChatModel alloc] init];
    UITableView *chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, frame.size.height - 49) style:(UITableViewStylePlain)];
    chatTableView.delegate = self;
    chatTableView.dataSource = self;
    [self addSubview:chatTableView];
    chatTableView.backgroundColor = [UIColor evBackgroundColor];
    chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _chatTableView = chatTableView;
    
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
    EVChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
    if (!cell) {
        cell = [[EVChatViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"chatCell"];
    }
    [cell setMessageCellModel:self.chatModel.dataSource[indexPath.row]];
    cell.delegate = self;
    cell.backgroundColor = [UIColor evBackgroundColor];
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
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:cell.messageCellModel.message.nameStr ? : @"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
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
