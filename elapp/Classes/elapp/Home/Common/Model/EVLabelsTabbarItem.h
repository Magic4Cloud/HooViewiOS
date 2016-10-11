//
//  EVLabelsTabbarItem.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVLabelsTabbarItem : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) BOOL viewLoadFinish;

@end
