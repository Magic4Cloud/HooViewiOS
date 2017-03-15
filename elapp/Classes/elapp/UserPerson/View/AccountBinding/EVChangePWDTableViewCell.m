//
//  EVChangePWDTableViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVChangePWDTableViewCell.h"
#import <PureLayout.h>

#define CCChangePWDTableViewCellID @"CCChangePWDTableViewCellID"
#define CCChangePWDTableViewCellHeight 55.0f

@implementation EVChangePWDTableViewCell

#pragma mark - public class methods

+ (NSString *)cellID
{
    return CCChangePWDTableViewCellID;
}

+ (CGFloat)cellHeight
{
    return CCChangePWDTableViewCellHeight;
}


#pragma mark - life circle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self addCustomSubviews];
    }
    
    return self;
}


#pragma mark - prvivate methods

- (void)addCustomSubviews
{
    UILabel *title = [UILabel labelWithDefaultTextColor:[UIColor textBlackColor] font:EVNormalFont(14.0f)];
    title.text = kE_GlobalZH(@"motify_password");
    [self.contentView addSubview:title];
    [title autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0f, 16.0f, .0f, .0f) excludingEdge:ALEdgeRight];
    
    UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_icon_next"]];
    [self.contentView addSubview:indicator];
    [indicator autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:16.0f];
    [indicator autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
}

@end
