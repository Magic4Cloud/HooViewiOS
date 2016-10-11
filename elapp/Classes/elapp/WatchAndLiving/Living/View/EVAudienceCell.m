//
//  EVAudienceCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVAudienceCell.h"
#import <PureLayout.h>
#import "EVAudience.h"

@interface EVAudienceCell ()

@property (nonatomic,weak) UIImageView *userLogoImageView;

@property (nonatomic, assign) BOOL clipImageView;

@end

@implementation EVAudienceCell

- (void)dealloc
{
    CCLog(@"CCAudienceCell dealloc");
}

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
    UIImageView *userLogoImageView = [[UIImageView alloc] init];
    userLogoImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:userLogoImageView];
    [userLogoImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.userLogoImageView = userLogoImageView;
    
    self.userLogoImageView.clipsToBounds = YES;
    self.userLogoImageView.layer.cornerRadius = 0.5 * kCollectionViewItemSize;
//    self.userLogoImageView.layer.borderColor = [UIColor colorWithHexString:@"#000000" alpha:0.2].CGColor;
//    self.userLogoImageView.layer.borderWidth = 1;
}

- (void)setAudience:(EVAudience *)audience
{
    _audience = audience;
    [self.userLogoImageView cc_setImageWithURLString:audience.logourl placeholderImageName:@"avatar"];
}

+ (NSString *)audienceCellID
{
    static NSString *cellID = @"EVAudienceCell";
    return cellID;
}

@end
