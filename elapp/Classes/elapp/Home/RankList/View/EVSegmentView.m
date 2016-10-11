//
//  EVSegmentView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVSegmentView.h"

@interface EVSegmentView ()

@property (nonatomic, weak) UIButton *segmentButton;

@property (nonatomic, weak) UIView *bottomLineView;

@end

@implementation EVSegmentView

- (instancetype)initWithFrame:(CGRect)frame segmentArrat:(NSArray *)segmentArray
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViewSegmentArrat:segmentArray];
    }
    return self;
}

- (void)setUpViewSegmentArrat:(NSArray *)segmentArray
{
    CGFloat buttonWidth = ScreenWidth / 3;
    for (NSInteger i = 0 ; i < 3; i++) {
        UIButton *segmentButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        segmentButton.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, 40);
        [self addSubview:segmentButton];
        [segmentButton addTarget:self action:@selector(rankListButtton:) forControlEvents:(UIControlEventTouchUpInside)];
        segmentButton.backgroundColor = [UIColor whiteColor];
        segmentButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [segmentButton setTitle:segmentArray[i] forState:(UIControlStateNormal)];
        [segmentButton setTitleColor:[UIColor evTextColorH1] forState:(UIControlStateNormal)];
        [segmentButton setTitleColor:[UIColor evSecondColor] forState:(UIControlStateSelected)];
        UIView *bottomLineView  = [[UIView alloc]init];
        bottomLineView.frame = CGRectMake(0, 38, buttonWidth, 2);
        [segmentButton addSubview:bottomLineView];
        bottomLineView.tag = 2000+i;
        bottomLineView.backgroundColor = [UIColor evSecondColor];
        bottomLineView.hidden = YES;
        segmentButton.tag = 1000+i;
        if (i == 0) {
            bottomLineView.hidden = NO;
            [self rankListButtton:segmentButton];
        }
    }
}

- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


- (void)rankListButtton:(UIButton *)button
{
    UIView *bottomView =  (UIView *)[button viewWithTag:button.tag+1000];
    if (self.segmentButton != button ) {
        bottomView.hidden = NO;
        self.bottomLineView.hidden = YES;
        self.segmentButton.selected = NO;
        button.selected = YES;
    }
    
    self.bottomLineView = bottomView;
    self.segmentButton = button;
   
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentButtonTag:)]) {
        [self.delegate segmentButtonTag:button.tag-1000];
    }
  
}
@end
