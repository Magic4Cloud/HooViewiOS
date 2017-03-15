//
//  EVAudienceUserJoinView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVAudienceUserJoinView.h"
#import <PureLayout.h>

@interface EVAudienceUserJoinView ()

/** 显示内容 */
@property (nonatomic, weak) UILabel *textLabel;

/** 文字颜色 */
@property (nonatomic, strong) NSArray *textColors;

@property (nonatomic,copy) NSString *showText;

@property (nonatomic, assign) BOOL emojiTextAnimation;

@end

@implementation EVAudienceUserJoinView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUI];
        [self addObserver:self forKeyPath:@"showText" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

// 观众进入提示语
- (void)setNickName:(NSString *)nickName
{
    if ( _emojiTextAnimation || nickName == nil )
    {
        return;
    }
    _nickName = [nickName copy];
    NSString *content = [NSString stringWithFormat:@"%@ %@", nickName,kE_GlobalZH(@"come_in_room")];
    NSMutableAttributedString *mAttStr = [[NSMutableAttributedString alloc] initWithString:content];
    [mAttStr addAttributes:@{NSForegroundColorAttributeName: [UIColor evAssistColor], NSFontAttributeName: EVBoldFont(16)} range:NSMakeRange(0, nickName.length)];
    [mAttStr addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#FFFFFF"], NSFontAttributeName: EVNormalFont(16)} range:NSMakeRange(nickName.length, 3)];
    NSShadow *textShadow = [[NSShadow alloc] init];
    textShadow.shadowColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];
    textShadow.shadowOffset = CGSizeMake(.5, .5);
    [mAttStr addAttributes:@{NSShadowAttributeName: textShadow} range:NSMakeRange(0, mAttStr.length)];
    self.textLabel.attributedText = mAttStr;
    self.showText = nickName;
}

- (void)setUI
{
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [[EVAppSetting shareInstance] normalFontWithSize:14];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.layer.shadowOffset = CGSizeMake(3, 3);
    textLabel.layer.shadowColor = [UIColor colorWithHexString:@"#000000" alpha:0.4].CGColor;
    [self addSubview:textLabel];
    textLabel.numberOfLines = 1;
    _textLabel = textLabel;
    [textLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
//    self.layer.cornerRadius = (textLabel.bounds.size.height + 25) * 0.5;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ( change[@"new"] != nil && ![change[@"new"] isEqualToString:@""] )
    {
        self.alpha = 1;
        __weak typeof(self) wself = self;
        [UIView animateKeyframesWithDuration:0.5 delay:2 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            wself.alpha = 0;
        } completion:nil];
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"showText"];
}

@end
