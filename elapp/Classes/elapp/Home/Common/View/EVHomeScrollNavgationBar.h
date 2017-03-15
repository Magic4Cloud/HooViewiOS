//
//  EVHomeScrollNavgationBar.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

@class EVHomeScrollNavgationBar;

#define CCHOMENAV_HEIGHT 64

typedef NS_ENUM(NSInteger, EVHomeScrollNavgationBarButton)
{
    EVHomeScrollNavgationBarEditButton = 100,
    EVHomeScrollNavgationBarSearchButton
};

@protocol CCHomeScrollNavgationBarDelegate <NSObject>

@optional
- (void)homeScrollNavgationBarDidClicked:(EVHomeScrollNavgationBarButton)btn;
- (void)homeScrollNavgationBarDidSeleceIndex:(NSInteger)index;
- (void)homeScrollViewUserDidMoveToPercent:(CGFloat)percent;
- (void)homeScrollNavgationBarDidDragToUpdateIndex:(NSInteger)index;

@end

@interface EVHomeScrollNavgationBar : UIView

@property (nonatomic, assign) CGFloat scrollPercent;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSArray *subTitles;

@property (nonatomic, assign) NSInteger selectedIndex;


@property (nonatomic,weak) id<CCHomeScrollNavgationBarDelegate> delegate;

@property (nonatomic, strong) NSLayoutConstraint *centerTopConstraint;

- (instancetype)initWithSubTitles:(NSArray *)subTitles;


@property (nonatomic,weak) NSLayoutConstraint *topConstraint;
- (void)hideHomeNavigationBar;
- (void)showHomeNavigationBar;


@end
