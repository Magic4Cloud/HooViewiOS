//
//  EVLiveShareView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLiveShareView.h"
#import <PureLayout.h>
#import "EVShareManager.h"

#define kDefaultMargin 10


@implementation EVLiveShareButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect imageFrame = self.imageView.frame;
    CGRect titleFrame = self.titleLabel.frame;
    
    CGFloat wholeHeight = kDefaultMargin + imageFrame.size.height + titleFrame.size.height;
    
    CGFloat imageViewCenterY = (self.bounds.size.height - wholeHeight) * 0.5 + 0.5 * imageFrame.size.height;
    CGFloat imageViewCenterX = 0.5 * self.bounds.size.width;
    
    CGFloat titleCenterX = imageViewCenterX;
    CGFloat titleCenterY = imageViewCenterY + kDefaultMargin + 0.5 * imageFrame.size.height;
    
    self.imageView.center = CGPointMake(imageViewCenterX, imageViewCenterY);
    self.titleLabel.center = CGPointMake(titleCenterX, titleCenterY);
}

@end

@interface EVLiveShareView ()

@property (nonatomic, weak) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, weak) NSLayoutConstraint *leftConstraint;
@property (nonatomic, weak) NSLayoutConstraint *rightomConstraint;

@end

@implementation EVLiveShareView

+ (instancetype)liveShareView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"EVLiveShareView" owner:nil options:nil] lastObject];
}

+ (EVLiveShareView *)liveShareViewToTargetView:(UIView *)view
                                    menuHeight:(CGFloat)menuHeight delegate:(id<CCLiveShareViewDelegate>)delegate
{
    EVLiveShareView *coverView = [[EVLiveShareView alloc] init];
    coverView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:.2];
    [view addSubview:coverView];
    [coverView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    EVLiveShareView *shareView = [EVLiveShareView liveShareView];
    shareView.delegate = delegate;
    shareView.tag = SAHRE_VIEW_TAG;
    [coverView addSubview:shareView];
    
    shareView.bottomConstraint = [shareView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    shareView.leftConstraint = [shareView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    shareView.rightomConstraint = [shareView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    
    [shareView autoSetDimension:ALDimensionHeight toSize:menuHeight];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:shareView action:@selector(coverTap)];
    [coverView addGestureRecognizer:tap];
    coverView.hidden = YES;
    return coverView;
}

- (void)coverTap
{
    self.superview.hidden = YES;
    [self notifyHidden];
}

- (void)foreceHideOnly
{
    self.superview.hidden = YES;
}

- (void)awakeFromNib
{
    UILabel *label = [[UILabel alloc] init];
    [self addSubview:label];
    label.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:0.9];
    label.text = kE_GlobalZH(@"share_to");
    label.textColor = [UIColor colorWithHexString:@"#403b37"];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [label autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(- 42, 0, 202, 0)];
    
    for (UIView *subView in self.subviews)
    {
        if ( [subView isKindOfClass:[UIButton class]] )
        {
            [self bringSubviewToFront:subView];
            UIButton *btn = (UIButton *)subView;
            [btn addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            switch ( btn.tag  ) {
                case CCLiveShareQQButton:
                    btn.enabled = [EVShareManager qqInstall];
                    break;
                case CCLiveShareSinaWeiBoButton:
                    btn.enabled = [EVShareManager weiBoInstall];
                    break;
                case CCLiveShareWeiXinButton:
                    btn.enabled = [EVShareManager weixinInstall];
                    break;
                case CCLiveShareFriendCircleButton:
                    btn.enabled = [EVShareManager weixinInstall];
                    break;
                case CCLiveShareQQZoneButton:
                    btn.enabled = [EVShareManager qqInstall];
                    break;
                default:
                    break;
            }
            
        }
    }
    
    for ( UIView *item in self.subviews )
    {
        if ( [item isKindOfClass:[EVLiveShareButton class]] )
        {
            EVLiveShareButton *btn = (EVLiveShareButton *)item;
            
            [btn setTitleColor:[CCAppSetting shareInstance].titleColor forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff" alpha:0.4] forState:UIControlStateDisabled];
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
        }
    }
    
}

- (void)buttonDidClicked:(UIButton *)btn
{
    self.superview.hidden = YES;
    [self notifyHidden];
    if ( btn.selected )
    {
        return;
    }
    
    if ( [self.delegate respondsToSelector:@selector(liveShareViewDidClickButton:)] )
    {
        [self.delegate liveShareViewDidClickButton:btn.tag];
    }
}


- (void)notifyHidden
{
    if ( [self.delegate respondsToSelector:@selector(liveShareViewDidHidden)] )
    {
        [self.delegate liveShareViewDidHidden];
    }
}

- (void)setMarginBotton:(CGFloat)marginBotton
{
    self.bottomConstraint.constant = marginBotton;
}

@end
