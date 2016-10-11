//
//  EVRegionCodeModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "CCBaseObject.h"

@interface EVRegionCodeModel : CCBaseObject

@property (nonatomic, copy) NSString *area_code;
@property (nonatomic, copy) NSString *contry_name;
@property (nonatomic, copy) NSString *sort;

@end


@interface CCRegionCodeGroup : CCBaseObject

@property (nonatomic,copy) NSString *group_name;
@property (nonatomic,strong) NSArray *items;

+ (NSArray *)regionCodeGroups;

@end
