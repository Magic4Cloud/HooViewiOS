//
//  UIView+Extension.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setNormalFontAffectSubviews:(BOOL)affectSubviews {
    NSString *fontFamlyName = [EVAppSetting shareInstance].normalFontFamilyName;
    [self setFontFamily:fontFamlyName affectSubviews:affectSubviews];
}

-(void)setFontFamily:(NSString*)fontFamily affectSubviews:(BOOL)affectSubviews {
    if ( [self isKindOfClass:[UILabel class]] )
    {
        UILabel *label = (UILabel *)self;
        label.font = [UIFont fontWithName:fontFamily size:label.font.pointSize];
    }
    
    if ( [self isKindOfClass:[UIButton class]] ) {
        UIButton *button = (UIButton *)self;
        button.titleLabel.font = [UIFont fontWithName:fontFamily size:button.titleLabel.font.pointSize];
    }
    
    if ( [self isKindOfClass:[UITextField class]] ) {
        UITextField *textfield = (UITextField *)self;
        textfield.font = [UIFont fontWithName:fontFamily size:textfield.font.pointSize];
    }
    
    if ( [self isKindOfClass:[UITextView class]] ) {
        UITextView *textview = (UITextView *)self;
        textview.font = [UIFont fontWithName:fontFamily size:textview.font.pointSize];
    }
    
    if ( [self isKindOfClass:[UINavigationBar class]] ) {
        UINavigationBar *navbar = (UINavigationBar *)self;
        UIFont *font = (navbar.titleTextAttributes)[NSFontAttributeName];
        int fontSize = font.pointSize;  // Default navbar title font size
        if (font == nil)
            fontSize = 18;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:navbar.titleTextAttributes];
        attributes[NSFontAttributeName] = [UIFont fontWithName:fontFamily size:fontSize];
        navbar.titleTextAttributes = attributes;
    }
    
    if ( affectSubviews ) {
        for (UIView *subviews in self.subviews) {
            [subviews setFontFamily:fontFamily affectSubviews:YES];
        }
    }
}

- (void)backGroundColor_addAppAppearanceNotification{
    [EVNotificationCenter addObserver:self selector:@selector(backGroundColorChange:) name:EVAppSettingVersionDidChangedNotification object:nil];
}

- (void)removeAppAppearanceNotification{
    [EVNotificationCenter removeObserver:self];
}

- (void)backGroundColorChange:(NSNotification *)notification{
    switch ( [notification.userInfo[EVAppSettingChangeKey] integerValue] )
    {
        case EVAppStyleChangeMainColor:
            self.backgroundColor = [UIColor evMainColor];
            break;
            
        default:
            break;
    }
}

- (void)setRoundCorner {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height / 2.0f;
}

- (void)scaleBoundceAnimationShowComplete:(void (^)())complete
{
    self.hidden = NO;
    [self scaleBoundceAnimationStart:0.1 transit:1.4 end:1.0];
    if ( complete )
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            complete();
        });
    }
}

- (void)scaleBoundceAnimationShowImmediatelyComplete:(void (^)())complete
{
    self.hidden = NO;
    [self scaleBoundceAnimationStart:0.1 transit:1.4 end:1.0];
    if ( complete )
    {
        complete();
    }
}

- (void)scaleBoundceAnimationHiddenComplete:(void (^)())complete
{
   [self scaleBoundceAnimationStart:1.4 transit:0.5 end:0.1 hidden:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        [self.layer removeAllAnimations];
        if ( complete )
        {
            complete();
        }
    });
}

- (void)scaleBoundceAnimationStart:(CGFloat)start transit:(CGFloat)transit end:(CGFloat)end
{
    [self scaleBoundceAnimationStart:start transit:transit end:end hidden:NO];
}

- (void)scaleBoundceAnimationStart:(CGFloat)start transit:(CGFloat)transit end:(CGFloat)end hidden:(BOOL)hidden
{
    NSMutableArray *animations = [NSMutableArray array];;
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(start),@(transit),@(end)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8)];
    k.calculationMode = kCAAnimationLinear;
    [animations addObject:k];
    
    if ( self.hidden != hidden )
    {
        CGFloat from = 0.0;
        CGFloat to = 1.0;
        if ( hidden )
        {
            from = 1.0;
            to = 0.0;
        }
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        anim.fromValue = @(from);
        anim.toValue = @(to);
        [animations addObject:anim];
    }
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = animations;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = !hidden;
//    group.duration = 0.5;
    
//    [self.layer addAnimation:group forKey:@"SHOW"];
    
    [self.layer addAnimation:group forKey:nil];
}

@end
