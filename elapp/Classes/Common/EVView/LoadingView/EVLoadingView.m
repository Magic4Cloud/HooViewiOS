//
//  EVLoadingView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVLoadingView.h"
#import "PureLayout.h"

#define kImageWid 70


@interface EVLoadingView ()

@property (nonatomic,strong)UIImageView *failedImageView;
@property (nonatomic,strong)UILabel *failedLabel;

@property (nonatomic,weak)UITapGestureRecognizer *tapGesture;

// 点击感叹号的block。
@property (nonatomic, copy) ClickBlock clickBlock;

@end


@implementation EVLoadingView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.activityIndicator];
        [self addSubview:self.failedImageView];
        [self.failedImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.failedImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.failedImageView autoSetDimensionsToSize:CGSizeMake(kImageWid, kImageWid)];
        [self addSubview:self.failedLabel];
        
        [self.failedLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.failedLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.failedImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self.failedImageView addGestureRecognizer:tap];
        _tapGesture = tap;
    }
    return self;
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (_activityIndicator == 0) {
        
        _activityIndicator = [[UIActivityIndicatorView alloc]init];
        _activityIndicator.frame =CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    return _activityIndicator;
}

- (UIImageView *)failedImageView
{
    if (!_failedImageView) {
        _failedImageView = [[UIImageView alloc]init];
//        _failedImageView.frame = CGRectMake(ScreenWidth/2 - 35, ScreenHeight/2 - 105, 70, 70);
        _failedImageView.backgroundColor = [UIColor whiteColor];
        _failedImageView.image = [UIImage imageNamed:@"all_load_nor"];
        _failedImageView.hidden = YES;
        _failedImageView.userInteractionEnabled = YES;
        
    }
    return _failedImageView;
}

- (UILabel *)failedLabel
{
    if (!_failedLabel) {
        _failedLabel = [[UILabel alloc]init];
        _failedLabel.text = @"网络不给力\n请点击重新加载";
//        _failedLabel.frame = CGRectMake(0,ScreenHeight/2-35,ScreenWidth,30);
        _failedLabel.font = [[EVAppSetting shareInstance] normalFontWithSize:12];
        _failedLabel.numberOfLines = 0;
        _failedLabel.backgroundColor = [UIColor whiteColor];
        _failedLabel.textAlignment = NSTextAlignmentCenter;
        _failedLabel.hidden = YES;
        // 布局显示文字的label
    }
    return _failedLabel;
}

- (void)showLoadingView
{
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
    self.hidden = NO;
}

- (void)destroy
{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    self.hidden = YES;
}

- (void)tap
{
    
    if (self.clickBlock) {
        self.clickBlock();
    }
    
}

- (void)showFailedViewWithClickBlock:(ClickBlock)block;
{
    self.activityIndicator.hidden = YES;
    self.failedImageView.hidden = NO;
    self.failedLabel.hidden = NO;
    if ( block )
    {
        self.clickBlock = block;
    }
}
- (void)setFailTitle:(NSString *)failTitle
{
    _failTitle = failTitle;
    if (self.failTitle != nil) {
        self.failedLabel.text = failTitle;
    }else{
      self.failedLabel.text = @"网络不给力\n请点击重新加载";
    }
}
// 本视图被销毁时调用
- (void)dealloc
{
    EVLog(@"%@ dealloc", NSStringFromClass([self class]));
    _clickBlock = nil;
}

@end
