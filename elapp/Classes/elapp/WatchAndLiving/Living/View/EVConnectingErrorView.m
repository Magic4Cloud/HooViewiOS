//
//  EVConnectingErrorView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVConnectingErrorView.h"
#import "UIImageView+LBBlurredImage.h"
#import <PureLayout.h>

#define ksignalImagesParrten @"%dmonday_emoji"
#define ksignalImagesCount 7
#define ksignalTitle kE_GlobalZH(@"network_poor_change_milieu") 

@interface EVConnectingErrorView ()
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *animationImageView;

@property (weak, nonatomic) IBOutlet UILabel *connectInfoLabel;

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@property (nonatomic, strong) NSArray *signalAnimationArray;

@property (nonatomic,strong) CABasicAnimation *animation;

@property (nonatomic, assign) BOOL contentHasShow;          /**< 是否已经开始 */

@property (nonatomic, assign) BOOL isAnimating;             /**< 动画是否正在执行 */

@end

@implementation EVConnectingErrorView

- (void)dealloc
{
    [_animationImageView.layer removeAllAnimations];
    _animationImageView = nil;
    _backGroundImageView = nil;
    [self removeObserver];
}

+ (instancetype)connectingErrorView
{
    return [[self alloc] init];
}

- (NSArray *)signalAnimationArray
{
    if ( _signalAnimationArray == nil )
    {
        NSMutableArray *signalAnimationArray = [NSMutableArray arrayWithCapacity:ksignalImagesCount];
        
        for (NSInteger i = 0; i < ksignalImagesCount; i++)
        {
            NSString *imageFilePath = [NSString stringWithFormat:ksignalImagesParrten, i + 1];
            UIImage *connetErrorImage = [UIImage imageNamed:imageFilePath];
            if (connetErrorImage)
            {
                [signalAnimationArray addObject:connetErrorImage];
            }
        }
        _signalAnimationArray = signalAnimationArray;
    }
    return _signalAnimationArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    UIImageView *backGroundImageView = [[UIImageView alloc] init];
    [self addSubview:backGroundImageView];
    [backGroundImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.backGroundImageView = backGroundImageView;
    
    CGFloat imageW = 414.0;
    
    CGFloat animationImageViewWH = cc_absolute_size_x(70, imageW);
    
    UIImageView *animationImageView = [[UIImageView alloc] init];
    animationImageView.image = self.signalAnimationArray[0];
    [self addSubview:animationImageView];
    [animationImageView autoCenterInSuperview];
    [animationImageView autoSetDimensionsToSize:CGSizeMake(animationImageViewWH, animationImageViewWH)];
    self.animationImageView = animationImageView;
    
    UIColor *textColor = [UIColor whiteColor];
    CGFloat connectInfoLabelFontSize = 12;
    
    UILabel *connectInfoLabel = [[UILabel alloc] init];
    connectInfoLabel.textAlignment = NSTextAlignmentCenter;
    connectInfoLabel.textColor = textColor;
    connectInfoLabel.font = [UIFont systemFontOfSize:connectInfoLabelFontSize];
    [self addSubview:connectInfoLabel];
    [connectInfoLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [connectInfoLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:animationImageView withOffset:20];
    self.connectInfoLabel = connectInfoLabel;
    
    self.animationImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.backGroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.userInteractionEnabled = NO;
    
    [self setUpObserver];
    [self setUpAnimation];
}

- (UIImage *)defaultAnimationImage
{
    if ( _defaultAnimationImage == nil )
    {
        _defaultAnimationImage = [UIImage imageNamed:@"live_loading_background"];
    }
    return _defaultAnimationImage;
}

- (void)setUpObserver
{
    [self addObserver:self forKeyPath:@"percent" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver
{
    [self removeObserver:self forKeyPath:@"percent"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ( !self.hidden )
    {
        if ( self.percent > 0 )
        {
            int percentTemp = self.percent;
            // 大于等于100时都等于100
            if ( self.percent >= 100 )
            {
                percentTemp = 100;
            }
            self.connectInfoLabel.text = [NSString stringWithFormat:@"%@ %d %%",kE_GlobalZH(@"loading_strive"), percentTemp];
        }
    }
}

- (void)startAnimationWithTitle:(NSString *)title
{
    self.hidden = NO;
    if ( self.contentHasShow )
    {
        self.connectInfoLabel.text = [NSString stringWithFormat:kE_GlobalZH(@"optimization_network")];
    }
    else
    {
         NSString *title = kE_GlobalZH(@"connection_server");
        self.connectInfoLabel.text = title;
        
    }
    
    [self.animationImageView startAnimating];
    [self.backGroundImageView setImageToBlur:self.defaultAnimationImage completionBlock:nil];
}

- (void)stopAnimation
{
    self.contentHasShow = YES;
    self.backGroundImageView.image = nil;
    [self.animationImageView stopAnimating];
    self.hidden = YES;
}

- (void)setUpAnimation
{
    [self.animationImageView setAnimationImages:self.signalAnimationArray];
    [self.animationImageView setAnimationDuration:4.0];
    [self.animationImageView setAnimationRepeatCount:-1];
}

@end
