//
//  EVDanmuView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVDanmuView.h"
#import "ALView+PureLayout.h"
#import "EVLoginInfo.h"
#import "NSString+Extension.h"

@interface EVDanmuView ()

@property (weak, nonatomic) UIImageView * avatarImageView;

@property (weak, nonatomic) UILabel * nicknameLabel;

@property (weak, nonatomic) UILabel * commentLabel;

@property (weak, nonatomic) UIView * labelView;

@end

@implementation EVDanmuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIImageView * avatarImageView = [[UIImageView alloc] init];
    avatarImageView.layer.cornerRadius = 35/2.0;
    avatarImageView.layer.masksToBounds = YES;
    [self addSubview:avatarImageView];
    [avatarImageView autoSetDimensionsToSize:CGSizeMake(35, 35)];
    [avatarImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [avatarImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    self.avatarImageView = avatarImageView;
    
    UILabel * commentLabel = [[UILabel alloc] init];
    commentLabel.textColor = [UIColor whiteColor];
    commentLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:commentLabel];
    [commentLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:1];
    [commentLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:avatarImageView withOffset:5];
    self.commentLabel = commentLabel;
    
    UIView * labelView = [[UIView alloc] init];
    labelView.backgroundColor = [UIColor blackColor];
    labelView.layer.cornerRadius = 19/2.0;
    labelView.layer.masksToBounds = YES;
    [self insertSubview:labelView belowSubview:avatarImageView];
    [labelView autoSetDimension:ALDimensionHeight toSize:19];
    [labelView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:commentLabel];
    [labelView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [labelView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:commentLabel withOffset:9];
    self.labelView = labelView;
    
    UILabel * nicknameLabel = [[UILabel alloc] init];
    nicknameLabel.textColor = [UIColor colorWithHexString:@"#FFE56B"];
    nicknameLabel.font = [UIFont systemFontOfSize:12];
    nicknameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    nicknameLabel.layer.shadowOffset = CGSizeMake(1, 1);
    nicknameLabel.layer.shadowOpacity = 0.5;
    nicknameLabel.layer.shadowRadius = 0.1;
    [self addSubview:nicknameLabel];
    [nicknameLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:labelView withOffset:-2];
    [nicknameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:avatarImageView withOffset:5];
    self.nicknameLabel = nicknameLabel;
    
    [labelView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:nicknameLabel withOffset:40 relation:NSLayoutRelationGreaterThanOrEqual];
}

- (void)tapAvatar
{
    self.avatarClick(self.model);
}

- (void)setModel:(EVDanmuModel *)model
{
    _model = model;
    [self.avatarImageView cc_setImageWithURLString:model.logo placeholderImage:nil];
    NSMutableAttributedString *contentAtt = [model.content cc_attributStringWithLineHeight:EVBoldFont(14).lineHeight];
    self.commentLabel.attributedText = contentAtt;
    self.nicknameLabel.text = model.nickname;
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    if ([loginInfo.name isEqualToString:model.name]) {
        self.labelView.backgroundColor = [UIColor colorWithHexString:@"#B58DF9" alpha:0.9];
    } else {
        self.labelView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.2];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = [[self.layer presentationLayer] frame];
    if (point.x >= rect.origin.x && point.x <= rect.origin.x+35 && point.y >= rect.origin.y && point.y <= rect.origin.y+35 && event.type == UIEventTypeTouches) {
        [self tapAvatar];
        return self;
    }
    return nil;
}

@end
