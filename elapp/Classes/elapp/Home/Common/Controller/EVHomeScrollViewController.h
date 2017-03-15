//
//  EVHomeScrollViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVHomeScrollNavgationBar.h"

@protocol EVHomeScrollViewControllerProtocol <NSObject>

@required
- (void)homeScrollViewControllerShowBar;
- (void)homeScrollViewControllerHideBar;

@end

@interface EVHomeScrollViewController : UIViewController <EVHomeScrollViewControllerProtocol>

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) BOOL listenerScrollState;

@property (nonatomic,weak) UIScrollView *scrollView;
/**
 *  控制器的总标题, 必须实现
 *
 */
- (NSString *)showTitle;

/**
 *  子类实现此方法，表明改控制器要包含那类子控制器, 必须实现
 *
 */
- (NSArray *)currChildrenViewControllers;

/**
 *  子类实现此方法点击个人中心头像或者搜索
 *
 */
- (void)homeScrollNavgationBarDidClicked:(EVHomeScrollNavgationBarButton)btn;

- (void)homeScrollViewDidScroll;

// 默认选中哪一页
- (NSInteger)defaultSelectedIndex;

- (void)homeScrollViewControllerHideBar;
- (void)homeScrollViewControllerShowBar;

- (void)homeScrollNavgationBarDidSeleceIndex:(NSInteger)index;

@end
