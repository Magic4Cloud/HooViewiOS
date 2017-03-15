//
//  EVSelfGlobalViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/29.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVSelfGlobalViewCell.h"


@interface EVSelfGlobalViewCell ()


@end

@implementation EVSelfGlobalViewCell

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
    UIView *hvContentView = [[UIView alloc] init];
    hvContentView.frame = CGRectMake(5, 5, (ScreenWidth-30)/3, 44);
    hvContentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:hvContentView];
    hvContentView.layer.borderColor = [UIColor colorWithHexString:@"#d9d9d9"].CGColor;
    hvContentView.layer.borderWidth = 1;
    hvContentView.layer.masksToBounds = YES;
    hvContentView.layer.cornerRadius = 4;
    self.hvContentView = hvContentView;
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(0, 0,(ScreenWidth-30)/3, 44);
    nameLabel.backgroundColor = [UIColor whiteColor];
    nameLabel.textColor = [UIColor evTextColorH2];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont textFontB2];
    [hvContentView addSubview:nameLabel];
//    nameLabel.text = @"测试";
    self.nameLabel = nameLabel;
}


- (void)setStatus:(BOOL)status
{
    _status = status;
    self.nameLabel.textColor = status ? [UIColor whiteColor] : [UIColor evTextColorH2];
    self.nameLabel.backgroundColor = status ? [UIColor evMainColor] : [UIColor whiteColor];
    
}

- (void)setStockBaseModel:(EVStockBaseModel *)stockBaseModel
{
    _stockBaseModel = stockBaseModel;
    self.nameLabel.text = stockBaseModel.name;
    self.nameLabel.textColor = stockBaseModel.status ? [UIColor whiteColor] : [UIColor evTextColorH2];
    self.nameLabel.backgroundColor = stockBaseModel.status ? [UIColor evMainColor] : [UIColor whiteColor];
}

@end
