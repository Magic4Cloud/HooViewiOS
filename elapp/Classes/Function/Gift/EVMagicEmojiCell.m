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

@property (nonatomic, weak) UIView *backImageView;

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
    UIView *backImageView = [[UIView alloc] init];
    [self.contentView addSubview:backImageView];
    backImageView.backgroundColor = [UIColor whiteColor];
    _backImageView = backImageView;
    [backImageView autoSetDimensionsToSize:CGSizeMake(76, 76)];
    [backImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:-11];
    [backImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
   
    // 图片
    UIImageView *magicImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:magicImageView];
    [magicImageView autoSetDimensionsToSize:CGSizeMake(76, 76)];
    [magicImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:-11];
    [magicImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [magicImageView setBackgroundColor:[UIColor clearColor]];
    _magicImageView = magicImageView;
    magicImageView.layer.masksToBounds = YES;
    magicImageView.layer.cornerRadius = 6;
    magicImageView.layer.borderColor = [UIColor colorWithHexString:@"#f8f8f8"].CGColor;
    magicImageView.layer.borderWidth = 1.f;
    
    // 价格
    UIButton *priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    priceBtn.transform = CGAffineTransformMakeRotation(M_PI);
    priceBtn.titleLabel.transform = CGAffineTransformMakeRotation(M_PI);
    priceBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    [self.contentView addSubview:priceBtn];
    [priceBtn setTitleColor:[UIColor evTextColorH2] forState:UIControlStateNormal];
    priceBtn.titleLabel.font = EVNormalFont(14);
    [priceBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [priceBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:magicImageView withOffset:4];
    _priceBtn = priceBtn;
    
    // 经验值
    UILabel *experienceLabel = [[UILabel alloc] init];
    experienceLabel.textColor = [UIColor liveBackColor];
    experienceLabel.font = EVNormalFont(12);
    [self.contentView addSubview:experienceLabel];
    [experienceLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [experienceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:priceBtn withOffset:1];
    _experienceLabel = experienceLabel;
    
//    // 标记是否选中
//    UIButton *flagButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.contentView addSubview:flagButton];
//    [flagButton setImage:[UIImage imageNamed:@"living_icon_link"] forState:UIControlStateSelected];
//    [flagButton setImage:[UIImage imageNamed:@"living_icon_link_nor"] forState:UIControlStateNormal];
//    [flagButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:magicImageView];
//    [flagButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:4];
//    _flagButton = flagButton;
}

- (void)setModel:(EVStartGoodModel *)model
{
    _model = model;
    NSString *magicImagePath = PRESENTFILEPATH([model.pic md5String]);
    self.magicImageView.image = [UIImage imageWithContentsOfFile:magicImagePath];
    [self.priceBtn setTitle:model.name forState:(UIControlStateNormal)];
//    [self.priceBtn setTitle:[NSString stringWithFormat:@"%zd", model.cost] forState:UIControlStateNormal];
    self.experienceLabel.text = [NSString stringWithFormat:@"%zd火眼豆", model.cost];
//    self.flagButton.selected = model.selected;
    if (model.selected) {
        _magicImageView.layer.masksToBounds = YES;
        _magicImageView.layer.cornerRadius = 6;
        _magicImageView.layer.borderColor = [UIColor liveBackColor].CGColor;
        _magicImageView.layer.borderWidth = 1.f;
        _magicImageView.backgroundColor = [UIColor clearColor];
        _backImageView.backgroundColor = [UIColor liveBackColor];
        _backImageView.alpha = 0.2;
        _backImageView.layer.masksToBounds = YES;
    }else {
        _magicImageView.layer.masksToBounds = YES;
        _magicImageView.layer.cornerRadius = 6;
        _magicImageView.layer.borderColor = [UIColor colorWithHexString:@"#f8f8f8"].CGColor;
        _magicImageView.layer.borderWidth = 1.f;
        _backImageView.backgroundColor = [UIColor whiteColor];
        _magicImageView.backgroundColor = [UIColor clearColor];
        _backImageView.alpha = 1;
    }
}

@end
