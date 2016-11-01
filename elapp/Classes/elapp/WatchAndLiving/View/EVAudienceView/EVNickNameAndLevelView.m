//
//  EVNickNameAndLevelView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVNickNameAndLevelView.h"
#import <PureLayout.h>
#import "NSString+Extension.h"

@interface EVNickNameAndLevelView ()
@property ( weak, nonatomic ) UIImageView *sexImageView;        // 性别图标
@property ( weak, nonatomic) UIView *sexView;
@property ( weak, nonatomic ) UILabel *nickNameLabel;           // 昵称
@property ( weak, nonatomic) UILabel *ageLabel;
@property ( weak, nonatomic) UILabel *constellationLabel;       //星座


@property (nonatomic, weak)NSLayoutConstraint *genderWidthConstraint;

@property (nonatomic, weak)NSLayoutConstraint *genderLeftConstraint;

@property (nonatomic, weak)NSLayoutConstraint *constellationWidthConstraint;

@property (nonatomic, weak)NSLayoutConstraint *constellationLeftConstraint;

@property (nonatomic, weak)NSLayoutConstraint *nicknameLeftConstraint;

@end

@implementation EVNickNameAndLevelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupView];
    }
    return self;
}


- (void)setupView
{
    // 昵称
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    nickNameLabel.font = [UIFont boldSystemFontOfSize:15];

    [self addSubview:nickNameLabel];
    [nickNameLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    self.nicknameLeftConstraint = [nickNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    _nickNameLabel = nickNameLabel;
    nickNameLabel.backgroundColor = [UIColor clearColor];

    // 性别图片
    UIView * sexView = [[UIView alloc] init];
    sexView.hidden = YES;
    sexView.layer.cornerRadius = 2;
    sexView.layer.masksToBounds = YES;
    sexView.layer.borderWidth = 0.5f;
    sexView.backgroundColor = [UIColor colorWithHexString:@"#FFEEF2"];
    [self addSubview:sexView];
    self.genderLeftConstraint = [sexView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:nickNameLabel withOffset:0];
    [sexView autoSetDimension:ALDimensionHeight toSize:13];
    self.genderWidthConstraint = [sexView autoSetDimension:ALDimensionWidth toSize:0];
    [sexView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:nickNameLabel];
    self.sexView = sexView;
    
    UIImageView *sexImgView = [[UIImageView alloc] init];
    sexImgView.layer.cornerRadius = 2;
    sexImgView.layer.masksToBounds = YES;
    [sexView addSubview:sexImgView];
    [sexImgView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
    [sexImgView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:2.5];
    _sexImageView = sexImgView;
    
    UILabel * ageLabel = [[UILabel alloc] init];
    ageLabel.font = [UIFont boldSystemFontOfSize:10];

    [_sexView addSubview:ageLabel];
    [ageLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [ageLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    _ageLabel = ageLabel;
    _ageLabel.hidden = YES;
    
    
    //星座
    UILabel * constellationLabel = [[UILabel alloc] init];
    constellationLabel.backgroundColor = [UIColor colorWithHexString:@"#eef2ff"];
    constellationLabel.textColor = [UIColor colorWithHexString:@"#9ac9ff"];
    constellationLabel.layer.borderColor = [UIColor colorWithHexString:@"#8DA8FF"].CGColor;
    constellationLabel.layer.borderWidth = 0.5f;
    constellationLabel.textAlignment = NSTextAlignmentCenter;
    constellationLabel.font = [UIFont boldSystemFontOfSize:10];
    constellationLabel.layer.cornerRadius = 2;
    constellationLabel.layer.masksToBounds = YES;
    [self addSubview:constellationLabel];
    [constellationLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:nickNameLabel];
    self.constellationLeftConstraint = [constellationLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:sexView withOffset:0];
    self.constellationWidthConstraint = [constellationLabel autoSetDimension:ALDimensionWidth toSize:0];
    [constellationLabel autoSetDimension:ALDimensionHeight toSize:13];
    _constellationLabel = constellationLabel;
    _constellationLabel.hidden = YES;

}

- (void)setNickName:(NSString *)nickName
{
    _nickName = nickName;
    self.nickNameLabel.text = nickName;
    if ([nickName isEqualToString:@""] || nickName == nil) {
        self.nicknameLeftConstraint.constant = -30;
    }else {
        self.nicknameLeftConstraint.constant = -30;
    }
    
}

- (void)setLevelModeType:(EVLevelModeType)levelModeType
{
    _levelModeType = levelModeType;
    switch (self.levelModeType) {
        case EVLevelModeTypeLine:
        {
            self.nicknameLeftConstraint.constant = -30;
        }
            break;
        case EVLevelModeTypeNmBack:
        {
            self.nicknameLeftConstraint.constant = 0;
        }
            break;
        default:
            break;
    }
}
- (void)setGender:(NSString *)gender
{
    _gender = [gender copy];
 
    if (_isShowGender)
    {
        self.sexView.hidden = YES;
        self.genderWidthConstraint.constant = 0;
        self.genderLeftConstraint.constant = 0;
    }
    else
    {
        self.sexView.backgroundColor = [gender isEqualToString:@"female"] ? [UIColor colorWithHexString:@"#FFEEF2"]:[UIColor colorWithHexString:@"#F0F7FF"];
        self.sexView.layer.borderColor =  [gender isEqualToString:@"female"] ? [UIColor evAssistColor].CGColor : [UIColor colorWithHexString:@"#9ac9ff"].CGColor;
        UIImage * sexImage = [gender isEqualToString:@"female"]? [UIImage imageNamed:@"home_icon_woman"]:[UIImage imageNamed:@"home_icon_man"];
        self.ageLabel.textColor = [gender isEqualToString:@"female"]? [UIColor evAssistColor]:[UIColor colorWithHexString:@"#9ac9ff"];
        self.sexView.hidden = NO;
        self.sexImageView.image =  sexImage;
        self.genderWidthConstraint.constant = 15;
        self.genderLeftConstraint.constant = 4;
    }
}

- (void)setBirth:(NSString *)birth
{
    _birth = [birth copy];
    if ( _birth )
    {
        self.ageLabel.text = [NSString ageFromDateStr:birth];
        self.constellationLabel.text = [[NSString judConstellationDateStr:birth] substringToIndex:2];
        self.ageLabel.hidden = NO;
        self.constellationLabel.hidden = NO;
        self.genderLeftConstraint.constant = 4;
        if (self.ageLabel.text.length <= 2) {
            self.genderWidthConstraint.constant = 30;
        } else if (self.ageLabel.text.length == 3) {
            self.genderWidthConstraint.constant = 36;
        } else {
            self.genderWidthConstraint.constant = 42;
        }
        self.constellationWidthConstraint.constant = 25;
        self.constellationLeftConstraint.constant = 4;
    }
    else
    {
        self.ageLabel.hidden = YES;
        self.constellationLabel.hidden = YES;
        self.genderLeftConstraint.constant = 0;
        self.genderWidthConstraint.constant = 0;
        self.constellationWidthConstraint.constant = 0;
        self.constellationLeftConstraint.constant = 0;
    }
}

@end
