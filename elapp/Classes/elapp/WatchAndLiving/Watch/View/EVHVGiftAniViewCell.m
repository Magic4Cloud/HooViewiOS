//
//  EVHVGiftAniViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/11.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVGiftAniViewCell.h"


@interface EVHVGiftAniViewCell ()

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *giftCountLabel;

@property (nonatomic, weak) UIView *backView;

@end

@implementation EVHVGiftAniViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [self addSubview:view];
    self.backView  = view;
    view.backgroundColor = [UIColor colorWithHexString:@"66b5ff"];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 4.f;
    view.alpha = 0.7;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [self addSubview:nameLabel];
    nameLabel.frame = CGRectMake(0, 0, 80, 20);
    nameLabel.font = [UIFont systemFontOfSize:14.f];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel = nameLabel;
    nameLabel.transform = CGAffineTransformMakeRotation(M_PI);
    
    
    
    UILabel *giftCountLabel = [[UILabel alloc] init];
    giftCountLabel.frame = CGRectMake(0, 20, 80, 20);
    [self addSubview:giftCountLabel];
    giftCountLabel.font = [UIFont systemFontOfSize:14.f];
    giftCountLabel.textColor = [UIColor whiteColor];
    self.giftCountLabel = giftCountLabel;
    giftCountLabel.textAlignment = NSTextAlignmentCenter;
    giftCountLabel.transform = CGAffineTransformMakeRotation(M_PI);
    
}

- (void)setStartGoodModel:(EVStartGoodModel *)startGoodModel
{
    _startGoodModel = startGoodModel;
    self.backView.backgroundColor = [UIColor colorWithHexString:startGoodModel.colorStr];
    self.nameLabel.text = startGoodModel.giftName;
    self.giftCountLabel.text = startGoodModel.name;
}

@end
