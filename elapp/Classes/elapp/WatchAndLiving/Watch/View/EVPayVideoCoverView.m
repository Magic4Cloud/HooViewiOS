//
//  EVPayVideoCoverView.m
//  elapp
//
//  Created by 唐超 on 4/25/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVPayVideoCoverView.h"

@implementation EVPayVideoCoverView

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}


-(void)setup
{
    
    UIView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    [self addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *bindings = NSDictionaryOfVariableBindings(@"view", view);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:bindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:bindings]];
    self.bounds = view.bounds;
    
    _viewPayButton.layer.cornerRadius = 12;
    _viewPayButton.layer.masksToBounds = YES;
    [_viewPayButton setBackgroundColor:[UIColor evMainColor]];
    if (ScreenWidth == 320) {
        _viewLabel.font = [UIFont systemFontOfSize:13];
    }

    
    [self setNeedsLayout];
}

- (IBAction)backButtonClick:(id)sender {
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock();
    }
}

- (IBAction)shareButtonClick:(id)sender {
    if (self.shareButtonClickBlock) {
        self.shareButtonClickBlock();
    }
}

- (IBAction)payButtonClick:(UIButton *)sender {
    if (self.payButtonClickBlock) {
        self.payButtonClickBlock();
    }
}

@end
