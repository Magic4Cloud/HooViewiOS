//
//  EVMineBottomViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/26.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVMineBottomViewCell.h"


@interface EVMineBottomViewCell ()



@end


@implementation EVMineBottomViewCell

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
    UIImageView *topImageView = [[UIImageView alloc] init];
    [self addSubview:topImageView];
    self.topImageView = topImageView;
    topImageView.image = [UIImage imageNamed:@"ic_message"];
    [topImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [topImageView autoSetDimensionsToSize:CGSizeMake(20, 20)];
    [topImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    
    UIButton *readBtn = [[UIButton alloc] init];
    [topImageView addSubview:readBtn];
    self.readBtn = readBtn;
    readBtn.enabled = NO;
    [readBtn autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [readBtn autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [readBtn autoSetDimensionsToSize:CGSizeMake(14, 14)];
    readBtn.layer.cornerRadius = 7;
    readBtn.layer.masksToBounds  = YES;
    readBtn.hidden = YES;
    [readBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [readBtn setTitle:@"n" forState:(UIControlStateNormal)];
    readBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
    readBtn.backgroundColor = [UIColor colorWithHexString:@"#FF772D"];
    
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:12.f];
    [nameLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [nameLabel autoSetDimensionsToSize:CGSizeMake(ScreenWidth/4, 20)];
    [nameLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    [self addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = [UIFont systemFontOfSize:16.f];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [moneyLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [moneyLabel autoSetDimensionsToSize:CGSizeMake(ScreenWidth/4, 22)];
    [moneyLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    
    
    _separateLineView = [UIView new];
    _separateLineView.backgroundColor = [UIColor evLineColor];
    [self addSubview:_separateLineView];
    [_separateLineView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_separateLineView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13];
    [_separateLineView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:13];
    [_separateLineView autoSetDimension:ALDimensionWidth toSize:1];
}

- (void)setUnreadCount:(NSUInteger)unreadCount {
    _unreadCount = unreadCount;
    
    if (unreadCount > 0) {
        self.topImageView.image = [UIImage imageNamed:@"ic_newmessage"];
        self.readBtn.hidden = NO;
        [self.readBtn setTitle:[NSString stringWithFormat:@"%ld", unreadCount] forState:UIControlStateNormal];
    }
    else {
        self.topImageView.image = [UIImage imageNamed:@"ic_message"];
        self.readBtn.hidden = YES;
    }
}

@end
