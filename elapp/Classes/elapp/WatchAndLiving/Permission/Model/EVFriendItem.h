//
//  EVFriendItem.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVFriend.h"

@interface EVFriendItem : EVFriend

@property (assign, nonatomic) BOOL selected; /**< 是否选中 */
/** 拼音 */
@property (nonatomic,copy) NSString *pinyin;

@property (nonatomic,strong) NSIndexPath *indexPathInSearch;

@property (assign, nonatomic) BOOL disable;

/** 环信号 */
@property (copy, nonatomic) NSString *im_user;
@end
