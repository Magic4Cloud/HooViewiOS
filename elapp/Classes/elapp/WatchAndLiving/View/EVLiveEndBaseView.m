//
//  EVLiveEndBaseView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLiveEndBaseView.h"
#import <PureLayout.h>

#define CC_ABSOLUTE_IMAGE_W     414.0
#define CC_ABSOLUTE_IMAGE_H     736.0

@interface EVLiveEndBaseView ()

@property (nonatomic,weak) UILabel *audienceUnitLabel;

@end

@implementation EVLiveEndBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self setSuperUpViews];
    }
    return self;
}

- (void)setSuperUpViews
{
    UIFont *labelFont = CCNormalFont(18);

    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_icon_screen"]];
    [self addSubview:bgImageView];
    [bgImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    CGFloat marginSide = cc_absolute_x(50);
    CGFloat marginLine = cc_absolute_y(4);
    CGFloat height = 45;
    CGFloat margin = cc_absolute_y(130.0);
    
    //tip
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = kE_GlobalZH(@"living_end");
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:26.f];
    [bgImageView addSubview:tipLabel];
    [tipLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [tipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:cc_absolute_y(120.0)];
    self.tipLabel = tipLabel;
    
    // line
    UIView *riceCountLine = [self initialLine];
    [bgImageView addSubview:riceCountLine];
    [riceCountLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:marginSide];
    [riceCountLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginSide];
    [riceCountLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tipLabel withOffset:margin];
    
    UIView *audienceCountLine = [self initialLine];
    [bgImageView addSubview:audienceCountLine];
    [audienceCountLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:marginSide];
    [audienceCountLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginSide];
    [audienceCountLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:tipLabel withOffset:margin + height];
    
    UIView *likeCountLine = [self initialLine];
    [bgImageView addSubview:likeCountLine];
    [likeCountLine autoSetDimension:ALDimensionHeight toSize:1];
    [likeCountLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:marginSide];
    [likeCountLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginSide];
    [likeCountLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:tipLabel withOffset:margin + height * 2];
    self.likeCountLine = likeCountLine;
    
    UIView *commentCountLine = [[UIView alloc] init];
    [bgImageView addSubview:commentCountLine];
    [commentCountLine autoSetDimension:ALDimensionHeight toSize:0.3];
    [commentCountLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:marginSide];
    [commentCountLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginSide];
    [commentCountLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:tipLabel withOffset:margin + height * 3];
    self.commentCountLine = commentCountLine;
    
    // 云票数
    UILabel *riceCountLabel = [self initialLabel];
    [bgImageView addSubview:riceCountLabel];
    riceCountLabel.font = CCNormalFont(30);
    [riceCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgImageView withOffset:marginSide];
    [riceCountLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:riceCountLine withOffset:5 -marginLine];
    self.riceCountLabel = riceCountLabel;
    
    UILabel *riceUnitLabel = [self initialLabel];
    riceUnitLabel.text = kE_GlobalZH(@"num_ticket");
    riceUnitLabel.font = labelFont;
    [bgImageView addSubview:riceUnitLabel];
    [riceUnitLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:riceCountLine];
    [riceUnitLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:riceCountLine withOffset: - marginLine];
    
    // 观众数量
    UILabel *audienceCountLabel = [self initialLabel];
    [bgImageView addSubview:audienceCountLabel];
    [audienceCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgImageView withOffset:marginSide];
    [audienceCountLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:audienceCountLine withOffset:- marginLine];
    self.audienceCountLabel = audienceCountLabel;
    self.audienceUnitLabel.text = kE_GlobalZH(@"num_watch");
    
    UILabel *audienceUnitLabel = [self initialLabel];
    audienceUnitLabel.text = kE_GlobalZH(@"num_watch");
    [bgImageView addSubview:audienceUnitLabel];
    audienceUnitLabel.font = labelFont;
    [audienceUnitLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:audienceCountLine];
    [audienceUnitLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:audienceCountLabel];
    self.audienceUnitLabel = audienceUnitLabel;
    
    // 赞
    UILabel *likeCountLabel = [self initialLabel];
    [bgImageView addSubview:likeCountLabel];
    [likeCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgImageView withOffset:marginSide];
    [likeCountLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:likeCountLine withOffset:-marginLine];
    self.likeCountLabel = likeCountLabel;
    
    UILabel *likeCountUnitLabel = [self initialLabel];
    likeCountUnitLabel.text = kE_GlobalZH(@"num_zan");
    likeCountUnitLabel.font = labelFont;
    [bgImageView addSubview:likeCountUnitLabel];
    [likeCountUnitLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:audienceCountLine];
    [likeCountUnitLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:likeCountLabel];
    
    // 评论
//    UILabel *commentCountLabel = [self initialLabel];
//    [bgImageView addSubview:commentCountLabel];
//    [commentCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgImageView withOffset:marginSide];
//    [commentCountLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:commentCountLine withOffset:-marginLine];
//    self.commentCountLabel = commentCountLabel;
//    
//    UILabel *commentCountUnitLabel = [self initialLabel];
//    commentCountUnitLabel.text = @"条评论";
//    [bgImageView addSubview:commentCountUnitLabel];
//    [commentCountUnitLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:commentCountLine];
//    [commentCountUnitLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:commentCountLabel];
}

- (UIView *)initialLine
{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor evLineColor];
    [line autoSetDimension:ALDimensionHeight toSize:.5f];
    return line;
}

- (UILabel *)initialLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"0";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:CCLiveEndBaseViewBUTTONFont];
    return label;
}


@end
