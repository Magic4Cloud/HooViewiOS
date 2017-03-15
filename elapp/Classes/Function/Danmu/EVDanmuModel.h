//
//  EVDanmuModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface EVDanmuModel : NSObject

@property (assign, nonatomic) NSInteger anchor_level;

@property (strong, nonatomic) NSString * content;

@property (assign, nonatomic) NSInteger level;

@property (strong, nonatomic) NSString * logo;

@property (strong, nonatomic) NSString * name;

@property (strong, nonatomic) NSString * nickname;

@property (assign, nonatomic) NSInteger type;

@property (assign, nonatomic) NSInteger vip_level;

//用火眼财经的API直接可以用
+ (EVDanmuModel *)modelFromDictionary:(NSDictionary *)dic comment:(NSString *)comment;

@end
