//
//  EVMagicEmojiCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVMagicEmojiCell.h"
#import <PureLayout.h>
#import "EVMagicEmojiModel.h"
#import "EVStartGoodModel.h"
#import "EVStartResourceTool.h"
#import "NSString+Extension.h"

@interface EVMagicEmojiCell ()

/** 图片 */
@property (nonatomic, weak) UIImageView *magicImageView;

/** 显示价格的label */
@property (nonatomic, weak) UIButton *priceBtn;

/** 经验值label */
@property ( nonatomic, weak ) UILabel *experienceLabel;

/** 标记是否选中 */
@property (nonatomic, weak) UIButton *flagButton;

@end

@implementation EVMagicEmojiCell

// 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpSubviews];
    }
    return self;
}

// 添加子视图
- (void)setUpSubviews
{
    // 图片
    UIImageView *magicImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:magicImageView];
    [magicImageView autoSetDimensionsToSize:CGSizeMake(70, 60)];
    [magicImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:-11];
    [magicImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    _magicImageView = magicImageView;
    
    // 价格
    UIButton *priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    priceBtn.transform = CGAffineTransformMakeRotation(M_PI);
    priceBtn.titleLabel.transform = CGAffineTransformMakeRotation(M_PI);
    priceBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    [self.contentView addSubview:priceBtn];
    [priceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    priceBtn.titleLabel.font = CCNormalFont(12);
    [priceBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [priceBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:magicImageView withOffset:0];
    _priceBtn = priceBtn;
    
    // 经验值
    UILabel *experienceLabel = [[UILabel alloc] init];
    experienceLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:.6];
    experienceLabel.font = CCNormalFont(8);
    [self.contentView addSubview:experienceLabel];
    [experienceLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [experienceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:priceBtn withOffset:1];
    _experienceLabel = experienceLabel;
    
    // 标记是否选中
    UIButton *flagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:flagButton];
    [flagButton setImage:[UIImage imageNamed:@"living_icon_link"] forState:UIControlStateSelected];
    [flagButton setImage:[UIImage imageNamed:@"living_icon_link_nor"] forState:UIControlStateNormal];
    [flagButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:magicImageView];
    [flagButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:4];
    _flagButton = flagButton;
}


// model 可更改
- (void)setModel:(EVStartGoodModel *)model
{
    _model = model;
    NSString *magicImagePath = PRESENTFILEPATH([model.pic md5String]);
    self.magicImageView.image = [UIImage imageWithContentsOfFile:magicImagePath];
    [self.priceBtn setImage:model.costImage forState:UIControlStateNormal];
    [self.priceBtn setTitle:[NSString stringWithFormat:@"%zd", model.cost] forState:UIControlStateNormal];
    self.experienceLabel.text = [NSString stringWithFormat:@"+%zd%@", model.exp,kE_GlobalZH(@"point_exp")];
    self.flagButton.selected = model.selected;
}

@end
