//
//  EVAudienceLoveView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVAudienceLoveView.h"
#import "EVStartResourceTool.h"
#import <PureLayout.h>
#import "NSString+Extension.h"

#define LIKE_IMAGE_W 30
#define LIKE_IMAGE_H 30

#define PRESENT_QUQUESIZE 3

#define LIKE_ANIMATION_KEYPATH          @"LIKE_ANIMATION_KEYPATH"
#define PRESENT_ANIMATION_KEYPATH       @"PRESENT_ANIMATION_KEYPATH"

@interface CCAudiencePrecentItem : NSObject<CAAnimationDelegate>

@property (nonatomic,strong) NSNumber *presentid;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIBezierPath *path;

@property (nonatomic,strong) CAAnimationGroup *animationGroup;

@property (nonatomic, assign) NSInteger animationCount;

@end

@implementation CCAudiencePrecentItem

- (void)dealloc
{
    [_imageView.layer removeAllAnimations];
}

- (instancetype)initWithImage:(UIImage *)image
{
    if ( self = [super init] )
    {
        _image = image;
        _imageView = [self getImageViewWithImage:image];
    }
    return self;
}

- (UIImageView *)getImageViewWithImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}


- (void)setUpAnimation
{
#ifdef CCDEBUG
    assert(self.path);
#endif
    if ( self.animationGroup )
    {
        return;
    }
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = self.path.CGPath;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim.fromValue = @1.0f;
    anim.toValue = @1.0f;
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = @1.0;
    scale.toValue = @2.5;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    group.animations = @[anim, animation , scale];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = YES;
    group.duration = 2;
    self.animationGroup = group;
}

- (void)startAnimation
{
    [self.imageView.layer addAnimation:self.animationGroup forKey:nil];
}

@end

@interface CCAudienceLoveItem : NSObject<CAAnimationDelegate>

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) UIImage *nextImage;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIBezierPath *path;

@property (nonatomic,strong) CAAnimationGroup *animationGroup;

@end

@implementation CCAudienceLoveItem

- (void)dealloc
{
    [_imageView.layer removeAllAnimations];
}

- (instancetype)initWithImage:(UIImage *)image
                    nextImage:(UIImage *)nextImage
{
    if ( self = [super init] )
    {
        self.image = image;
        self.nextImage = nextImage;
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageView sizeToFit];
    }
    return self;
}

- (void)setUpAnimation
{
#ifdef CCDEBUG
    assert(self.path);
#endif
    if ( self.animationGroup )
    {
        return;
    }
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = self.path.CGPath;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim.fromValue = @1.0f;
    anim.toValue = @0.0f;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];

    group.animations = @[anim, animation /*, scale*/];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = YES;
    group.duration = 2;
    self.animationGroup = group;
}

- (void)startAnimation
{
    [self.imageView.layer addAnimation:self.animationGroup forKey:LIKE_ANIMATION_KEYPATH];
}

@end

/**
    结构
        id1 : queueid1
        id2 : queueid2
        ...
 */
@interface CCAudiencePrecentItemDelegate : NSObject

@property (nonatomic, strong) NSMutableArray *animatingQueue;

@property (nonatomic, strong) NSMutableDictionary *presents;

@property (nonatomic,strong) NSMutableArray *presentids;

@property ( nonatomic ) CGPoint center;

@property ( nonatomic ) CGRect frame;

@property (nonatomic,strong) UIBezierPath *path;


@end

@implementation CCAudiencePrecentItemDelegate

- (void)dealloc
{
    _animatingQueue = nil;
    _presentids = nil;
    _presents = nil;
}

