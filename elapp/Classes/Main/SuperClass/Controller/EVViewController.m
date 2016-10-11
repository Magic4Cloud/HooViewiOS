//
//  EVViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVViewController.h"
#import "AppDelegate.h"
#import <Bugly/BuglyLog.h>

@interface EVViewController()< UIGestureRecognizerDelegate, UINavigationControllerDelegate>

/** 引导图 */
@property (nonatomic, weak) UIView *coverView;

/** 点击移除引导图 */
@property (nonatomic, weak) UIButton *coverGestureGuide;


@end

@implementation EVViewController

#pragma mark - instance methods

- (void)addGestureGuideCoverviewWithImageNamed:(NSString *)imageNamed
{
    if (![CCUserDefault boolForKey:imageNamed])
    {
        [CCUserDefault setBool:YES forKey:imageNamed];
        
        AppDelegate *AppD = [UIApplication sharedApplication].delegate;
        UIView *coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0.7;
        [AppD.window addSubview:coverView];
        self.coverView = coverView;
        
        UIButton *coverGestureGuide = [[UIButton alloc] initWithFrame:coverView.bounds];
        [coverGestureGuide setBackgroundImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
        [coverGestureGuide addTarget:self action:@selector(hideCoverImageView) forControlEvents:UIControlEventTouchUpInside];
        [AppD.window addSubview:coverGestureGuide];
        _coverGestureGuide = coverGestureGuide;
    }
}

- (void)hideCoverImageView
{
    [self.coverView removeFromSuperview];
    [self.coverGestureGuide removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor evBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor evBackgroundColor];
    if (self.navigationController)
    {
        // fix by 马帅伟 测试 这行代码 放在 viewdidload 里面会有什么后果(改到这里面了，暂时没发现什么问题)
        // 20160127 记起：之所以把设置左侧按钮写在 viewWillAppear: 中，是因为在 viewDidLoad 中拿到的 self.navigationController 可能为空
        [self setLeftItem];
    }
    
    if ( !IOS8_OR_LATER &&
        self.navigationController )
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        return;
    }
    
    //    CCLog(@"--^@^--self.navigationController.viewControllers.count:%@,%ld", NSStringFromClass([self class]), self.navigationController.viewControllers.count);
    // 重新设置代理，防止从pop出来的控制器，导航控制器的手势丢失代理引起crash
    if ( self.navigationController )
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    BLYLogWarn(@"instance = %@", self);
    if ([self respondsToSelector:@selector(hideCoverImageView)])
    {
        [self hideCoverImageView];
    }
}

- (void)setLeftItem
{
    // 添加是否是navigationController的rootViewController，如果是，则把左侧返回按钮给替换掉空白view
    if ( self.navigationController.viewControllers.count > 1 )
    {
        self.navigationItem.leftBarButtonItem = self.cc_leftBarButtonItem;
    }
}

- (UIBarButtonItem *)cc_leftBarButtonItem
{
    if ( _cc_leftBarButtonItem == nil )
    {
        UIButton *backBtn = [[UIButton alloc] initWithTitle:kGlobalBackButtonTitle];
        CGRect frame = backBtn.bounds;
        frame.size.width = 17.0f * 4;
        backBtn.bounds = frame;
        [backBtn setImage:[UIImage imageNamed:@"nav_icon_return"] forState:UIControlStateNormal];
        backBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        backBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [backBtn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
        _cc_leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    }
    return _cc_leftBarButtonItem;
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecogiserDelegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CCLog(@"-------gestureRecognizer--------");
    if ( !IOS8_OR_LATER )
    {
        return NO;
    }
    
//    CCLog(@"-*-^@^--self.navigationController.viewControllers.count:%@,%ld", NSStringFromClass([self class]), self.navigationController.viewControllers.count);
    // 导航控制器的子控制器的个数为1时，则不再响应手势
    if ( [self.navigationController.viewControllers count] <= 1 )
    {
        return NO;
    }
    
    return YES;
}

@end
