//
//  EVEnterAnimationView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>


typedef enum{
    EnterLevelNone=0,
    EnterLevelOne,
    EnterLevelTwo,
    EnterLevelThree,
    EnterLevelFour,
    EnterLevelFive,
    EnterLevelSix
}EnterLevelType;
@interface EVEnterAnimationView : UIView
@property (nonatomic)EnterLevelType enterLevelType;
- (void)enterAnimation:(NSArray *)name;
@end
