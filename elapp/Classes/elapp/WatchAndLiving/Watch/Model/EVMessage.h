//
//  EVMessage.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, EVMessageFrom) {
    EVMessageFromMe    = 0,   // 自己发的
    EVMessageFromOther = 1,    // 别人发得
    EVMessageFromSystem = 2
};

@interface EVMessage : NSObject
@property (nonatomic, assign) EVMessageFrom messageFrom;

@property (nonatomic, copy) NSString *contentStr;

@property (nonatomic, copy) NSString *nameStr;

- (void)setWithDict:(NSDictionary *)dict;

@end
