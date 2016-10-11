//
//  EVLimitFiendCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLimitFiendCell.h"
#import <PureLayout.h>

@interface EVLimitFiendCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@property (weak, nonatomic) IBOutlet UIImageView *userLogo;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@end

@implementation EVLimitFiendCell

- (void)awakeFromNib
{
    self.selectedButton.layer.cornerRadius = self.selectedButton.bounds.size.width * 0.5;
    self.selectedButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.selectedButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.selectedButton.clipsToBounds = YES;
    self.selectedButton.userInteractionEnabled = NO;
    
    [self.selectedButton setBackgroundImage:[UIImage imageNamed:@"living_ready_limit_icon_friend_select"] forState:UIControlStateSelected];
    
    UIView *seperator = [[UIView alloc] init];
    seperator.backgroundColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    [self.contentView addSubview:seperator];
    [seperator autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [seperator autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:62];
    [seperator autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [seperator autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
}

- (void)setFriendItem:(EVFriendItem *)friendItem{
    _friendItem = friendItem;
    self.selectedButton.selected = friendItem.selected;
    self.selectedButton.layer.borderWidth = friendItem.selected ? 0 : 1;
    [self.userLogo cc_setRoundImageWithDefaultPlaceHoderURLString:friendItem.logourl];
    if ( ![_friendItem.remarks isEqualToString:@""] && _friendItem.remarks )
    {
        self.nickNameLabel.text = friendItem.remarks;
    }
    else
    {
        self.nickNameLabel.text = friendItem.nickname;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ( self.userLogo.frame.size.width )
    {
        self.userLogo.layer.cornerRadius = 0.5 * self.userLogo.frame.size.width;
        self.userLogo.clipsToBounds = YES;
    }
}

@end
