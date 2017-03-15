//
//  EVHomeTabbar.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const HOMETABBAR_HEIGHT;

typedef NS_ENUM(NSInteger, EVHomeTabbarButtonType)
{
    EVHomeTabbarButtonActivity = 0,
    EVHomeTabbarButtonTimeLine = 1,
    EVHomeTabbarButtonLive = 5,
    EVHomeTabbarButtonFriendCircle = 2,
    EVHomeTabbarButtonLetter = 3
};

@protocol EVHomeTabbarDelegate <NSObject>

@optional
- (void)homeTabbarDidClicked:(EVHomeTabbarButtonType)btn;
- (void)homeTabbarDidClickedLiveButton;
- (void)homeTabbarDicDoubleClick:(EVHomeTabbarButtonType)type;

@end


/** 底部 Tab 视图容器 */
@interface EVHomeTabbar : UIView

@property (nonatomic,weak) id<EVHomeTabbarDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)hideTabbarWithAnimation:(void(^)())complete;
- (void)showTabbarWithAnimation:(void(^)())complete;

@end


/** 底部 Tab 容器 */
@interface EVHomeTabbarContainer  : UITabBar

@property (nonatomic, weak) EVHomeTabbar *tabbar;
@property (nonatomic, assign) BOOL showRedPoint;
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)hideTabbarWithAnimation;
- (void)showTabbarWithAnimation;

@end
