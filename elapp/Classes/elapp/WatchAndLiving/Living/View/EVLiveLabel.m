//
//  EVLiveLabel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLiveLabel.h"
#import <PureLayout.h>

#define kBackGroundColor CCARGBColor(0, 0, 0, 0.6)
#define DEFAULT_MARGIN_LABEL 8

@interface EVLiveLabel ()

@property (nonatomic,weak) UILabel *sublabel;

@end

@implementation EVLiveLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        self.backgroundColor = [UIColor clearColor];
        self.numberOfLines = 0;
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor clearColor];
        
        UIView *contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        contentView.backgroundColor = [UIColor clearColor];
        [contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        UILabel *sublabel = [[UILabel alloc] init];
        sublabel.textAlignment = NSTextAlignmentCenter;
        sublabel.numberOfLines = 0;
        [contentView addSubview:sublabel];
        self.sublabel = sublabel;
        [sublabel autoCenterInSuperview];
//        [sublabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        sublabel.textColor = [UIColor whiteColor];
        self.layer.cornerRadius = 2;
        self.clipsToBounds = YES;
        
        [self setLabelFontSize:10];
    }
    return self;
}

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth
{
    [super setPreferredMaxLayoutWidth:preferredMaxLayoutWidth];
    self.sublabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth - 2 * 2;
}

- (void)setLabelFontSize:(CGFloat)size
{
    self.font = [UIFont systemFontOfSize:size + 1];
    self.sublabel.font = [UIFont systemFontOfSize:size];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    self.sublabel.text = text;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)cc_setEmotionWithText:(NSString *)text
{
    [super cc_setEmotionWithText:text];
    [self.sublabel cc_setEmotionWithText:text];
}

- (void)drawRect:(CGRect)rect
{
    [kBackGroundColor set];
    [[UIBezierPath bezierPathWithRect:rect] fill];
}

@end
