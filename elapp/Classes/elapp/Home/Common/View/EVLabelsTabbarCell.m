//
//  EVLabelsTabbarCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVLabelsTabbarCell.h"
#import "EVLabelsTabbarItem.h"
#import <PureLayout.h>

@interface EVLabelsTabbarCell ()

@property (nonatomic,weak) UIButton *titleButton;

@end

@implementation EVLabelsTabbarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    UIButton *titleButton = [[UIButton alloc] init];
    titleButton.userInteractionEnabled = NO;
    [self.contentView addSubview:titleButton];
    titleButton.titleLabel.font = [[CCAppSetting shareInstance] normalFontWithSize:15];
    [titleButton autoCenterInSuperview];
    self.titleButton = titleButton;
    [titleButton setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
    [titleButton setTitleColor:CCAppMainColor forState:UIControlStateSelected];
}

- (void)setItem:(EVLabelsTabbarItem *)item
{
    _item = item;
    self.titleButton.selected = item.selected;
    [self.titleButton setTitle:item.title forState:UIControlStateNormal];
    [self.titleButton setTitle:item.title forState:UIControlStateSelected];
}

@end
