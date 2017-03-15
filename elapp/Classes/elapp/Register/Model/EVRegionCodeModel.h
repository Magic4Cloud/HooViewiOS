//
//  EVRegionCodeModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseObject.h"

@interface EVRegionCodeModel : EVBaseObject

@property (nonatomic, copy) NSString *area_code;
@property (nonatomic, copy) NSString *contry_name;
@property (nonatomic, copy) NSString *sort;

@end


@interface CCRegionCodeGroup : EVBaseObject

@property (nonatomic,copy) NSString *group_name;
@property (nonatomic,strong) NSArray *items;

+ (NSArray *)regionCodeGroups;

@end
