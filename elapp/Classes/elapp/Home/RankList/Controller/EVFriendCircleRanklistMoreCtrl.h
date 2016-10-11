//
//  EVFriendCircleRanklistMoreCtrl.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVViewController.h"

#define kListTypeMoreAllSend        @"send"
#define kListTypeMoreAllReceive     @"receive"
#define kListTypeMoreWeekSend       @"weeksend"
#define kListTypeMoreWeekReceive    @"weekreceive"
#define kListTypeMoreMonthSend      @"monthsend"
#define kListTypeMoreMonthReceive   @"monthreceive"

@interface EVFriendCircleRanklistMoreCtrl : EVViewController

@property (nonatomic, copy) NSString *type;

@end
