//
//  EVDanmuSwitch.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVDanmuSwitch.h"
#import "PureLayout.h"

@interface EVDanmuSwitch ()

@property (weak, nonatomic) UILabel * danmuLabel;

@property (weak, nonatomic) NSLayoutConstraint * labelLeftConstraint;

@end

@implementation EVDanmuSwitch

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
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4" alpha:0.8];
    UILabel * danmuLabel = [[UILabel alloc] init];
    danmuLabel.backgroundColor = [UIColor whiteColor];
    danmuLabel.textAlignment = NSTextAlignmentCenter;
    danmuLabel.textColor = [UIColor colorWithHexString:@"#403b37"];
    danmuLabel.font = [UIFont systemFontOfSize:12];
    danmuLabel.text = kE_GlobalZH(@"e_danmu");
    danmuLabel.layer.cornerRadius = 5;
    danmuLabel.layer.masksToBounds = YES;
    [self addSubview:danmuLabel];
    [danmuLabel autoSetDimensionsToSize:CGSizeMake(34, 29)];
    self.labelLeftConstraint = [danmuLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:2];
    [danmuLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:1];
    [danmuLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:1];
    self.danmuLabel = danmuLabel;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [UIColor colorWithHexString:@"#fb6655" alpha:0.8];
        self.danmuLabel.textColor = [UIColor colorWithHexString:@"#fb6655"];
        self.labelLeftConstraint.constant = 15;
        [UIView animateWithDuration:0.2f animations:^{
            [self layoutIfNeeded];
        }];
    } else {
        self.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4" alpha:0.8];
        self.danmuLabel.textColor = [UIColor colorWithHexString:@"#403b37"];
        self.labelLeftConstraint.constant = 1;
        [UIView animateWithDuration:0.2f animations:^{
            [self layoutIfNeeded];
        }];
    }
}

@end
