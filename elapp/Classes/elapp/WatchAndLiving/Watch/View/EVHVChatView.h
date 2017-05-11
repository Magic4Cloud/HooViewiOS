//
//  EVHVChatView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVHVChatView : UIView

@property (nonatomic, weak) UITableView *chatTableView;
- (void)inputTextChatMessage:(NSString *)str;

- (void)receiveSystemMessage:(NSString *)message;

- (void)receiveChatContent:(NSString *)content nickName:(NSString *)nickName isHistory:(BOOL)isHistory;
- (void)receiveChatContent:(NSString *)content nickName:(NSString *)nickName isHistory:(BOOL)isHistory extDic:(NSDictionary *)dic;
@end
