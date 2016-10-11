//
//  EVScrollTextLabel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVScrollTextLabel.h"

@interface EVScrollTextLabel ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation EVScrollTextLabel


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _speed = 0.5; //  设置默认速度
        _delay = 2.0;  //  设置默认延迟滚动
        self.clipsToBounds = YES;
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.lineBreakMode = NSLineBreakByWordWrapping;
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        if (!_font) {
            _font = [UIFont systemFontOfSize:17];
        }
        if (self.text) {
            _label.text = self.text;
        }
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.label.frame = self.bounds;
}

- (void)setText:(NSString *)text
{
    if (_text != text) {
        _text = text;
        self.label.text = text;
        [self scroll];
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    if ( _attributedText != attributedText )
    {
        _attributedText = attributedText;
        [self scrollWithAttributedText:_attributedText];
    }
}

-(void)setFont:(UIFont *)font
{
    if (_font != font) {
        _font = font;
        self.label.font = _font;
    }
}

-(void)setTextColor:(UIColor *)textColor
{
    if (_textColor != textColor) {
        self.label.textColor = textColor;
    }
}

-(void)setSpeed:(float)speed
{
    if (speed <= 0.0f) {
        _speed = 0.0;
    }else if(speed >= 1.0){
        _speed = 1.0;
    }else{
        _speed = speed;
    }
}

- (void)scroll
{
    if (self.text == nil) {
        return;
    }
    NSMutableString *newText = [self.text mutableCopy];
    [newText appendString:self.text];
    CGRect rect = [newText boundingRectWithSize:CGSizeMake(10000, self.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:self.font} context:nil];
   CGSize textSize = rect.size;
    //  如果字符串的长度大于view的长度
    if (textSize.width / 2 > self.frame.size.width) {
        _label.text = newText;
        _label.frame = CGRectMake(0, 0, textSize.width, self.frame.size.height);
        
        [UIView animateWithDuration:textSize.width / (320 *self.speed) delay:self.delay options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat |UIViewAnimationOptionAutoreverse animations:^{
            _label.frame = CGRectMake(- textSize.width / 2 + self.frame.size.width, 0, textSize.width, self.frame.size.height);
        } completion:NULL];
    }
}

- (void)scrollWithAttributedText:(NSAttributedString *)attributedText
{
    if ( attributedText == nil )
    {
        return;
    }
    // 结束上次动画
    static NSString *labelAnimation = @"labelAnimation";
    [self.label.layer removeAnimationForKey:labelAnimation];
    NSMutableAttributedString *newAttriText = [attributedText mutableCopy];
    [newAttriText appendAttributedString:attributedText];
    CGRect rect = [newAttriText boundingRectWithSize:CGSizeMake(1000, self.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine context:nil];
    CGSize textSize = rect.size;
    //  如果字符串的长度大于view的长度
    if (textSize.width / 2 > self.frame.size.width) {
        self.label.attributedText = newAttriText;
        self.label.frame = CGRectMake(0, 0, textSize.width, self.frame.size.height);
        CGPoint fromPositon = CGPointMake(textSize.width * 0.5, self.label.center.y);
        self.label.layer.bounds = CGRectMake(0, 0, textSize.width, self.frame.size.height);
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.fromValue = [NSValue valueWithCGPoint:fromPositon];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, self.label.center.y)];
        animation.repeatCount = 100;
        animation.duration = textSize.width / (ScreenWidth *self.speed);
        [self.label.layer addAnimation:animation forKey:labelAnimation];
    }
    else
    {
        self.label.frame = self.bounds;
        self.label.attributedText = attributedText;
    }
    
}





@end
