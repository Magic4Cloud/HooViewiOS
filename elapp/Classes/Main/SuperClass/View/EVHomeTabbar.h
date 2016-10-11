//
//  EVHomeTabbar.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

#define CCHOMETABBAR_HEIGHT 50

#define HOMETABBAR_HEIGHT ( 250 * ScreenWidth / 1290.0 )

extern CGFloat const tabBarRealHeight;

typedef NS_ENUM(NSInteger, CCHomeTabbarButtonType) {
    CCHomeTabbarButtonTimeLine = 0,
    CCHomeTabbarButtonLetter   = 1,
    CCHomeTabbarButtonLive     = 2,
};

@protocol CCHomeTabbarDelegate <NSObject>

@optional
- (void)homeTabbarDidClicked:(CCHomeTabbarButtonType)btn;
- (void)homeTabbarDidClickedLiveButton;

@end


@interface EVHomeTabbar : UIView

@property (nonatomic,weak) id<CCHomeTabbarDelegate> delegate;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic,weak) NSLayoutConstraint *bottomConstraint;

- (void)hideTabbarWithAnimation;
- (void)showTabbarWithAnimation;

@end



@interface CCHomeTabbarContainer  : UITabBar

@property (nonatomic,weak) EVHomeTabbar *tabbar;
@property (nonatomic, assign) BOOL showRedPoint;

- (void)hideTabbarWithAnimation;
- (void)showTabbarWithAnimation;

@property (nonatomic, assign) NSInteger selectedIndex;

@end
