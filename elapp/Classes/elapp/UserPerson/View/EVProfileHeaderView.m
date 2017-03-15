//
//  EVProfileHeaderView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVProfileHeaderView.h"
#import "EVHeaderView.h"
#import "EVProfileControl.h"
#import <PureLayout.h>
#import "EVUserModel.h"
#import "NSString+Extension.h"
#import "EVNickNameAndLevelView.h"

#define kMarginLeft       10.f
#define kBottomViewHeight 55.f

static const CGFloat kPaddingHeight  = 10.f;    /**< 房间view上方padding */    /**< 房间view高度 */
CGFloat const EVProfileHeaderViewRoomHeight = kPaddingHeight;     /**< 房间+房间上方padding总高度 */

@interface EVProfileHeaderView ()

@property ( weak, nonatomic ) EVHeaderButton *headButton;   /**< 头像按钮 */
@property ( weak, nonatomic ) UIImageView *genderImageView; /**< 性别图标 */
@property ( weak, nonatomic ) UILabel *signLabel;           /**< 个性签名 */
@property ( weak, nonatomic ) UIButton *locationButton;     /**< 地理位置 */
@property ( weak, nonatomic ) UILabel *idLabel;             /**< 云播号 */
@property ( weak, nonatomic ) UIView *bottomView;           /**< 底部三个按钮的父视图 */
@property (strong, nonatomic) UIImage *headerImage;
@property ( weak, nonatomic ) UIButton *editMarkButton;
@property ( weak, nonatomic ) UILabel *nickNameLabel;
@property ( nonatomic, weak ) EVNickNameAndLevelView *levelView;// 昵称和等级
@property ( weak, nonatomic ) UIView *backView;


@property ( strong, nonatomic ) NSLayoutConstraint *leftViewWithConstraint;

@end

