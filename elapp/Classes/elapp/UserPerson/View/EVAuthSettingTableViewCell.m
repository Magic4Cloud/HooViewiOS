//
//  EVAuthSettingTableViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVAuthSettingTableViewCell.h"
#import "EVAuthSettingModel.h"
#import "PureLayout.h"
#import "EVRelationWith3rdAccoutModel.h"

static const NSString *const qqType = @"qq";
static const NSString *const wechatType = @"weixin";
static const NSString *const weiboType = @"sina";
static const NSString *const phoneType = @"phone";


@interface EVAuthSettingTableViewCell ()

@property (nonatomic, weak) UILabel *cellNameLabel;
@property (nonatomic, weak) UISwitch *authSwitch;
@property (nonatomic, weak) UIImageView *indicatorImageView;
@property (nonatomic, weak) UIView *seperatorViewTop;
@property (nonatomic, weak) UIView *seperatorViewBottom;
@property ( weak, nonatomic ) UIView *accountView;  /**< 账号管理 */
@property ( weak, nonatomic ) UILabel *midLabel;    /**< 中间的文本 */
@property ( weak, nonatomic ) UILabel *rightLabel;  /**< 右侧文本 */


@end

@implementation EVAuthSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    [self addConstraint];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.authSwitch.onTintColor = [CCAppSetting shareInstance].appMainColor;
}

