//
//  EVStartPageViewController.m
//  elapp
//
//  Created by 唐超 on 3/27/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVStartPageViewController.h"

@interface EVStartPageViewController ()
{
    NSInteger count;
}

/**
 背景图  固定的一张图
 */
@property (nonatomic, strong)UIImageView * topImageView;
@property (nonatomic, strong)UIView * bottomView;
@property (nonatomic, strong)UILabel * cpLabel;
@property (nonatomic, strong)UIButton * skipButton;

@property (nonatomic, strong)NSTimer * timer;
@end

@implementation EVStartPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    
    [self.view addSubview:self.topImageView];
    [self.topImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.topImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.topImageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.topImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.bottomView];
    self.topImageView.backgroundColor = [UIColor lightGrayColor];
    count = 3;
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerCount:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}
- (void)initData
{
    self.cpLabel.text = @"Copyright © 2017 HooView";
}
#pragma mark - private methods
- (void)timerCount:(NSTimer *)tim
{
    NSLog(@"定时器在走");
    if (count == 0)
    {
        [self.view removeFromSuperview];
        [tim invalidate];
        tim = nil;
        [self.skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        self.skipButton.enabled = YES;
    }
    else
    {
        self.skipButton.enabled = NO;
        [self.skipButton setTitle:[NSString stringWithFormat:@"%ldS",count] forState:UIControlStateNormal];
    }
    count -- ;
}

- (void)skipButtonClick:(UIButton *)button
{
    [self.view removeFromSuperview];
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - getters
- (UIImageView * )topImageView
{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
    }
    return _topImageView;
}

- (UILabel *)cpLabel
{
    if (!_cpLabel) {
        _cpLabel = [[UILabel alloc] init];
        _cpLabel.font = [UIFont systemFontOfSize:11];
        _cpLabel.textColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0];
        _cpLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cpLabel;
}

- (UIButton *)skipButton
{
    if (!_skipButton) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.layer.cornerRadius = 15;
        _skipButton.layer.borderWidth = 1;
        _skipButton.layer.borderColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0].CGColor;
        _skipButton.layer.masksToBounds = YES;
        [_skipButton setTitleColor:[UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0] forState:UIControlStateNormal];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _skipButton.enabled = NO;
        [_skipButton addTarget:self action:@selector(skipButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _skipButton;
}
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        CGFloat height = ScreenWidth / 2.975;
        _bottomView.frame = CGRectMake(0, ScreenHeight - height, ScreenWidth, height);
        _bottomView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        
        UIImageView * imageView = [[UIImageView alloc] init];
        [_bottomView addSubview:imageView];
        [imageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40];
        [imageView autoSetDimensionsToSize:CGSizeMake(130, 33)];
        imageView.backgroundColor = [UIColor greenColor];
        
        [_bottomView addSubview:self.cpLabel];
        [self.cpLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.cpLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:imageView withOffset:10];
        
        [_bottomView addSubview:self.skipButton];
        [self.skipButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:18];
        [self.skipButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:18];
        [self.skipButton autoSetDimensionsToSize:CGSizeMake(62, 30)];
    
    }
    return _bottomView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