@implementation EVProfileHeaderView

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
    // 滚动视图
    CGFloat scrollViewHeight = CGRectGetHeight(self.bounds) - kBottomViewHeight - EVProfileHeaderViewRoomHeight;
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    self.backView = backView;
    [backView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [backView autoSetDimension:ALDimensionHeight toSize:scrollViewHeight];

    // ------ 左侧视图 -------
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:containerView];
    [containerView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [containerView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    self.leftViewWithConstraint = [containerView autoSetDimension:ALDimensionWidth toSize:ScreenWidth];
    [containerView autoSetDimension:ALDimensionHeight toSize:scrollViewHeight];
    

    // 头像
    EVHeaderButton *headerButton = [EVHeaderButton buttonWithType:UIButtonTypeCustom];
    [containerView addSubview:headerButton];
    [headerButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [headerButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:44.0f];
    [headerButton autoSetDimensionsToSize:CGSizeMake(60.f, 60.f)];
    self.headButton = headerButton;
    [headerButton setImage:[UIImage imageNamed:@"avatar"] forState:UIControlStateNormal];
    [headerButton addTarget:self action:@selector(headButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // 备注, 昵称,地理位置 右侧按钮等控件的容器view
    UIView *centerContanerView = [[UIView alloc] init];
    [containerView addSubview:centerContanerView];
    centerContanerView.backgroundColor = [UIColor whiteColor];
    [centerContanerView autoSetDimension:ALDimensionWidth toSize:ScreenWidth];
    [centerContanerView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:headerButton withOffset:8.f];
    [centerContanerView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [centerContanerView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:containerView];
    
    
    // 昵称
    UILabel *nickNameLabel = [[UILabel alloc] init];
    [centerContanerView addSubview: nickNameLabel];
    [nickNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:headerButton withOffset:8.];
    [nickNameLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:centerContanerView];
    nickNameLabel.font = EVNormalFont(13);
    nickNameLabel.textColor = [UIColor evTextColorH3];
    nickNameLabel.textAlignment = NSTextAlignmentCenter;
    self.nickNameLabel = nickNameLabel;
    
    
    // 昵称和等级标识的容器
    EVNickNameAndLevelView *levelView = [[EVNickNameAndLevelView alloc] init];
    [centerContanerView addSubview:levelView];
    levelView.backgroundColor = [UIColor yellowColor];
    [levelView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:nickNameLabel withOffset:8.f];
    [levelView autoAlignAxis:ALAxisVertical toSameAxisOfView:containerView];
    _levelView = levelView;
    
    // 云播号
    UILabel *idLabel = [[UILabel alloc] init];
    [centerContanerView addSubview:idLabel];
    [idLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:containerView];
    [idLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:levelView withOffset:8.f];
    idLabel.text = [NSString stringWithFormat:@"ID:%@",kE_GlobalZH(@"loading")];
    idLabel.font = EVNormalFont(12);
    idLabel.textColor = [UIColor colorWithRed:182.0/255 green:182.0/255 blue:182.0/255 alpha:1.0];
    self.idLabel = idLabel;
    
    // 签名
    UILabel *signLabel =  [[UILabel alloc] init];
    [centerContanerView addSubview:signLabel];
    [signLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0];
    [signLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:idLabel withOffset:0.0];
     [signLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:containerView withOffset:5.0];
    self.signLabel = signLabel;
    signLabel.textColor = [UIColor colorWithRed:182.0/255 green:182.0/255 blue:182.0/255 alpha:1.0];
    signLabel.text =kE_GlobalZH(@"loading");
    signLabel.font = [UIFont systemFontOfSize:12];
    signLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UIButton *editDatabtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [centerContanerView addSubview:editDatabtn];
    self.editMarkButton = editDatabtn;
    [editDatabtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    editDatabtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    editDatabtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [editDatabtn setBackgroundColor:[UIColor evSecondColor]];
    [editDatabtn addTarget:self action:@selector(editDataClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [editDatabtn autoAlignAxis:ALAxisVertical toSameAxisOfView:centerContanerView];
    [editDatabtn autoSetDimension:ALDimensionWidth toSize:100];
    [editDatabtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:signLabel withOffset:8.0];
    [editDatabtn autoSetDimension:ALDimensionHeight toSize:30];
    
    
    
    // -------- 底部三个视图 --------
    UIView *bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:backView];
    [bottomView autoSetDimension:ALDimensionHeight toSize:55.f];
    [bottomView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [bottomView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:EVProfileHeaderViewRoomHeight];
    self.bottomView = bottomView;
    
    EVProfileControl *lastControl = nil;
    
    NSArray *controlArray = @[CCProfileControlTitleVideo,CCProfileControlTitleFocus,CCProfileControlTitleFans];
    
    for (int i = 0; i < controlArray.count; i ++)
    {
        EVProfileControl *control = [[EVProfileControl alloc] init];
        control.backgroundColor = [UIColor whiteColor];
        [bottomView addSubview:control];
        if ( lastControl == nil )
        {
            [control autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [control autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            [control autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            [control autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.33];
        }
        else
        {
            [control autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lastControl withOffset:1.f];
            [control autoAlignAxis:ALAxisHorizontal toSameAxisOfView:lastControl];
            [control autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:lastControl];
            [control autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:lastControl];
        }
        control.title = controlArray[i];
        control.count = @"0";
        
        // 添加点击事件
        [control addTarget:self action:@selector(profileControlClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // 垂直分割线
        UIView *separateLine = [[UIView alloc] init];
        [bottomView addSubview:separateLine];
        [separateLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:control];
        [separateLine autoSetDimension:ALDimensionWidth toSize:1.f];
        [separateLine autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:control withOffset: - 20.f];
        [separateLine autoAlignAxis:ALAxisHorizontal toSameAxisOfView:control];
        separateLine.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        
        lastControl = control;
    }
    
    // 底部线
    UIView *bottomLine = [[UIView alloc] init];
    [bottomView addSubview:bottomLine];
    [bottomLine autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [bottomLine autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [bottomLine autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [bottomLine autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
    bottomLine.backgroundColor = [UIColor evGlobalSeparatorColor];
}

- (void)setUserModel:(EVUserModel *)userModel
{
    if ( userModel == nil )
    {
        return;
    }
    _userModel = userModel;
    __weak typeof(self) weakself = self;
    [self.headButton cc_setBackgroundImageURL:self.userModel.logourl placeholderImageStr:kUserLogoPlaceHolder isVip:userModel.vip vipSizeType:EVVipMax complete:^(UIImage *image) {
        weakself.headerImage = image;
    }];
    
    // 配置个人信息右侧的编辑按钮
    [self p_judgeCurrentEditMarkButtonStyle:userModel];
    
    self.levelView.gender = userModel.gender;
    
    self.levelView.levelModeType = EVLevelModeTypeLine;
    
    NSString *genderIconName = [userModel.gender isEqualToString:@"male"] ? @"home_icon_man":@"home_icon_woman";
    self.genderImageView.image = [UIImage imageNamed:genderIconName];
    NSString *remark = [NSString stringWithFormat:@"%@",userModel.name];
    
    BOOL noRemark = (remark == nil || remark.length == 0);
    
    NSString *nickNameText = noRemark ? nil : [NSString stringWithFormat:@"%@%@",kE_GlobalZH(@"e_name"),userModel.nickname];
    self.nickNameLabel.text = nickNameText;
    
    if ( self.userModel.name && ![self.userModel.name isEqualToString:@""] )
    {
        self.idLabel.text = [NSString stringWithFormat:@"ID:%@", self.userModel.name];
    }
    
    [self.headButton hasBorder:YES];
    
    
    if (self.userModel.signature && ![self.userModel.signature isEqualToString:@""]) {
        self.signLabel.text = self.userModel.signature;
    } else if (self.style == EVProfileHeaderViewStyleMine) {
        self.signLabel.text = kE_GlobalZH(@"world_you_lazy");
    } else {
        self.signLabel.text = kDefaultSignature_other;
    }
    
    for (UIView *view in self.bottomView.subviews) {
        if ([view isKindOfClass:[EVProfileControl class]]) {
            EVProfileControl *control = (EVProfileControl *)view;
            if ( [control.title isEqualToString:CCProfileControlTitleVideo] )
            {
                control.count = [NSString shortNumber:userModel.video_count];
            }
            else if ([control.title isEqualToString:CCProfileControlTitleFans] )
            {
                control.count = [NSString shortNumber:userModel.fans_count];
            }
            else if ([control.title isEqualToString:CCProfileControlTitleFocus] )
            {
                control.count = [NSString shortNumber:userModel.follow_count];
            }
        }
    }

}

// 点击头像
- (void)headButtonClicked:(EVHeaderButton *)button
{
    if ( self.headerImage && self.delegate && [self.delegate respondsToSelector:@selector(clickHeaderButton:image:)] )
    {
        [self.delegate clickHeaderButton:button image:self.headerImage];
    }
}

// 点击下面四个control的事件
- (void)profileControlClicked:(EVProfileControl *)control
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(clickProfileControl:)] )
    {
        [self.delegate clickProfileControl:control];
    }
}

- (void)editDataClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickEditDataButton:)]) {
        [self.delegate clickEditDataButton:btn];
    }
}
- (void)hiddenEditMarkButton:(BOOL)YorN {
    self.editMarkButton.hidden = YorN;
}

#pragma mark - private method
- (void)p_judgeCurrentEditMarkButtonStyle:(EVUserModel *)userModel {
    switch (self.style) {
        case EVProfileHeaderViewStyleMine: {
            // 设置‘个人中心’个人信息右侧的‘编辑资料’按钮
            [self.editMarkButton setTitle:kE_GlobalZH(@"edit_data") forState:UIControlStateNormal];
            break;
        }
        case EVProfileHeaderViewStyleOtherPerson: {
            
            [self.editMarkButton setHidden:YES];
            break;
        }
    }
}

#pragma mark - setter




@end
