//
//  EVCheatsModel.h
//  elapp
//
//  Created by 唐超 on 4/19/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 秘籍 model
 */
@interface EVCheatsModel : NSObject
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * userid;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * introduce;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * salesCount;

@end
