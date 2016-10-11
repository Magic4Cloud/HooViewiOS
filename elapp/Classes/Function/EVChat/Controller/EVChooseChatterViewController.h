//
//  EVChooseChatterViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//
#import "EVViewController.h"
#import "EVEaseMob.h"

@protocol CCChooseChatterDelegate <NSObject>

@optional

/**
 *  转发完成后调用的回调方法
 *
 *  @param message 转发的信息
 */
- (void)relayCompleteMessage:(EMMessage *)message;

@end

@interface EVChooseChatterViewController : EVViewController

@property ( weak, nonatomic ) UITableView *tableView;                               // 联系人列表
@property (nonatomic, strong) UISearchDisplayController *mySearchDisplaycontroller; // 搜索控制器

@property ( strong, nonatomic ) NSArray *relayMsgBodies;                            // 转发的消息体
@property ( strong, nonatomic ) NSDictionary *ext;                                  // 扩展信息
@property ( weak, nonatomic ) id<CCChooseChatterDelegate> delegate;                 // 委托对象
@property (copy, nonatomic) NSString *placeHolder;                                  // 搜索框的提示文本

/**
 *  加载数据(供子类重载)
 */
- (void)loadData;

/**
 *  转发消息(供子类重载)
 *
 *  @param msg 要转发的消息
 */
- (void)relayMessage:(EMMessage *)msg;

@end
