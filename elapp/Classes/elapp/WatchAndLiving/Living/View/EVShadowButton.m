//
//  EVShadowButton.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVShadowButton.h"

@implementation EVShadowButton

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];

    self.bright = highlighted;
}

- (void)setBright:(BOOL)bright
{
    _bright = bright;
    
    if ( bright )
    {
        if ( self.hightBackGroundColor )
        {
            self.backgroundColor = self.hightBackGroundColor;
        }
        
        if ( self.hightLightBorderColor )
        {
            self.layer.borderColor = self.hightLightBorderColor.CGColor;
        }
    }
    else
    {
        
        if ( self.normalBackGroundColor )
        {
            self.backgroundColor = self.normalBackGroundColor;
        }
        
        if ( self.normalLightBorderColor )
        {
            self.layer.borderColor = self.normalLightBorderColor.CGColor;
        }
        
    }
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    
    if ( self.shadowColor )
    {
        self.layer.shadowOpacity = 1;
        self.layer.shadowColor = self.shadowColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
    }
    
    if ( self.normalLightBorderColor )
    {
        self.layer.borderColor = self.normalLightBorderColor.CGColor;
    }
   
}

@end

@implementation EVWhiteShadowButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        self.layer.borderWidth = 1;
        self.normalLightBorderColor = [UIColor whiteColor];
        self.hightLightBorderColor = [UIColor colorWithHexString:@"#FB6655" alpha:0.5];
        self.shadowColor = [UIColor colorWithHexString:@"#FB6655"];
        self.hightBackGroundColor = [UIColor whiteColor];
        self.normalBackGroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    self.layer.cornerRadius = self.bounds.size.height * 0.5;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.bright = selected;
}

@end
