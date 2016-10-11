//
//  EVHomeTabBarItem.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVHomeTabBarItem.h"
#import "EVNotifyViewController.h"
#import "EVMineViewController.h"
#import "EVNavigationController.h"

#define kFocusCircleControllerImage @"home_tabbar_icon_guangchang"
#define kSqureViewControllerImage @"home_tabbar_icon_guangchang"
#define kNotifyViewControllerImage @"home_tabbar_icon_guangchang"
#define kMineViewControllerImage @"home_tabbar_icon_guangchang"

#define kHomeTabEmail @"home_tab_email"
#define kHomeTabMine @"home_tab_my"
#define kHomeTabStar @"home_tab_plaza"


@implementation EVHomeTabBarItem

- (instancetype)initWithController:(UIViewController *)controller
{
    if ( self = [super init] )
    {
        self.controller = controller;
        NSString *norImageName = nil;
        NSString *selectImageName = nil;
        
        if ( [controller isKindOfClass:[EVNavigationController class]] )
        {
            EVNavigationController *nav = (EVNavigationController *)controller;
            controller = nav.topViewController;
        }
        
        if ( [controller isKindOfClass:[EVNotifyViewController class]] )
        {
//            norImageName = [NSString stringWithFormat:@"%@_nor",kHomeTabEmail];
            selectImageName = [NSString stringWithFormat:@"%@_select",kHomeTabEmail];
        }
        else if ( [controller isKindOfClass:[EVMineViewController class]] )
        {
            norImageName = [NSString stringWithFormat:@"%@_nor",kHomeTabMine];
            selectImageName = [NSString stringWithFormat:@"%@_select",kHomeTabMine];
        }
        if ( norImageName )
        {
            self.image = [UIImage imageNamed:norImageName];
        }
        
        if ( selectImageName )
        {
            self.selectedImage = [UIImage imageNamed:selectImageName];
        }

        controller.tabBarItem = self;
    }
    return self;
}

+ (instancetype)homeTabBarItemWithController:(UIViewController *)controller{
    return [[self alloc] initWithController:controller];
}

@end
