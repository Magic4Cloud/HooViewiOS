//
//  EVFantuanContributorTableViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVFantuanContributorTableViewCell.h"
#import "EVHeaderView.h"
#import <PureLayout/PureLayout.h>
#import "EVFantuanContributorModel.h"
#import "EVNickNameAndLevelView.h"
#import "EVMngUserListModel.h"

#define CCFantuanContributorTableViewCellID @"CCFantuanContributorTableViewCellID"

@interface EVFantuanContributorTableViewCell ()

@property (weak, nonatomic) UILabel *listNumLbl;  /**< 排名 */
@property (weak, nonatomic) EVHeaderButton *logoBtn;  /**< 头像按钮 */
@property (weak, nonatomic) UILabel *nicknameLbl;  /**< 昵称 */
@property (weak, nonatomic) UIImageView *genderImgV;  /**< 性别 */
@property (weak, nonatomic) UILabel *contributesLbl;  /**< 云票贡献量 */
@property ( nonatomic, weak ) EVNickNameAndLevelView *levelView;// 昵称和等级
@property (weak, nonatomic) UILabel * gxLabel;

@property (nonatomic,weak)NSLayoutConstraint *logoBtnLayoutCon;

@property (nonatomic,weak)NSLayoutConstraint *levelViewContraint;
@end

@implementation EVFantuanContributorTableViewCell

#pragma mark - public class methods

+ (NSString *)cellID
{
    return CCFantuanContributorTableViewCellID;
}


#pragma mark - life circle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setUpUI];
    }
    return self;
}


#pragma event response

- (void)avatarClick
{
    if ( self.logoClicked )
    {
        self.logoClicked(self.model);
    }
}


#pragma mark - private methods

- (void)setUpUI
{
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:container];
    [container autoPinEdgesToSuperviewEdges];
    
    UILabel *listNumLbl = [UILabel labelWithDefaultTextColor:CCTextBlackColor
                                                        font:CCNormalFont(15.0f)];
    listNumLbl.textAlignment = NSTextAlignmentCenter;
    [container addSubview:listNumLbl];
    listNumLbl.hidden = YES;
    self.listNumLbl = listNumLbl;
    [listNumLbl autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                         excludingEdge:ALEdgeRight];
    [listNumLbl autoSetDimension:ALDimensionWidth
                          toSize:50.0f];
    
    EVHeaderButton *logoBtn = [[EVHeaderButton alloc] init];
    [logoBtn addTarget:self action:@selector(avatarClick) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:logoBtn];
    self.logoBtn = logoBtn;
    [logoBtn autoSetDimensionsToSize:CGSizeMake(50.0f, 50.0f)];
    self.logoBtnLayoutCon = [logoBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:listNumLbl withOffset:-5.f];
    [logoBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
   
    UILabel *nicknameLbl = [UILabel labelWithDefaultTextColor:[UIColor evTextColorH1]
                                                         font:CCNormalFont(15)];
    [container addSubview:nicknameLbl];
    self.nicknameLbl = nicknameLbl;
    [nicknameLbl autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:-11];
    [nicknameLbl autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:logoBtn withOffset:ScreenWidth/375*19];
    
    //等级vip
    EVNickNameAndLevelView *levelView = [[EVNickNameAndLevelView alloc] init];
    [container addSubview:levelView];
   [levelView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:nicknameLbl withOffset:-2.0f];
    [levelView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:11];
    _levelView = levelView;
    
    UILabel *contributesLbl = [UILabel labelWithDefaultTextColor:CCTextBlackColor
                                                         font:CCNormalFont(12.0f)];
    contributesLbl.textAlignment = NSTextAlignmentRight;
    contributesLbl.textColor = [UIColor evTextColorH2];
    contributesLbl.font = [UIFont systemFontOfSize:13];
    [container addSubview:contributesLbl];
    self.contributesLbl = contributesLbl;
    [contributesLbl autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:11];
    [contributesLbl autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0, 50, .0, 20.0f) excludingEdge:ALEdgeLeft];
    
    UILabel * gxLabel = [UILabel labelWithDefaultTextColor:CCTextBlackColor
                                                      font:CCNormalFont(12.0f)];
    gxLabel.textAlignment = NSTextAlignmentRight;
    gxLabel.text = kE_GlobalZH(@"e_devote");
    [container addSubview:gxLabel];
    self.gxLabel = gxLabel;
    [gxLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:-11];
    [gxLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:contributesLbl];
    
    
    // 低部分割线
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    [container addSubview:bottomLine];
    [bottomLine autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [bottomLine autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [bottomLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:logoBtn];
    [bottomLine autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
}


#pragma mark - getters and setters

- (void)setModel:(EVFantuanContributorModel *)model
{
    _model = model;
    self.listNumLbl.hidden = NO;
    self.contributesLbl.hidden = NO;
    self.logoBtnLayoutCon.constant = -5.f;
    [self.logoBtn cc_setBackgroundImageURL:model.logourl placeholderImage:[UIImage imageNamed:@"avatar"] isVip:![model.vip isEqualToString:@"0"] vipSizeType:CCVipMini];
    self.nicknameLbl.text = model.nickname;
    self.contributesLbl.text = [NSString stringWithFormat:@"%ld", model.riceroll];
    self.levelView.gender = model.gender;

}
- (void)setListModel:(EVMngUserListModel *)listModel
{
    _listModel = listModel;
 
    self.listNumLbl.hidden = YES;
    self.contributesLbl.hidden = YES;
    self.gxLabel.hidden = YES;
    self.logoBtnLayoutCon.constant = -40.f;
    [self.logoBtn cc_setBackgroundImageURL:listModel.logourl placeholderImage:[UIImage imageNamed:@"avatar"] isVip:nil vipSizeType:CCVipMini];
    self.nicknameLbl.text = listModel.nickname;
    self.levelView.gender = listModel.gender;
}
- (void)setIndexNum:(NSInteger)indexNum
{
    indexNum = indexNum;
    self.listNumLbl.text = [[NSNumber numberWithInteger:indexNum] stringValue];
}

@end
