//
//  EVStartPageViewController.m
//  elapp
//
//  Created by 唐超 on 3/27/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVStartPageViewController.h"
#import "EVBaseToolManager.h"
#import "EVHttpURLManager.h"
#import "EVStartPageModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface EVStartPageViewController ()
{
    NSInteger count;
}

/**
 广告图
 */
@property (nonatomic, strong)UIImageView * topImageView;
@property (nonatomic, strong)UIView * bottomView;
@property (nonatomic, strong)UILabel * cpLabel;
@property (nonatomic, strong)UIButton * skipButton;

@property (nonatomic, strong)NSTimer * timer;

@property (nonatomic, strong)EVStartPageModel * startModel;
@property (nonatomic, strong)UIImage * adImage;
@end

@implementation EVStartPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self initData];
    
    [self requestData];
    
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
    count = 3;
    
    
}
- (void)initData
{
    self.cpLabel.text = @"Copyright © 2017 HooView";
}

#pragma mark - private methods

- (void)requestData
{
    
//    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVAPPSTARTAPI  params:nil];
    NSString * urlString = @"http://openapi.hooview.com/api/ad/appstart";
    __weak typeof(self) weakSelf = self;
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:nil success:^(NSDictionary *successDict) {
        weakSelf.startModel = [[EVStartPageModel alloc] initModelWithDic:successDict];
        
    } sessionExpireBlock:^{
        [self loadDefaultImage];
    } fail:^(NSError *error) {
        [self loadDefaultImage];
    }];
}

- (void)loadDefaultImage
{
    self.skipButton.hidden = YES;
    self.topImageView.image = [UIImage imageNamed:@"startPageDefaultImage"];
    [self performSelector:@selector(dismissSelf) withObject:nil afterDelay:2];
}
- (void)dismissSelf
{
    [self.view removeFromSuperview];
}
- (void)isLoadDefaultImage
{
    //如果时间到了  还没有请求到图片  则使用默认图片
    if (self.adImage == nil) {
        [self loadDefaultImage];
    }
}
- (void)setStartModel:(EVStartPageModel *)startModel
{
    _startModel = startModel;
    if (startModel.adurl.length>0) {
        if (startModel.starttime.length>0 && startModel.endtime.length>0) {
            NSDate * date = [NSDate date];
            NSTimeInterval timeInterval = [date timeIntervalSince1970];
            if (timeInterval > [startModel.starttime doubleValue] && timeInterval < [startModel.endtime doubleValue])
            {
                [self.topImageView sd_setImageWithURL:[NSURL URLWithString:_startModel.adurl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    _adImage = image;
                    [self timerBegin];
                    
                }];
                [self performSelector:@selector(isLoadDefaultImage) withObject:nil afterDelay:2];
            }
        }
    }
    //如果后台没上传 就使用默认图
    else
    {
        [self loadDefaultImage];
    }
    
}

- (void)timerCount:(NSTimer *)tim
{
    self.skipButton.hidden = NO;
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

- (void)timerBegin
{
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerCount:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
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
        _skipButton.hidden = YES;
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
        imageView.image = [UIImage imageNamed:@"startPagelogo"];
        
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
