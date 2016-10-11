//
//  EVUserTableViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVUserTableViewCell.h"
#import "PureLayout.h"
#import "EVLoginInfo.h"

static NSString *identifier = @"userTableViewCell";

@interface EVUserTableViewCell()

@property (nonatomic,weak) UIImageView *userAvatarImageView;
@property (nonatomic,weak) UILabel *userNameLabel;
@property (nonatomic,weak) UILabel *profileDescriptionLabel;
@property (nonatomic,weak) UILabel *fanTotalLabel;
@property (nonatomic,weak) UILabel *praiseTotalLabel;
@property (weak, nonatomic) UIButton *addAttentionButton;   /**< 关注点击button */
@property (weak, nonatomic) UIImageView *vipImageView;      /**< VIP */
@property (weak, nonatomic) UIView *bottomLine;             /**< 底部分割线 */
@property (weak, nonatomic) NSLayoutConstraint *locationBtnConstraintWidth;  /**< 位置按钮的宽度 */

@end
@implementation EVUserTableViewCell

// 当前cell的类方法
+ (instancetype)userTableViewCellWithTableView:(UITableView *)tableview
{
    EVUserTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

+ (NSString *)cellID
{
    return identifier;
}

// 设置cell的UI
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        // 设置头像
        UIImageView *userAvatarImageView = [[UIImageView alloc]init];
        _userAvatarImageView = userAvatarImageView;
        userAvatarImageView.layer.cornerRadius = 25;
        userAvatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:userAvatarImageView];
        [userAvatarImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [userAvatarImageView autoSetDimensionsToSize:CGSizeMake(50, 50)];
        [userAvatarImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        
        // 设置VIP
        UIImageView *vipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_ medium_vip"]];
        [self.contentView addSubview:vipImageView];
        _vipImageView = vipImageView;
        vipImageView.hidden = YES;
        [vipImageView sizeToFit];
        [vipImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:userAvatarImageView];
        [vipImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:userAvatarImageView];
        
        // 设置昵称
        UILabel *userNameLabel = [[UILabel alloc]init];
        userNameLabel.font = [[CCAppSetting shareInstance] normalFontWithSize:14.0f];
        userNameLabel.textColor = [UIColor evTextColorH1];
        _userNameLabel = userNameLabel;
        [self.contentView addSubview:userNameLabel];
        [userNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:userAvatarImageView withOffset:10];
        [userNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:userAvatarImageView withOffset:8];
        [userNameLabel autoSetDimension:ALDimensionWidth toSize:14.0f relation:NSLayoutRelationGreaterThanOrEqual];
        

    
        // 设置个性签名
        UILabel *profileDescriptionLabel = [[UILabel alloc]init];
        profileDescriptionLabel.font = [[CCAppSetting shareInstance]normalFontWithSize:11];
        profileDescriptionLabel.textColor = [UIColor evTextColorH2];
        _profileDescriptionLabel = profileDescriptionLabel;
        [self.contentView addSubview:profileDescriptionLabel];
        [profileDescriptionLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:userNameLabel];
        [profileDescriptionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:userNameLabel withOffset:9];
        [profileDescriptionLabel autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 140, 11)];
        
        // 设置粉丝数
        UILabel *fanTotalLabel = [[UILabel alloc]init];
        fanTotalLabel.font = [[CCAppSetting shareInstance]normalFontWithSize:11];
        fanTotalLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _fanTotalLabel = fanTotalLabel;
        [self.contentView addSubview:fanTotalLabel];
        [fanTotalLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:userNameLabel];
        [fanTotalLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:profileDescriptionLabel withOffset:9.0];
        
        // 设置赞数
        UILabel *praiseTotalLabel = [[UILabel alloc]init];
        praiseTotalLabel.font = [[CCAppSetting shareInstance]normalFontWithSize:11];
        praiseTotalLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _praiseTotalLabel = praiseTotalLabel;
        [self.contentView addSubview:praiseTotalLabel];
        [praiseTotalLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:fanTotalLabel withOffset:23.0];
        [praiseTotalLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:fanTotalLabel];
        [praiseTotalLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:fanTotalLabel];
        
        // 设置关注按钮
        UIButton *addAttentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addAttentionButton setImage:[UIImage imageNamed:@"home_person_icon_add"] forState:UIControlStateNormal];
        [addAttentionButton setImage:[UIImage imageNamed:@"home_person_icon__add_success"] forState:UIControlStateSelected];
        [addAttentionButton addTarget: self action:@selector(addAttentionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:addAttentionButton];
        self.addAttentionButton = addAttentionButton;
        [addAttentionButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17.0];
        [addAttentionButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        // 添加底部分割线
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        bottomLine.backgroundColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
        [self.contentView addSubview:bottomLine];
        self.bottomLine = bottomLine;
        
        [bottomLine autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:.0f];
        [bottomLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13.0f];
        [bottomLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:.0f];
        [bottomLine autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
    }
    
    return self;
}

// 根据搜索结果的模型数据，设置UI
- (void)setUserInfo:(EVFindUserInfo *)userInfo
{
    _userInfo = userInfo;
    [self.userAvatarImageView cc_setImageWithURLString:userInfo.logourl placeholderImageName:kUserLogoPlaceHolder];
    self.userNameLabel.text = [NSString stringWithFormat:@"%@ %@",self.userInfo.name,self.userInfo.nickname];
    self.vipImageView.hidden = !userInfo.vip;
    self.profileDescriptionLabel.text = (userInfo.signature.length>0)?userInfo.signature:kDefaultSignature_other;
    self.addAttentionButton.selected = self.userInfo.followed;
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    self.addAttentionButton.hidden = [loginInfo.name isEqualToString:self.userInfo.name];
    self.addAttentionButton.selected = userInfo.followed;
}

- (void)setHideBottomLine:(BOOL)hideBottomLine
{
    _hideBottomLine = hideBottomLine;
    self.bottomLine.hidden = _hideBottomLine;
}

// 点击关注按钮
- (void)addAttentionButtonClick:(UIButton *)button
{
    if (self.buttonClickBlock)
    {
        self.buttonClickBlock(self,button);
    }
}
@end
