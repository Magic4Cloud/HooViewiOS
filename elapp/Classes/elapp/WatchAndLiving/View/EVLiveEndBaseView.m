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
    UIFont *labelFont = EVNormalFont(18);

    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IOS_bg"]];
    [self addSubview:bgImageView];
    [bgImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    CGFloat marginSide = cc_absolute_x(50);
    CGFloat marginLine = cc_absolute_y(4);
    CGFloat height = 45;
    CGFloat margin = cc_absolute_y(130.0);
    
    //tip
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"时长小于5分钟将不会被保存";
    tipLabel.textColor = [UIColor evTextColorH2];
    tipLabel.font = [UIFont systemFontOfSize:14.f];
    [bgImageView addSubview:tipLabel];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [tipLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [tipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:cc_absolute_y(120.0)];
    [tipLabel autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 20)];
    self.tipLabel = tipLabel;
    
    UILabel *liveTimeLabel = [[UILabel alloc] init];
    [bgImageView addSubview:liveTimeLabel];
    self.timeLabel = liveTimeLabel;
    liveTimeLabel.hidden = YES;
    [liveTimeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:tipLabel withOffset:0];
    [liveTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [liveTimeLabel autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 50)];
    liveTimeLabel.font = [UIFont systemFontOfSize:36.f];
    liveTimeLabel.textColor = [UIColor evMainColor];
    
    UILabel *tLabel = [[UILabel alloc] init];
    [bgImageView addSubview:tLabel];
    [tLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [tLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:liveTimeLabel withOffset:16];
    [tLabel autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 22)];
    tLabel.textColor = [UIColor evTextColorH2];
    tLabel.text  = @"直播时长";
    tLabel.hidden = YES;
    tLabel.textAlignment = NSTextAlignmentCenter;
    
    
    // line
//    UIView *riceCountLine = [self initialLine];
//    [bgImageView addSubview:riceCountLine];
//    [riceCountLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:marginSide];
//    [riceCountLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginSide];
//    [riceCountLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tipLabel withOffset:margin];
//
//    UIView *audienceCountLine = [self initialLine];
//    [bgImageView addSubview:audienceCountLine];
//    [audienceCountLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:marginSide];
//    [audienceCountLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginSide];
//    [audienceCountLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:tipLabel withOffset:margin + height];
//    
//    UIView *likeCountLine = [self initialLine];
//    [bgImageView addSubview:likeCountLine];
//    [likeCountLine autoSetDimension:ALDimensionHeight toSize:1];
//    [likeCountLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:marginSide];
//    [likeCountLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginSide];
//    [likeCountLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:tipLabel withOffset:margin + height * 2];
//    self.likeCountLine = likeCountLine;
//    
//    UIView *commentCountLine = [[UIView alloc] init];
//    [bgImageView addSubview:commentCountLine];
//    [commentCountLine autoSetDimension:ALDimensionHeight toSize:0.3];
//    [commentCountLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:marginSide];
//    [commentCountLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginSide];
//    [commentCountLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:tipLabel withOffset:margin + height * 3];
//    self.commentCountLine = commentCountLine;
    
    
    CGFloat labelWid  = 70;
    // 云票数
    UILabel *riceCountLabel = [self initialLabel];
    [bgImageView addSubview:riceCountLabel];
    riceCountLabel.font = EVNormalFont(18);
//    riceCountLabel.textAlignment = NSTextAlignmentLeft;
    [riceCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgImageView withOffset:50];
    [riceCountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tLabel withOffset:55];
    [riceCountLabel autoSetDimensionsToSize:CGSizeMake(labelWid, 25)];
    self.riceCountLabel = riceCountLabel;
    
    UILabel *riceUnitLabel = [self initialLabel];
    riceUnitLabel.text = @"观看人数";
    riceUnitLabel.font = EVNormalFont(16);
//    riceUnitLabel.textAlignment = NSTextAlignmentLeft;
    [bgImageView addSubview:riceUnitLabel];
    riceUnitLabel.textColor = [UIColor evTextColorH2];
    [riceUnitLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgImageView withOffset:50];
    [riceUnitLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:riceCountLabel withOffset:0];
    [riceUnitLabel autoSetDimensionsToSize:CGSizeMake(labelWid, 22)];
    
    // 观众数量
    UILabel *audienceCountLabel = [self initialLabel];
    [bgImageView addSubview:audienceCountLabel];
    [audienceCountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tLabel withOffset:55];
    [audienceCountLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [audienceCountLabel autoSetDimensionsToSize:CGSizeMake(labelWid, 25)];
    self.audienceCountLabel = audienceCountLabel;
    self.audienceUnitLabel.text = kE_GlobalZH(@"num_watch");
    
    UILabel *audienceUnitLabel = [self initialLabel];
    audienceUnitLabel.text = @"关注人数";
    [bgImageView addSubview:audienceUnitLabel];
    audienceUnitLabel.font = EVNormalFont(16);
    audienceUnitLabel.textColor = [UIColor evTextColorH2];
    [audienceUnitLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [audienceUnitLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:audienceCountLabel];
    [audienceUnitLabel autoSetDimensionsToSize:CGSizeMake(labelWid, 25)];
    self.audienceUnitLabel = audienceUnitLabel;
    
    // 赞
    UILabel *likeCountLabel = [self initialLabel];
    [bgImageView addSubview:likeCountLabel];
//    likeCountLabel.textAlignment = NSTextAlignmentRight;
    [likeCountLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgImageView withOffset:-50];
    [likeCountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tLabel withOffset:55];
    [likeCountLabel autoSetDimensionsToSize:CGSizeMake(labelWid, 25)];
    self.likeCountLabel = likeCountLabel;
    
    UILabel *likeCountUnitLabel = [self initialLabel];
    likeCountUnitLabel.text = @"火眼币";
    likeCountUnitLabel.font = EVNormalFont(16);
    likeCountUnitLabel.textColor = [UIColor evTextColorH2];
    [bgImageView addSubview:likeCountUnitLabel];
//    likeCountUnitLabel.textAlignment = NSTextAlignmentRight;
    [likeCountUnitLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgImageView withOffset:-50];
    [likeCountUnitLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:likeCountLabel];
     [likeCountUnitLabel autoSetDimensionsToSize:CGSizeMake(labelWid, 25)];
    
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
    label.textColor = [UIColor evMainColor];
    label.font = [UIFont systemFontOfSize:CCLiveEndBaseViewBUTTONFont];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}


@end
