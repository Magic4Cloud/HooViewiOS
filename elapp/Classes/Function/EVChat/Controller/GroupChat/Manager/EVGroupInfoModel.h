//
//  EVGroupInfoModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "CCBaseObject.h"

@interface EVGroupInfoModel : CCBaseObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *infoText;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *detailText;
@property (copy, nonatomic) NSString *clazz;
@property (assign, nonatomic) BOOL vip;
@property (assign, nonatomic) BOOL isBlock;
@property (assign, nonatomic) BOOL isOwner;
@property ( strong, nonatomic ) NSArray *members;
@property (copy, nonatomic) NSString *name;






+(instancetype)modelWithTitle:(NSString *)title infoText:(NSString *)infoText icon:(NSString *)icon detailText:(NSString *)detailText clazz:(NSString *)clazz;

@end
