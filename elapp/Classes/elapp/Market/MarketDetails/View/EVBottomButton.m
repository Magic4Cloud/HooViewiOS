//
//  EVBottomButton.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/6.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVBottomButton.h"


@interface EVBottomButton ()

@property (nonatomic, assign) CGFloat ImageWid;

@property (nonatomic, assign) CGFloat ImageHig;

@property (nonatomic, weak) UIImageView *topImage;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *countLabel;

@property (nonatomic, copy) NSString *nomalTitle;
@property (nonatomic, copy) NSString *selectTitle;
@property (nonatomic, copy) UIImage *selectImage;
@property (nonatomic, copy) UIImage *nomalImage;

@property (nonatomic, strong) NSLayoutConstraint *layoutWidF;

@end

@implementation EVBottomButton

- (instancetype)initWithSelectImage:(UIImage *)image nomalImg:(UIImage *)nomalImg selectTitle:(NSString *)selectTitle nomalTitle:(NSString *)title;
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
      
        self.ImageWid = nomalImg.size.width;
        self.ImageHig = nomalImg.size.height;
        self.nomalImage = nomalImg;
        self.selectImage = image;
        self.nomalTitle = title;
        self.selectTitle = selectTitle;
        [self addUpViewNomalImg:nomalImg];
    }
    return self;
}

- (void)addUpViewNomalImg:(UIImage *)nomalImg
{
    [self addTarget:self action:@selector(bottomButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIImageView *topImage = [[UIImageView alloc] init];
    [self addSubview:topImage];
    self.topImage  = topImage;
    topImage.image = nomalImg;
    [topImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:2];
    [topImage autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [topImage autoSetDimensionsToSize:CGSizeMake(self.ImageWid, self.ImageHig)];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    self.nameLabel = titleLabel;
    titleLabel.text = self.nomalTitle;
    [titleLabel setFont:[UIFont systemFontOfSize:12.]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor evTextColorH2];
    [titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:topImage];
    [titleLabel autoSetDimensionsToSize:CGSizeMake(80, 17)];
    [titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    titleLabel.hidden = YES;
    
    UILabel *countLabel = [[UILabel alloc] init];
    [self addSubview:countLabel];
    self.countLabel = countLabel;
    countLabel.layer.cornerRadius = 6;
    countLabel.clipsToBounds = YES;
    countLabel.hidden  = YES;
    countLabel.font = [UIFont systemFontOfSize:10.f];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.backgroundColor = [UIColor colorWithHexString:@"#FF772D"];
    [countLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:13];
    [countLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7];
   self.layoutWidF =  [countLabel autoSetDimension:ALDimensionWidth toSize:12];
    [countLabel autoSetDimension:ALDimensionHeight toSize:12];
    
}

- (void)bottomButton:(UIButton *)btn
{
   
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(buttonItem:tag:)]) {
        [self.delegate buttonItem:btn tag:self.tag];
    }
    if ([self.nameLabel.text isEqualToString:@"收藏"] || [self.nameLabel.text isEqualToString:@"自选"]) {
        if (btn.selected == YES) {
            self.topImage.image = self.nomalImage;
            self.nameLabel.text = self.nomalTitle;
            self.nameLabel.textColor = [UIColor evTextColorH2];
        }else {
            self.topImage.image = self.selectImage;
            self.nameLabel.text = self.selectTitle;
        }
    }
}

- (void)setIsCollec:(BOOL)isCollec
{
//    _isCollec = isCollec;
//    if ([self.nameLabel.text isEqualToString:@"收藏"] || [self.nameLabel.text isEqualToString:@"自选"]) {
    
//    }
}

- (void)updateIsCollec:(BOOL)iscollec bottomBtn:(EVBottomButton *)bottomBtn
{
    if (iscollec == YES) {
        bottomBtn.topImage.image = self.selectImage;
        bottomBtn.nameLabel.text = self.selectTitle;
        bottomBtn.nameLabel.textColor = [UIColor colorWithHexString:@"FFB41C"];
   
    }else {
        bottomBtn.topImage.image = self.nomalImage;
        bottomBtn.nameLabel.text = self.nomalTitle;
        bottomBtn.nameLabel.textColor = [UIColor evTextColorH2];
    }
}

- (void)setHideCountL:(BOOL)hideCountL
{
    if (hideCountL == YES && [self.nomalTitle isEqualToString:@"评论"]) {
        self.countLabel.hidden = NO;
    }else {
        self.countLabel.hidden = YES;
    }
}

- (void)setCommentCount:(NSInteger)commentCount
{
    NSString *countStr = [NSString stringWithFormat:@"%ld",commentCount];
    self.countLabel.text = countStr;
    CGSize sizeOfText = [self.countLabel sizeThatFits:CGSizeZero];
   
    self.layoutWidF.constant = sizeOfText.width+10;
}
- (void)buttonItem:(UIButton *)btn
{
    [self bottomButton:btn];
}
@end
