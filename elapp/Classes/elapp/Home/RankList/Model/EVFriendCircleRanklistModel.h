//
//  EVFriendCircleRanklistModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "CCBaseObject.h"
#import "EVUserModel.h"

@interface CCFriendCircleRanklistSendModel : CCBaseObject

@property (nonatomic, copy) NSString      *costecoin;
@property (nonatomic, copy) NSString      *name;
@property (nonatomic, copy) NSString      *logourl;
@property (nonatomic, copy) NSString      *gender;
@property (nonatomic, copy) NSString      *nickname;
@property (nonatomic, assign) NSInteger   uid;
@property (nonatomic, assign) BOOL        vip;


@property (copy, nonatomic) NSString *birthday;             /**< 生日 */

@end

@interface CCFriendCircleRanklistReceiveModel : CCBaseObject

@property (nonatomic, copy) NSString   *riceroll;
@property (nonatomic, copy) NSString   *name;
@property (nonatomic, copy) NSString   *logourl;
@property (nonatomic, copy) NSString   *gender;
@property (nonatomic, copy) NSString   *nickname;
@property (nonatomic, assign) NSInteger   uid;
@property (nonatomic, assign) BOOL        vip;


@property (copy, nonatomic) NSString *birthday;             /**< 生日 */


@end


@interface EVFriendCircleRanklistModel : CCBaseObject

@property (nonatomic, strong) NSMutableArray *send_rank_list;
@property (nonatomic, strong) NSMutableArray *receive_rank_list;




@property (nonatomic, copy) NSString   *start; //列表开始项
@property (nonatomic, assign) NSInteger count; //排行上榜人数
@property (nonatomic, assign) NSInteger next; //列表下一页开始

@end
