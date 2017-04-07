//
//  EVRecommendModel.h
//  elapp
//
//  Created by 唐超 on 4/7/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 牛人推荐model
 */
@interface EVRecommendModel : NSObject
@property (nonatomic, copy)NSString * id;
@property (nonatomic, copy)NSString * nickname;
@property (nonatomic, copy)NSString * avatar;
@property (nonatomic, copy)NSString * fellow;
/*"id": 9521,
 "nickname": "火眼财经小助手",
 "avatar": "https://wpimg.wallstcn.com/a87314bf-9182-4af4-b4df-4f3e94b51887",
 "fellow": 1234*/
@end
