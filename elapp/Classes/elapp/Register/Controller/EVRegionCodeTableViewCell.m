//
//  EVRegionCodeTableViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVRegionCodeTableViewCell.h"
#import "PureLayout.h"
#import "EVRegionCodeModel.h"

#define CC_ABSOLUTE_IMAGE_W         414.0
#define CC_ABSOLUTE_IMAGE_H         736.0

@interface EVRegionCodeTableViewCell ()

@property (nonatomic, weak) UILabel *cityNameLabel;
@property (nonatomic, weak) UILabel *regionCodeLabel;

@end

@implementation EVRegionCodeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    [self.cityNameLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.regionCodeLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [self.cityNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:cc_absolute_y(20.0f)];
    [self.regionCodeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:cc_absolute_y(20.0f)];
}

- (void)setRegionCodeModel:(EVRegionCodeModel *)regionCodeModel
{
    _regionCodeModel = regionCodeModel;
    self.regionCodeLabel.text = [NSString stringWithFormat:@"+%@", _regionCodeModel.area_code];
    self.cityNameLabel.text = _regionCodeModel.contry_name;
}

#pragma mark - setter and getter
- (UILabel *)cityNameLabel
{
    if ( !_cityNameLabel )
    {
        UILabel *cityNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:cityNameLabel];
        _cityNameLabel = cityNameLabel;
    }
    return _cityNameLabel;
}

- (UILabel *)regionCodeLabel
{
    if ( !_regionCodeLabel )
    {
        UILabel *regionCodeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:regionCodeLabel];
        _regionCodeLabel = regionCodeLabel;
    }
    return _regionCodeLabel;
}

@end
