//
//  EVUserTagsView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/14.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVUserTagsView.h"

@interface EVUserTagsView ()
@property (nonatomic, weak) UILabel *oneLabel;
@property (nonatomic, weak) UILabel *twoLabel;
@property (nonatomic, weak) UILabel *threeLabel;


@property (nonatomic, strong) NSLayoutConstraint *oneLabelWid;
@property (nonatomic, strong) NSLayoutConstraint *twoLabelWid;

@property (nonatomic, strong) NSLayoutConstraint *threeLabelWid;

@property (nonatomic, assign) BOOL isCenterTags;

@end


@implementation EVUserTagsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isCenterTags = NO;
        [self addUpView];
    }
    return self;
}

- (instancetype)initWithCenterFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self addUpView];
        self.isCenterTags = YES;
    }
    return self;
}
- (void)addUpView
{
    UILabel *oneLabel = [[UILabel alloc] init];
    [self setUpLabel:oneLabel];
   
    [self addSubview:oneLabel];
     self.oneLabel = oneLabel;
    self.oneLabel.hidden = YES;
    [oneLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [oneLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
    self.oneLabelWid =  [oneLabel autoSetDimension:ALDimensionWidth toSize:10];
    [oneLabel autoSetDimension:ALDimensionHeight toSize:20];

    UILabel *twoLabel = [[UILabel alloc] init];
    [self setUpLabel:twoLabel];
    [self addSubview:twoLabel];
    self.twoLabel = twoLabel;
    self.twoLabel.hidden = YES;
    [twoLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:oneLabel withOffset:5];
    [twoLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
    self.twoLabelWid =   [twoLabel autoSetDimension:ALDimensionWidth toSize:10];
    [twoLabel autoSetDimension:ALDimensionHeight toSize:20];
    
    UILabel *threeLabel = [[UILabel alloc] init];
    [self setUpLabel:threeLabel];
    [self addSubview:threeLabel];
    self.threeLabel = threeLabel;
    self.threeLabel.hidden = YES;
    [threeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:twoLabel withOffset:5];
    [threeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
    self.threeLabelWid =  [threeLabel autoSetDimension:ALDimensionWidth toSize:10];
    [threeLabel autoSetDimension:ALDimensionHeight toSize:20];
}

- (void)setUpLabel:(UILabel *)label
{
    label.layer.cornerRadius = 4;
    label.clipsToBounds = YES;
//    label.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    label.textColor = [UIColor colorWithHexString:@"#4281AD"];
    label.font = [UIFont systemFontOfSize:14.f];
    label.textAlignment = NSTextAlignmentCenter;
}


- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    if (self.isCenterTags) {
        [self centerTagsViewDataArray:dataArray];
    }else {
         [self labelAddTextDataArray:dataArray];
    }
   
}

- (void)centerTagsViewDataArray:(NSMutableArray *)dataArray
{
    switch (dataArray.count) {
        case 1:
        {
            UILabel *oneLabel = [[UILabel alloc] init];
            [self setUpLabel:oneLabel];
            [self addSubview:oneLabel];
            oneLabel.text = [NSString stringWithFormat:@"%@",dataArray[0]];
            [oneLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [oneLabel autoSetDimension:ALDimensionWidth toSize:([oneLabel sizeThatFits:CGSizeZero].width+10)];
            [oneLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [oneLabel autoSetDimension:ALDimensionHeight toSize:20.];
        }
            break;
        case 2:
        {
            UILabel *oneLabel = [[UILabel alloc] init];
            [self setUpLabel:oneLabel];
            [self addSubview:oneLabel];
            oneLabel.text = [NSString stringWithFormat:@"%@",dataArray[0]];
            [oneLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:ScreenWidth/2 + 4];
            [oneLabel autoSetDimension:ALDimensionWidth toSize:([oneLabel sizeThatFits:CGSizeZero].width+10)];
            [oneLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [oneLabel autoSetDimension:ALDimensionHeight toSize:20.];
            
            
            UILabel *twoLabel = [[UILabel alloc] init];
            [self setUpLabel:twoLabel];
            [self addSubview:twoLabel];
            twoLabel.text = [NSString stringWithFormat:@"%@",dataArray[1]];
            [twoLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:ScreenWidth/2 + 4];
            [twoLabel autoSetDimension:ALDimensionWidth toSize:([twoLabel sizeThatFits:CGSizeZero].width+10)];
            [twoLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [twoLabel autoSetDimension:ALDimensionHeight toSize:20.];
            
        }
            break;
        case 3:
        {
            
            UILabel *twoLabel = [[UILabel alloc] init];
            [self setUpLabel:twoLabel];
            [self addSubview:twoLabel];
            twoLabel.text = [NSString stringWithFormat:@"%@",dataArray[1]];
            [twoLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [twoLabel autoSetDimension:ALDimensionWidth toSize:([twoLabel sizeThatFits:CGSizeZero].width+10)];
            [twoLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [twoLabel autoSetDimension:ALDimensionHeight toSize:20.];
            
            
            UILabel *oneLabel = [[UILabel alloc] init];
            [self setUpLabel:oneLabel];
            [self addSubview:oneLabel];
            oneLabel.text = [NSString stringWithFormat:@"%@",dataArray[0]];
            [oneLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:twoLabel withOffset:-8];
            [oneLabel autoSetDimension:ALDimensionWidth toSize:([oneLabel sizeThatFits:CGSizeZero].width+10)];
            [oneLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [oneLabel autoSetDimension:ALDimensionHeight toSize:20.];
            
            
            
            UILabel *threeLabel = [[UILabel alloc] init];
            [self setUpLabel:threeLabel];
            [self addSubview:threeLabel];
            threeLabel.text = [NSString stringWithFormat:@"%@",dataArray[2]];
             [threeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:twoLabel withOffset:8];
            [threeLabel autoSetDimension:ALDimensionWidth toSize:([threeLabel sizeThatFits:CGSizeZero].width+10)];
            [threeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [threeLabel autoSetDimension:ALDimensionHeight toSize:20.];
        }
            break;
        default:
            break;
    }
}


- (void)labelAddTextDataArray:(NSMutableArray *)dataArray
{
    if (dataArray.count <= 0) {
        self.oneLabel.hidden = YES;
        self.twoLabel.hidden = YES;
        self.threeLabel.hidden = YES;
    }else if (dataArray.count == 1) {
        self.twoLabel.hidden = YES;
        self.threeLabel.hidden = YES;
        self.oneLabel.hidden = NO;
        self.oneLabel.text = [NSString stringWithFormat:@"%@",dataArray[0]];
        self.oneLabelWid.constant = [self.oneLabel sizeThatFits:CGSizeZero].width + 10;
        
    }else if (dataArray.count == 2) {
        
        self.twoLabel.hidden = NO;
        self.threeLabel.hidden = YES;
        self.oneLabel.hidden = NO;
        self.oneLabel.text = [NSString stringWithFormat:@"%@",dataArray[0]];
        self.twoLabel.text = [NSString stringWithFormat:@"%@",dataArray[1]];
        self.oneLabelWid.constant = [self.oneLabel sizeThatFits:CGSizeZero].width + 10;
        self.twoLabelWid.constant = [self.twoLabel sizeThatFits:CGSizeZero].width + 10;
        
    }else if (dataArray.count >= 3) {
        
        self.twoLabel.hidden = NO;
        self.threeLabel.hidden = NO;
        self.oneLabel.hidden = NO;
        self.oneLabel.text = [NSString stringWithFormat:@"%@",dataArray[0]];
        self.twoLabel.text = [NSString stringWithFormat:@"%@",dataArray[1]];
        self.threeLabel.text = [NSString stringWithFormat:@"%@",dataArray[2]];
        self.oneLabelWid.constant = [self.oneLabel sizeThatFits:CGSizeZero].width+10;
        self.twoLabelWid.constant = [self.twoLabel sizeThatFits:CGSizeZero].width+10;
        self.threeLabelWid.constant = [self.threeLabel sizeThatFits:CGSizeZero].width+10;
    }
}

@end
