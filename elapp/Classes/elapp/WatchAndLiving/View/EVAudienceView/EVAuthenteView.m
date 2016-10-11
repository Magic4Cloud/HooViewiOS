//
//  EVAuthenteView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVAuthenteView.h"
#import <PureLayout.h>
#import "EVStartResourceTool.h"
#import "EVCertificationModel.h"

@interface EVAuthenteView ()

/** 官方认证标志 */
@property ( nonatomic, weak ) UIImage *authenImg;

/** 认证名称 */
@property ( nonatomic, weak ) UILabel *authenteLabel;

@property (nonatomic, weak) NSArray *authorityLevels;

@end

@implementation EVAuthenteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpViews];
    }
    return self;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
}

- (void)setAuthorityLevel:(NSInteger)authorityLevel
{
    _authorityLevel = authorityLevel;
    if ( _authorityLevel >= self.authorityLevels.count )
    {
        _authorityLevel = 0;
    }
    NSString *levelStr = [self onTheAuthorityLevel:authorityLevel];
    self.authenteLabel.text = levelStr;
}

- (NSArray *)authorityLevels
{
    if ( _authorityLevels == nil )
    {
        _authorityLevels = [[EVStartResourceTool shareInstance] getCertificationInfo];
    }
    return _authorityLevels;
}

- (void)setPersonalAuthorityLevel:(NSInteger)authorityLevel
{
    NSString *levelStr = [self onTheAuthorityLevel:authorityLevel];
    self.authenteLabel.text = levelStr;
    if (self.authenteLabel.text.length > 2) {
        self.imageWidthConstraint.constant = 52;
    }
    
    if ([self.authenteLabel.text isEqualToString:@""] || self.authenteLabel.text == nil) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
}

- (NSString *)onTheAuthorityLevel:(NSInteger)authorittyLevel
{
    NSString *authorityLevelStr = [NSString stringWithFormat:@"%ld",authorittyLevel];
    NSString *authortyStr = [NSString string];
    NSArray *array = [[EVStartResourceTool shareInstance] getCertificationInfo];
    for (EVCertificationModel *levelModel in array) {
        if ([levelModel.ID isEqualToString:authorityLevelStr]) {
            authortyStr = levelModel.name;
            break;
        }else{
            authortyStr = @"";
        }
    }
    return authortyStr;
}

- (void)setUpViews
{
    /** 认证图标 */
    UIImage * image = [UIImage imageNamed:@"home_icon_official"];
    image = [image stretchableImageWithLeftCapWidth:floorf(20) topCapHeight:floorf(0)];
    UIImageView * authenImg = [[UIImageView alloc] init];
    authenImg.image = image;
    [self addSubview:authenImg];
    [authenImg autoPinEdgesToSuperviewEdges];
    
    UIColor *textColor = [UIColor colorWithHexString:@"#FB6655"];
    UILabel * authenteLabel = [[UILabel alloc] init];
    authenteLabel.textColor = textColor;
    authenteLabel.font = [UIFont boldSystemFontOfSize:10];
    [self addSubview:authenteLabel];
    authenteLabel.hidden = NO;
    self.authenteLabel = authenteLabel;
    [authenteLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:authenImg withOffset:-3.5];
    [authenteLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:authenImg];
    
//    UIButton *authorityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    authorityBtn.backgroundColor = [UIColor whiteColor];
//    [authorityBtn setImage:[UIImage imageNamed:@"home_icon_official"] forState:UIControlStateNormal];
//    authorityBtn.titleLabel.font = CCNormalFont(10);
//    [authorityBtn setTitleColor:textColor forState:UIControlStateNormal];
//    authorityBtn.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0,0);
//    [self addSubview:authorityBtn];
//    [authorityBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
//    self.authenBtn = authorityBtn;
//    
//    /** 认证等级 */
//    UILabel *authLevelLabel = [[UILabel alloc] init];
//    authLevelLabel.textColor = textColor;
//    [self addSubview:authLevelLabel];
//    authLevelLabel.font = CCNormalFont(12);
//    _authenteLevelLabel = authLevelLabel;
//    [authLevelLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:authorityBtn];
//    [authLevelLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:authorityBtn withOffset:0];
//    [authLevelLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
}

@end
