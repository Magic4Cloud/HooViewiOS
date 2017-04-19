//
//  EVMineTableViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/26.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVMineTableViewCell.h"
#import "EVLineView.h"


@interface EVMineTableViewCell ()

@property (nonatomic, weak) UIImageView *iconImageView;

@property (nonatomic, weak) UILabel *nameLabel;

@end

@implementation EVMineTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    
    self.contentView.clipsToBounds = YES;
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    [iconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:18];
    [iconImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [iconImageView autoSetDimensionsToSize:CGSizeMake(30, 30)];

    UILabel *nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    nameLabel.textColor = [UIColor colorWithHexString:@"#303030"];
    nameLabel.font = [UIFont textFontB2];
    [nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconImageView withOffset:8.f];
    [nameLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [nameLabel autoSetDimensionsToSize:CGSizeMake(100, 22)];
    
    
    UIImageView *nextImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:nextImageView];
    [nextImageView autoSetDimensionsToSize:CGSizeMake(40, 40)];
    [nextImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:16];
    [nextImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    nextImageView.image = [UIImage imageNamed:@"btn_next_n"];

}

- (void)setCellImage:(NSString *)image name:(NSString *)name
{
    [self.iconImageView setImage:[UIImage imageNamed:image]];
    self.nameLabel.text = name;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