- (instancetype)init
{
    if ( self = [super init] )
    {
        _animatingQueue = [NSMutableArray arrayWithCapacity:100];
        _presentids = [NSMutableArray arrayWithCapacity:100];
        _presents = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return self;
}

- (NSMutableArray *)animationQueueWithId:(NSNumber *)queueid
{
    NSMutableArray *queue = _presents[queueid];
    if ( queue == nil )
    {
        queue = [NSMutableArray arrayWithCapacity:100];
        _presents[queueid] = queue;
    }
    return queue;
}

- (void)startAnimationWithPresentid:(NSNumber *)presentid
{
    if ( presentid == nil )
    {
        return;
    }
    
    NSMutableArray *queue = [self animationQueueWithId:presentid];
    
    CCAudiencePrecentItem *item = [queue lastObject];
    
    if ( item  )
    {
        [queue removeLastObject];
        item.path = self.path;
        item.imageView.frame = self.frame;
        item.imageView.center = self.center;
        [item setUpAnimation];
        item.animationGroup.delegate = self;
        [item startAnimation];
        [_animatingQueue insertObject:item atIndex:0];
    }
    else
    {
        [_presentids insertObject:presentid atIndex:0];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CCAudiencePrecentItem *item = [_animatingQueue lastObject];
    if ( item )
    {
        [_animatingQueue removeLastObject];
        [[self animationQueueWithId:item.presentid] insertObject:item atIndex:0];
    }
    
    NSNumber *waitingPresentid = [_presentids lastObject];
    
    if ( waitingPresentid )
    {
        [_presentids removeLastObject];
        [self startAnimationWithPresentid:waitingPresentid];
    }
}

@end

@interface EVAudienceLoveView ()

@property (nonatomic,strong) NSMutableArray *animationPool;

@property (nonatomic,strong) NSMutableArray *animationFinishQueue;

@property (nonatomic,weak) UIButton *likeButton;

@property (nonatomic,weak) UILabel *likeCountLabel;

@property (nonatomic,weak) UIImageView *likeButtonImageView;

@property (nonatomic, strong) CCAudiencePrecentItemDelegate *presentAnimationDelegate;

@property (nonatomic, assign) NSInteger userLikeCount;

@end

@implementation EVAudienceLoveView

- (void)dealloc
{
    _animationPool = nil;
    _animationFinishQueue = nil;
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
    _animationPool = [NSMutableArray array];
    _animationFinishQueue = [NSMutableArray array];
    
    EVStartResourceTool *tool = [EVStartResourceTool shareInstance];
    NSArray *likeImages = [tool defaultLikeImages];
    NSInteger imageCount = likeImages.count;
    if ( imageCount == 0 )
    {
        return;
    }
    
    UIButton *likeButton = [[UIButton alloc] init];
    likeButton.hidden = YES;
    [self addSubview:likeButton];
    self.likeButton = likeButton;
    
    UIImageView *likeButtonImageView = [[UIImageView alloc] init];
    [likeButton addSubview:likeButtonImageView];
    self.likeButtonImageView = likeButtonImageView;
    [likeButtonImageView autoCenterInSuperview];
    [likeButtonImageView autoSetDimensionsToSize:CGSizeMake(LIKE_IMAGE_W, LIKE_IMAGE_W)];
    
    [likeButton addTarget:self action:@selector(likeButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    for ( NSInteger i = 0; i < MAX_IMAGE_COUNT; i++ )
    {
        UIImage *image = likeImages[arc4random_uniform(imageCount)];
        UIImage *hightLightImage = likeImages[arc4random_uniform(imageCount)];
        if ( i == MAX_IMAGE_COUNT - 1 )
        {
            [self updateLikeButtonNormalImage:image hightImage:hightLightImage];
        }
        CCAudienceLoveItem *item = [[CCAudienceLoveItem alloc] initWithImage:image nextImage:hightLightImage];
        [self.animationPool addObject:item];
        item.imageView.alpha = 0.0;
        [self addSubview:item.imageView];
    }
    
    CGFloat buttonWH = CCAudienceLoveViewLoveButtonWH;
    likeButton.backgroundColor = [UIColor clearColor];
    [likeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    
    UILabel *likeCountLabel = [[UILabel alloc] init];
    likeCountLabel.text = @"0";
    likeCountLabel.hidden = YES;
    likeCountLabel.textColor = [UIColor whiteColor];
    likeCountLabel.textAlignment = NSTextAlignmentCenter;
    likeCountLabel.font = [UIFont systemFontOfSize:14];
    [self insertSubview:likeCountLabel belowSubview:likeButton];
    [likeCountLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:likeButton];
    [likeCountLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    self.likeCountLabel = likeCountLabel;
    likeButton.backgroundColor = [UIColor clearColor];
    
    [likeButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:likeCountLabel withOffset:6];
    [likeButton autoSetDimensionsToSize:CGSizeMake(buttonWH, buttonWH)];
    
    // 取出所有类型的礼物
    NSArray *localPresents = [tool presentsWithType:0];
    _presentAnimationDelegate = [[CCAudiencePrecentItemDelegate alloc] init];
    for ( EVStartGoodModel *item in localPresents )
    {
        NSString *imageURL = item.pic;
        NSNumber *presentid = @(item.ID);
        if ( imageURL && [presentid isKindOfClass:[NSNumber class]] )
        {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:PRESENTFILEPATH([imageURL md5String])]];
            if ( image )
            {
                NSMutableArray *presentModelQueue = [_presentAnimationDelegate animationQueueWithId:presentid];
                for (NSInteger i = 0; i < PRESENT_QUQUESIZE; i++ )
                {
                    CCAudiencePrecentItem *itemModel = [[CCAudiencePrecentItem alloc] initWithImage:image];
                    itemModel.presentid = presentid;
                    [presentModelQueue addObject:itemModel];
                    itemModel.imageView.alpha = 0.0;
                    [self addSubview:itemModel.imageView];
                }
            }
        }
    }
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setLikeCount:(NSInteger)likeCount
{
    _likeCount = likeCount;
    self.likeCountLabel.text = [NSString shortNumber:self.likeCount];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CCAudienceLoveItem *item = [self.animationFinishQueue lastObject];
    item.imageView.hidden = YES;
    [self.animationFinishQueue removeLastObject];
    [self.animationPool insertObject:item atIndex:0];
}

- (UIBezierPath *)animationPathFromWithPoint:(CGPoint)start
{
    CGFloat a_delta = self.bounds.size.width * 0.8;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint end = CGPointMake(self.bounds.size.width * 0.5, 0 );
    
    [path moveToPoint:start];
    
    NSInteger i = arc4random_uniform(10);
    
    CGFloat delta = a_delta - 0.08 * a_delta * i;
    CGFloat delta1 = i % 2 ? delta : - delta;
    CGPoint c1 = CGPointMake(start.x + delta1, start.y - delta);
    CGPoint c2 = CGPointMake(end.x - delta1, end.y + delta);
    [path addCurveToPoint:end controlPoint1:c1 controlPoint2:c2];
    return path;
}


- (void)updateLikeButtonNormalImage:(UIImage *)image
                         hightImage:(UIImage *)hightImage
{
    self.likeButtonImageView.image = image;
}

- (void)likeButtonDidClicked
{
    self.userLikeCount++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegete && [self.delegete respondsToSelector:@selector(touchLoveCount:)]) {
            [self.delegete touchLoveCount:self.userLikeCount];
        }
    });
    
    [self popAnimation];
}

- (void)starAnimation
{
    [self popAnimation];
}

- (void)registAnimation
{
    [self likeButtonDidClicked];
}

- (void)popAnimation
{
    self.hidden = NO;
    CCAudienceLoveItem *item = [self.animationPool lastObject];
    if ( item )
    {
        item.imageView.hidden = NO;
        [self.animationPool removeLastObject];
        [self.animationFinishQueue insertObject:item atIndex:0];
        [self updateLikeButtonNormalImage:item.image hightImage:item.nextImage];
        item.imageView.frame = CGRectMake(0, 0, LIKE_IMAGE_W, LIKE_IMAGE_W);
        item.imageView.center = self.likeButton.center;
        item.path = [self animationPathFromWithPoint:self.likeButton.center];
        [item setUpAnimation];
        item.animationGroup.delegate = self;
        [item startAnimation];
    }
}

- (void)audienceInfoViewUpdate:(CCAudiencceInfoViewProtocolDataType)type
                         count:(NSInteger)count
{
    switch ( type )
    {
        case CCAudiencceInfoViewProtocolLike:
            self.likeCount = count;
            break;
    }
}

@end
