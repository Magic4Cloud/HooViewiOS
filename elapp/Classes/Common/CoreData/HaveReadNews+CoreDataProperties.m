//
//  HaveReadNews+CoreDataProperties.m
//  elapp
//
//  Created by 唐超 on 5/11/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "HaveReadNews+CoreDataProperties.h"

@implementation HaveReadNews (CoreDataProperties)

+ (NSFetchRequest<HaveReadNews *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"HaveReadNews"];
}

@dynamic newsid;

@end
