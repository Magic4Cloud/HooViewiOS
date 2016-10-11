//
//  EVGroupInfoViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVViewController.h"

/**
 *  >>本类作用：群组资料信息
 */
@interface EVGroupInfoViewController : EVViewController

@property (copy, nonatomic) NSString *groupID;

@property (assign, nonatomic) BOOL hasLoadInfo; // 已经加载群组信息

/**
 *  @author 范鹏
 *
 *  清空聊天记录的回调
 *
 *  @param clear 
 */
- (void)setClearMessageSucceed:(void(^)())clear;

@end
