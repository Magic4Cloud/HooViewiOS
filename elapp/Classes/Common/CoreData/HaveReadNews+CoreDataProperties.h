//
//  HaveReadNews+CoreDataProperties.h
//  elapp
//
//  Created by 唐超 on 5/11/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "HaveReadNews+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface HaveReadNews (CoreDataProperties)

+ (NSFetchRequest<HaveReadNews *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *newsid;

@end

NS_ASSUME_NONNULL_END
