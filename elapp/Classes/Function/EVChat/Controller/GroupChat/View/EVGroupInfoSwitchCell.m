//
//  EVGroupInfoSwitchCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVGroupInfoSwitchCell.h"
#import <PureLayout.h>
#import "EVGroupInfoModel.h"

@interface EVGroupInfoSwitchCell ()

@property (weak, nonatomic)UISwitch *aSwitch ;

@end

@implementation EVGroupInfoSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        UISwitch *aSwitch = [[UISwitch alloc] init];
        self.aSwitch = aSwitch;
        aSwitch.onTintColor = CCAppMainColor;
        [self.contentView addSubview:aSwitch];
        [aSwitch autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [aSwitch autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [aSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)setCellItem:(EVGroupInfoModel *)cellItem
{
    [super setCellItem:cellItem];
    self.aSwitch.on = cellItem.isBlock;
    self.aSwitch.enabled = !cellItem.isOwner;
}

- (void)valueChanged:(UISwitch *)aSwith
{
    if ( self.action )
    {
        self.action(aSwith);
    }
}

@end
