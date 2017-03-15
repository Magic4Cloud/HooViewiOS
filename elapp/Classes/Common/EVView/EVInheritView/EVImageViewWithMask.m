//
//  EVImageViewWithMask.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVImageViewWithMask.h"


#define kGlobalGrayLayerHeight   19.0f

@interface EVImageViewWithMask ()


@end

@implementation EVImageViewWithMask

#pragma mark - life circle

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
//        [self addMaskLayer];
//        [self addTitleLable];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [self addMaskLayer];
//        [self addTitleLable];
    }
    return self;
}

#pragma mark - private methods

- (void)addMaskLayer {
    _maskLayer = [CALayer layer];
    _maskLayer.frame = self.layer.bounds;
    _maskLayer.backgroundColor = [UIColor colorWithHexString:@"#484848"].CGColor;
    _maskLayer.opacity = .0f;
    [self.layer addSublayer:_maskLayer];
    
    _bottomMaskLayer = [CALayer layer];
    _bottomMaskLayer.frame = CGRectMake(.0f, self.layer.bounds.size.height - kGlobalGrayLayerHeight, self.layer.bounds.size.width, kGlobalGrayLayerHeight);
    _bottomMaskLayer.backgroundColor = [UIColor colorWithHexString:@"#484848"].CGColor;
    _bottomMaskLayer.opacity = .5f;
    [self.layer addSublayer:_bottomMaskLayer];
    
    self.layer.cornerRadius = 3.0f;
    self.layer.masksToBounds = YES;
    
    self.maskColor = [UIColor colorWithCGColor:_maskLayer.backgroundColor];
    self.bottomMaskColor = [UIColor colorWithCGColor:_bottomMaskLayer.backgroundColor];
}

- (void)addTitleLable {
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(.0f, self.bounds.size.height - kGlobalGrayLayerHeight, self.bounds.size.width, kGlobalGrayLayerHeight)];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [[EVAppSetting shareInstance] normalFontWithSize:12.0f];
    [self addSubview:title];
    _title = title;
}

#pragma mark - setters and getters

- (void)setMaskColor:(UIColor *)maskColor {
    if (_maskColor != maskColor) {
        _maskColor = maskColor;
        _maskLayer.backgroundColor = maskColor.CGColor;
    }
}

- (void)setBottomMaskColor:(UIColor *)bottomMaskColor {
    if (_bottomMaskColor != bottomMaskColor) {
        _bottomMaskColor = bottomMaskColor;
        _bottomMaskLayer.backgroundColor = bottomMaskColor.CGColor;
    }
}

@end
