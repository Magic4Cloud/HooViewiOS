//
//  EVHomeScrollNavgationBar.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EVHeaderView.h"

@class EVHomeScrollNavgationBar;

#define CCHOMENAV_HEIGHT 65

typedef NS_ENUM(NSInteger, CCHomeScrollNavgationBarButton)
{
    CCHomeScrollNavgationBarIconButton = 100,
    CCHomeScrollNavgationBarSearchButton
};

@protocol CCHomeScrollNavgationBarDelegate <NSObject>

@optional
- (void)homeScrollNavgationBarDidClicked:(CCHomeScrollNavgationBarButton)btn;
- (void)homeScrollNavgationBarDidSeleceIndex:(NSInteger)index;
- (void)homeScrollViewUserDidMoveToPercent:(CGFloat)percent;
- (void)homeScrollNavgationBarDidDragToUpdateIndex:(NSInteger)index;

@end

@interface EVHomeScrollNavgationBar : UIView

@property (nonatomic, assign) CGFloat scrollPercent;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSArray *subTitles;

@property (nonatomic, assign) NSInteger selectedIndex;
//用户头像
@property (nonatomic, strong) EVHeaderButton *personalButton;

@property (nonatomic,weak) id<CCHomeScrollNavgationBarDelegate> delegate;

@property (nonatomic, strong) NSLayoutConstraint *centerTopConstraint;

- (instancetype)initWithSubTitles:(NSArray *)subTitles;


@property (nonatomic,weak) NSLayoutConstraint *topConstraint;
- (void)hideHomeNavigationBar;
- (void)showHomeNavigationBar;


@end
