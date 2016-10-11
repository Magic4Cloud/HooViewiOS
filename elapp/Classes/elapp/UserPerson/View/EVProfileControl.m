//
//  EVProfileControl.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVProfileControl.h"
#import <PureLayout.h>

@interface EVProfileControl ()

@property ( weak, nonatomic ) UILabel *countLabel;
@property ( weak, nonatomic ) UILabel *titleLabel;


@end

@implementation EVProfileControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    UILabel *countLabel = [[UILabel alloc] init];
    [self addSubview:countLabel];
    [countLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [countLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.f];
    countLabel.font = [UIFont systemFontOfSize:16];
    countLabel.text = self.count;
    countLabel.textColor = [UIColor colorWithHexString:@"#403B37"];;
    self.countLabel = countLabel;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:11.f];
    [titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    titleLabel.text = self.title;
    titleLabel.textColor = [UIColor colorWithRed:182.0/255 green:182.0/255 blue:182.0/255 alpha:1.0];
    titleLabel.font = [UIFont systemFontOfSize:11];
    self.titleLabel = titleLabel;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setCount:(NSString *)count
{
    _count = count;
    self.countLabel.text = count;
}
@end