- (void)addConstraint
{
    [self.cellNameLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.authSwitch autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.indicatorImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [self.cellNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [self.authSwitch autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [self.authSwitch autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.cellNameLabel];
    
    [self.indicatorImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    

    
    // 账号管理
    
    UIView *accountView = [[UIView alloc] init];
    [self.contentView addSubview:accountView];
    self.accountView = accountView;
    accountView.hidden = YES;
    [accountView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_indicatorImageView];
    [accountView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_indicatorImageView];
    
    NSArray *normalArray = @[@"personal_icon_wechat_nor",@"personal_icon_qq_nor",@"personal_icon_weibo_nor",@"personal_icon_phone_nor"];
    NSArray *linkArray = @[@"personal_icon_wechat",@"personal_icon_qq",@"personal_icon_weibo",@"personal_icon_phone"];
    
    UIButton *lastButton = nil;
    for (int i = 0; i < 4; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:normalArray[3 - i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:linkArray[3 - i]] forState:UIControlStateSelected];
        [accountView addSubview:button];
        if ( lastButton == nil )
        {
            [button autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_indicatorImageView withOffset:-10];
        }
        else
        {
            [button autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:lastButton withOffset:-10];
        }
        
        [button autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_indicatorImageView];
        lastButton = button;
    }
    
    // 中间的退出登录
    UILabel *label = [[UILabel alloc] init];
    [self.contentView addSubview:label];
    [label autoCenterInSuperview];
    label.hidden = YES;
    self.midLabel = label;
    label.font = CCNormalFont(15);
    label.textColor = [UIColor colorWithHexString:@"#fb6655"];
    
    // 右侧文本
    UILabel *rightLabel = [[UILabel alloc] init];
    [self.contentView addSubview:rightLabel];
    self.rightLabel = rightLabel;
    rightLabel.textColor = CCTextBlackColor;
    rightLabel.font = CCNormalFont(13);
    [rightLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_indicatorImageView];
    [rightLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_indicatorImageView];
    rightLabel.hidden = YES;
}

- (void)addSeperatorViewWithPosition:(NSInteger)position
{
    if ( 0 == position )
    {
        self.seperatorViewTop.hidden = NO;
        self.seperatorViewBottom.hidden = YES;
    }
    else if( 1 == position )
    {
        self.seperatorViewTop.hidden = YES;
        self.seperatorViewBottom.hidden = NO;
    }
    else if ( 2 == position)
    {
        self.seperatorViewTop.hidden = NO;
        self.seperatorViewBottom.hidden = NO;
    }
}

#pragma mark - event response

- (void)authSwitchChange:(UISwitch *)authSwitch
{
    if ( [_delegate respondsToSelector:@selector(switchWithCell:isOn:)] )
    {
        [_delegate switchWithCell:self isOn:authSwitch.isOn];
    }
}

#pragma mark - getter and setter

- (void)setAuthModel:(EVAuthSettingModel *)authModel
{
    if ( _authModel != authModel )
    {
        _authModel = authModel;
    }

    if ( 2 == authModel.isOn )
    {
        self.authSwitch.hidden = YES;
        self.indicatorImageView.hidden = NO;
    }
    else
    {
        CCLog(@"####-----%d,----%s-----%zd---####",__LINE__,__FUNCTION__,_authModel.isOn);
        self.authSwitch.on = _authModel.isOn;
    }
    self.cellNameLabel.text = _authModel.name;
    self.midLabel.text = _authModel.midText;
    self.rightLabel.text = _authModel.rightText;
    
    // 控制视图的显示和隐藏
    self.accountView.hidden = _authModel.type != EVAuthSettingModelTypeAccount;
    self.indicatorImageView.hidden = (_authModel.type != EVAuthSettingModelTypeDefault) && (_authModel.type != EVAuthSettingModelTypeAccount);
    self.authSwitch.hidden = _authModel.type != EVAuthSettingModelTypeSwitch;
    self.midLabel.hidden = _authModel.type != EVAuthSettingModelTypeLogOut;
    self.rightLabel.hidden = _authModel.type != EVAuthSettingModelTypeClear;
}


- (UILabel *)cellNameLabel
{
    if ( !_cellNameLabel )
    {
        UILabel *cellNameLabel = [[UILabel alloc] init];
        cellNameLabel.font = [[CCAppSetting shareInstance] normalFontWithSize:15];
        cellNameLabel.textColor = CCTextBlackColor;
        [self.contentView addSubview:cellNameLabel];
        _cellNameLabel = cellNameLabel;
    }
    return _cellNameLabel;
}

- (UISwitch *)authSwitch
{
    if ( !_authSwitch )
    {
        UISwitch *authSwitch = [[UISwitch alloc] init];
        [authSwitch addTarget:self action:@selector(authSwitchChange:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:authSwitch];
        _authSwitch = authSwitch;
    }
    return _authSwitch;
}

- (UIImageView *)indicatorImageView
{
    if ( !_indicatorImageView )
    {
        UIImageView *indicatorImageView = [[UIImageView alloc] init];
        indicatorImageView.image = [UIImage imageNamed:@"home_icon_next"];
        indicatorImageView.hidden = YES;
        [self.contentView addSubview:indicatorImageView];
        _indicatorImageView = indicatorImageView;
    }
    return _indicatorImageView;
}

- (UIView *)seperatorViewTop
{
    if ( !_seperatorViewTop )
    {
        UIView *seperatorViewTop = [[UIView alloc] init];
        seperatorViewTop.hidden = YES;
        seperatorViewTop.backgroundColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
        [self.contentView addSubview:seperatorViewTop];
        _seperatorViewTop = seperatorViewTop;
    }
    return _seperatorViewTop;
}

- (UIView *)seperatorViewBottom
{
    if ( !_seperatorViewBottom )
    {
        UIView *seperatorViewBottom = [[UIView alloc] init];
        seperatorViewBottom.hidden = YES;
        seperatorViewBottom.backgroundColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
        [self.contentView addSubview:seperatorViewBottom];
        _seperatorViewBottom = seperatorViewBottom;
    }
    return _seperatorViewBottom;
}

- (void)setAccounts:(NSMutableArray *)accounts
{
    _accounts = accounts;
    
    for (EVRelationWith3rdAccoutModel *accountModel in _accounts)
    {
        if ([accountModel.type isEqualToString:(NSString *)qqType])
        {
            UIButton *button = self.accountView.subviews[2];
            button.selected = accountModel.token != nil;
        }
        else if ([accountModel.type isEqualToString:(NSString *)wechatType])
        {
            UIButton *button = self.accountView.subviews[3];
            button.selected = accountModel.token != nil;
        }
        else if ([accountModel.type isEqualToString:(NSString *)weiboType])
        {
            UIButton *button = self.accountView.subviews[1];
            button.selected = accountModel.token != nil;
        }
        else if ([accountModel.type isEqualToString:(NSString *)phoneType])
        {
            UIButton *button = self.accountView.subviews[0];
            button.selected = accountModel.token != nil;
        }
    }
}

+ (instancetype)cellForTableView:(UITableView *)tableView
{
    static NSString *cellIdentifier = @"CCAuthSettingCell";
    EVAuthSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( cell == nil )
    {
        cell = [[EVAuthSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

@end
