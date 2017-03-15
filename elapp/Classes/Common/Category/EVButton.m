//
//  CCButton.m
//  oupai
//
//  Created by 罗潇 on 2016/9/25.
//  Copyright © 2016年 yizhibo. All rights reserved.
//

#import "EVButton.h"

@implementation EVButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initNMButton];
        
        _titleCenter = CGPointMake(frame.size.width/2, frame.size.height/2);
        _imageCenter = CGPointMake(frame.size.width/2, frame.size.height/2);
    }
    return self;
}

- (void) initNMButton
{
    if (nil == _background)
    {
        _background = [[UIImageView alloc] initWithFrame:CGRectZero];
        _background.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_background];
    }
    
    if (nil == _imageView)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
    }
    
    if (nil == _titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.shadowColor = [UIColor clearColor];
        _titleLabel.shadowOffset = CGSizeMake(0, 0);
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }
    
    if (nil == _titles)
    {
        _titles = [[NSMutableDictionary alloc] initWithCapacity:6];
    }
    
    if (nil == _titleColors)
    {
        _titleColors = [[NSMutableDictionary alloc] initWithCapacity:6];
    }
    
    if (nil == _titleShadows)
    {
        _titleShadows = [[NSMutableDictionary alloc] initWithCapacity:6];
    }
    
    if (nil == _images)
    {
        _images = [[NSMutableDictionary alloc] initWithCapacity:6];
    }
    
    if (nil == _backgrounds)
    {
        _backgrounds = [[NSMutableDictionary alloc] initWithCapacity:6];
    }
}


#pragma mark - UIControl

- (void)setSelected:(BOOL)selected {
    if (selected != self.selected) {
        super.selected = selected;
        [self configureViewForControlState:self.state];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted != self.highlighted) {
        super.highlighted = highlighted;
        [self configureViewForControlState:self.state];
    }
}

- (void)setEnabled:(BOOL)newEnabled {
    [super setEnabled:newEnabled];
    [self configureViewForControlState:self.state];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self configureViewForControlState:self.state];
    
    if (CGPointEqualToPoint(_titleCenter, CGPointZero)) {
        _titleCenter = CGPointMake(frame.size.width/2, frame.size.height/2);
    }
    if (CGPointEqualToPoint(_imageCenter, CGPointZero)) {
        _imageCenter = CGPointMake(frame.size.width/2, frame.size.height/2);
    }
}

- (void) configureViewForControlState:(UIControlState)controlState {
    NSString* title = [self getValueFromDictionary:_titles forControlState:controlState];
    UIColor* titleColor = [self getValueFromDictionary:_titleColors forControlState:controlState];
    UIColor* shadowColor = [self getValueFromDictionary:_titleShadows forControlState:controlState];
    UIImage* image = [self getValueFromDictionary:_images forControlState:controlState];
    UIImage* background = [self getValueFromDictionary:_backgrounds forControlState:controlState];
    
    [self.titleLabel setText:title];
    [self.titleLabel sizeToFit];
    
    if (titleColor) {
        [self.titleLabel setTextColor:titleColor];
    }
    
    if (shadowColor) {
        [self.titleLabel setShadowColor:shadowColor];
    }
    
    [self.imageView setImage:image];
    [self.imageView sizeToFit];
    
    //    [self adjustImageViewFrame];
    
    [self.background setImage:background];
}

#pragma mark - layout

- (void) layoutSubviews {
    [super layoutSubviews];
    
    _background.frame = self.bounds;
    _imageView.center = _imageCenter;
    [_imageView sizeToFit];
    _titleLabel.center = _titleCenter;
    [_titleLabel sizeToFit];
    
    [self adjustImageViewFrame];
}

#pragma mark 调整导航条右侧按钮样式显示效果
- (void)adjustImageViewFrame
{
    if (_titleLabel.text.length >= 4 && _titleCenter.x == _imageCenter.x && _titleCenter.y == _imageCenter.y) {
        CGRect temp = _imageView.frame;
        //        temp.origin.x = temp.origin.x - 5;
        temp.origin.x = 0;
        temp.size.width = 60;
        _imageView.frame = temp;
    }
}

#pragma mark - Dictionary

- (void)setValue:(id)value inDictionary:(NSMutableDictionary*)dictionary forControlState:(UIControlState)controlState {
    if (value) {
        [dictionary setObject:value forKey:[NSString stringWithFormat:@"%ld",controlState]];
    } else {
        [dictionary removeObjectForKey:[NSString stringWithFormat:@"%ld",controlState]];
    }
}

- (id)getValueFromDictionary:(NSMutableDictionary*)dictionary forControlState:(UIControlState)controlState {
    if ([dictionary valueForKey:[NSString stringWithFormat:@"%ld",controlState]]) {
        return [dictionary valueForKey:[NSString stringWithFormat:@"%ld",controlState]];
    }
    
    if ((controlState & UIControlStateSelected)
        && [dictionary valueForKey:[NSString stringWithFormat:@"%ld",UIControlStateSelected]])
    {
        return [dictionary valueForKey:[NSString stringWithFormat:@"%ld",UIControlStateSelected]];
    }
    else if ((controlState & UIControlStateHighlighted)
             && [dictionary valueForKey:[NSString stringWithFormat:@"%ld", UIControlStateHighlighted]])
    {
        return [dictionary valueForKey:[NSString stringWithFormat:@"%ld", UIControlStateHighlighted]];
    }
    else
    {
        return [dictionary valueForKey:[NSString stringWithFormat:@"%ld",UIControlStateNormal]];
    }
}

#pragma mark - Setter & Getter

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [self setValue:title inDictionary:_titles forControlState:state];
    
    if (self.state == state || self.state & state) {
        [self.titleLabel setText:title];
        [self.titleLabel sizeToFit];
        
        [self adjustImageViewFrame];
    }
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    [self setValue:color inDictionary:_titleColors forControlState:state];
    
    if (self.state == state || self.state & state) {
        [self.titleLabel setTextColor:color];
    }
}

- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state
{
    [self setValue:color inDictionary:_titleShadows forControlState:state];
    
    if (self.state == state || self.state & state) {
        self.titleLabel.shadowColor = color;
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [self setValue:image inDictionary:_images forControlState:state];
    
    if (self.state == state || self.state & state) {
        [self.imageView setImage:image];
        [self.imageView sizeToFit];
        
        [self adjustImageViewFrame];
    }
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    [self setValue:image inDictionary:_backgrounds forControlState:state];
    
    if (self.state == state || self.state & state) {
        [self.background setImage:image];
    }
}

- (NSString *)titleForState:(UIControlState)state
{
    return [self getValueFromDictionary:_titles forControlState:state];
}

- (UIColor *)titleColorForState:(UIControlState)state
{
    return [self getValueFromDictionary:_titleColors forControlState:state];
}

- (UIColor *)titleShadowColorForState:(UIControlState)state
{
    return [self getValueFromDictionary:_titleShadows forControlState:state];
}

- (UIImage *)imageForState:(UIControlState)state
{
    return [self getValueFromDictionary:_images forControlState:state];
}

- (UIImage *)backgroundImageForState:(UIControlState)state
{
    return [self getValueFromDictionary:_backgrounds forControlState:state];
}


@end
