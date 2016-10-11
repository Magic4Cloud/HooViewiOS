//
//  EVHeaderView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVHeaderView.h"
#import "PureLayout.h"
#import "UIView+Extension.h"

@interface CCLogoImageView : UIImageView

@end

@implementation CCLogoImageView

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setRoundCorner];
}

@end

@interface CCHeaderImageView ()

@property (nonatomic, weak) CCLogoImageView *smallLogoImageView;
@property (nonatomic, weak) UIImageView *vipImageView;

@end

@implementation CCHeaderImageView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ( self = [super initWithCoder:aDecoder] ) {
        [self initialSelf];
    }
    return self;
}

- (void)setBorder:(BOOL)border
{
    _border = border;
    if (border)
    {
        self.smallLogoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.smallLogoImageView.layer.borderWidth = 1;
    }
}

- (void)initialSelf
{
    CCLogoImageView *logo = [[CCLogoImageView alloc] init];
    [self addSubview:logo];
    
    self.smallLogoImageView = logo;
    
    UIImageView *vip = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_max_vip"]];
    [self addSubview:vip];
    self.vipImageView = vip;
    self.vipImageView.hidden = YES;
    [self constraintSubViews];
}

- (instancetype)init
{
    if ( self = [super init] )
    {
        [self initialSelf];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.smallLogoImageView.frame = self.bounds;
    
    CGFloat vipWidth, vipHieght = 0;
    if (self.vipSizeType == CCVipMini)
    {
        vipWidth = vipHieght = 10;
    }
    else if (self.vipSizeType == CCVipMiddle)
    {
        vipWidth = vipHieght = 14;
    }
    else
    {
        vipWidth = vipHieght = 16;
    }
    
    CGFloat centreXORY = (2 + sqrt(2)) / 4.0 * self.frame.size.width;
    _vipImageView.frame = CGRectMake(0, 0, vipWidth, vipHieght);
    _vipImageView.center = CGPointMake(centreXORY, centreXORY);
}

- (void)constraintSubViews
{
    [self.smallLogoImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.smallLogoImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.smallLogoImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.smallLogoImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    
    [self.vipImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.vipImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.vipImageView autoSetDimensionsToSize:CGSizeMake(16, 16)];
}

- (void)setVipConstraint
{
    [self.vipImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.vipImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
}

- (void)cc_setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeHolderImageName
{
    [self.smallLogoImageView cc_setImageWithURLString:urlString placeholderImageName:placeHolderImageName];
}

- (void)cc_setImageWithURLString:(NSString *)urlString isVip:(BOOL)vip vipSizeType:(CCVipSizeType)type
{
    [self cc_setImageWithURLString:urlString placeholderImageName:@"avatar" isVip:vip vipSizeType:type];
}

- (void)cc_setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeHolderImageName isVip:(NSInteger)vip vipSizeType:(CCVipSizeType)type;
{
    [self cc_setImageWithURLString:urlString placeholderImageName:placeHolderImageName];
    self.vip = vip;
    self.vipSizeType = type;
}

- (void)setImage:(UIImage *)image
{
    self.smallLogoImageView.image = image;
}

//是否显示大v
- (void)setVip:(NSInteger)vip
{
    _vip = vip;
    self.vipImageView.hidden = vip == 0;
}

@end

@interface EVHeaderButton ()

@property (nonatomic, weak) CCLogoImageView *smallLogoImageView;
@property (nonatomic, weak) UIImageView *vipImageView;

@property (nonatomic,weak) NSLayoutConstraint *vipBottomConstraint;
@property (nonatomic,weak) NSLayoutConstraint *vipRightConstraint;

@property (nonatomic, strong) UIImage *vipImage;

@end

@implementation EVHeaderButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ( self = [super initWithCoder:aDecoder] )
    {
        CCLogoImageView *logo = [[CCLogoImageView alloc] init];
        [self addSubview:logo];
        self.smallLogoImageView = logo;
        
        UIImageView *vip = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_max_vip"]];
        [self addSubview:vip];
        vip.hidden = YES;
        self.vipImageView = vip;
    }
    return self;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    EVHeaderButton *btn = [[EVHeaderButton alloc] init];
    
    CCLogoImageView *logo = [[CCLogoImageView alloc] init];
    [btn addSubview:logo];
    btn.smallLogoImageView = logo;
    
    UIImageView *vip = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_max_vip"]];
    [btn addSubview:vip];
    vip.hidden = YES;
    btn.vipImageView = vip;
    
    return btn;
}

- (instancetype)init
{
    if ( self = [super init] )
    {
        CCLogoImageView *logo = [[CCLogoImageView alloc] init];
        [self addSubview:logo];
        self.smallLogoImageView = logo;
        
        UIImageView *vip = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_max_vip"]];
        [self addSubview:vip];
        vip.hidden = YES;
        self.vipImageView = vip;
    }
    return self;
}

- (void)cc_setBackgroundImageURL:(NSString *)urlString placeholderImageStr:(NSString *)placeHolderImageName isVip:(NSInteger)vip  vipSizeType:(CCVipSizeType)type complete:(void(^)(UIImage *image))complete
{
    [self.smallLogoImageView cc_setImageWithURLString:urlString placeholderImageName:placeHolderImageName complete:complete];
    self.vipSizeType = type;
}

- (void)cc_setBackgroundImageURL:(NSString *)urlString placeholderImageStr:(NSString *)placeHolderImageName isVip:(NSInteger)vip  vipSizeType:(CCVipSizeType)type
{
    [self cc_setBackgroundImageURL:urlString placeholderImageStr:placeHolderImageName isVip:vip vipSizeType:type complete:^(UIImage *image) {
        
    }];
}

- (void)cc_setBackgroundImageURL:(NSString *)urlString placeholderImage:(UIImage *)placeHolderImage isVip:(BOOL)vip vipSizeType:(CCVipSizeType)type
{
    [self.smallLogoImageView cc_setImageWithURLString:urlString placeholderImage:[UIImage imageNamed:@"avatar"]];
    self.vipSizeType = type;
}

- (void)setVipSizeType:(CCVipSizeType)vipSizeType
{
    _vipSizeType = vipSizeType;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsLayout];
//        [self layoutIfNeeded];
    });
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.smallLogoImageView.frame = self.bounds;
    
    CGFloat vipWidth, vipHieght = 0;
    if (self.vipSizeType == CCVipMini)
    {
        vipWidth = vipHieght = 10;
    }
    else if (self.vipSizeType == CCVipMiddle)
    {
        vipWidth = vipHieght = 14;
    }
    else
    {
        vipWidth = vipHieght = 16;
    }
    CGFloat centreXORY = (2 + sqrt(2)) / 4.0 * self.frame.size.width;
    _vipImageView.frame = CGRectMake(0, 0, vipWidth, vipHieght);
    _vipImageView.center = CGPointMake(centreXORY, centreXORY);
}


- (void)hasBorder:(BOOL)border
{
    if ( _border != border )
    {
        _border = border;
    }
    if ( YES == _border )
    {
        self.smallLogoImageView.layer.masksToBounds = YES;
        self.smallLogoImageView.layer.borderWidth = 1;
        self.smallLogoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

@end
