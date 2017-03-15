//
//  EVSearchResultModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVBaseObject.h"

@interface EVSearchResultModel : EVBaseObject

@property (assign, nonatomic) NSUInteger user_start; /**< 用户开始项 */
@property (assign, nonatomic) NSUInteger user_count; /**< 用户总数 */
@property (assign, nonatomic) NSUInteger user_next; /**< 用户下一页开始项 */
@property (strong, nonatomic) NSMutableArray *videos; /**< 用户信息列表 */
@property (nonatomic, strong) NSMutableArray *news;
@property (nonatomic, strong) NSMutableArray *data;

@end
