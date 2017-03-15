//
//  EVHVHeadButton.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/16.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVHeadButton.h"

@interface EVHVHeadButton ()


@end

@implementation EVHVHeadButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    UIButton *headImageView = [[UIButton alloc] init];
    [self addSubview:headImageView];
    self.headImageView = headImageView;
    headImageView.userInteractionEnabled = YES;
    [headImageView setImage:[UIImage imageNamed:@"Account_bitmap_user"] forState:(UIControlStateNormal)];
    
    UIImageView *vipImegeView = [[UIImageView alloc] init];
    [self addSubview:vipImegeView];
    vipImegeView.image = [UIImage imageNamed:@"ic_v"];
    self.vipImageView = vipImegeView;
    vipImegeView.userInteractionEnabled = YES;
    [vipImegeView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [vipImegeView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [vipImegeView autoSetDimensionsToSize:CGSizeMake(20, 20)];
}

- (void)setHeadImageFrame:(CGRect)headImageFrame
{
    _headImageFrame = headImageFrame;
    _headImageView.frame = headImageFrame;
    self.headImageView.layer.cornerRadius = headImageFrame.size.height/2;
    self.headImageView.layer.masksToBounds = YES;
}
@end
