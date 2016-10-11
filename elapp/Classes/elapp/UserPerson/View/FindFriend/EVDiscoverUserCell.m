//
//  EVDiscoverUserCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVDiscoverUserCell.h"
#import <PureLayout.h>
#import "EVDiscoverUserModel.h"
#import "EVLoginInfo.h"
#import "EVHeaderView.h"

@interface EVDiscoverUserCell ()

@property ( weak, nonatomic ) CCHeaderImageView *iconImageView;     // 头像
@property ( weak, nonatomic ) UILabel *remarksLabel;                // 备注名称(如果没有备注显示昵称)
@property ( weak, nonatomic ) UILabel *signatureLabel;              // 签名
@property ( weak, nonatomic ) UIButton *focousButton;               // 关注按钮
@property ( weak, nonatomic ) UILabel *likeLabel;                   // 点赞次数
@property ( weak, nonatomic ) UILabel *otherInfoLabel;              // 其他信息(最新易家人)
@property ( weak, nonatomic ) UIImageView *genderImageView;         // 性别图标
@property ( weak, nonatomic ) UIImageView *locationIconView;        // 位置图标



@end

@implementation EVDiscoverUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self createSubviews];
        [self layoutMySubviews];
    }
    return self;
}

- (void)createSubviews
{    
    CCHeaderImageView *iconImageView = [[CCHeaderImageView alloc] init];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
//    iconImageView.layer.borderColor = CCBorderCGColor;
//    iconImageView.layer.borderWidth = 0.5;
//    iconImageView.layer.cornerRadius = 21;
    
    UILabel *remarksLabel = [[UILabel alloc] init];
    [self.contentView addSubview:remarksLabel];
    self.remarksLabel = remarksLabel;
    
    UIImageView *genderImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:genderImageView];
    self.genderImageView = genderImageView;
    
    UILabel *singatureLabel = [[UILabel alloc] init];
    [self.contentView addSubview:singatureLabel];
    self.signatureLabel = singatureLabel;
    
    UIButton *focousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:focousButton];
    self.focousButton = focousButton;
    [_focousButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *likeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:likeLabel];
    self.likeLabel = likeLabel;
    
    UIImageView *locationIconView = [[UIImageView alloc] init];
    [self.contentView addSubview:locationIconView];
    self.locationIconView = locationIconView;
    
    UILabel *otherInfoLabel = [[UILabel alloc] init];
    [self.contentView addSubview:otherInfoLabel];
    self.otherInfoLabel = otherInfoLabel;

}

- (void)layoutMySubviews
{
    [_iconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [_iconImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_iconImageView autoSetDimensionsToSize:CGSizeMake(42, 42)];
    
    // 字和线的颜色
    UIColor *blackColor = [UIColor colorWithHexString:@"#ececec"];
    
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.];
    [lineView autoSetDimension:ALDimensionHeight toSize:1.];
    [lineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_iconImageView];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.];
    lineView.backgroundColor = blackColor;
    
    [_focousButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:0];
    [_focousButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_focousButton autoSetDimensionsToSize:CGSizeMake(50, 50)];
    
    [_remarksLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImageView withOffset:15];
    [_remarksLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.];
    _remarksLabel.font = CCBoldFont(15);
    _remarksLabel.textColor = CCTextBlackColor;
    
    [_genderImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_remarksLabel withOffset:5.0];
    [_genderImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_remarksLabel];
    
    [_signatureLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_remarksLabel withOffset:3.];
    [_signatureLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_remarksLabel];
    [_signatureLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:55];
    _signatureLabel.font = [UIFont systemFontOfSize:12];
    _signatureLabel.textColor = CCTextBlackColor;
    
    [_locationIconView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_remarksLabel];
    
    [_otherInfoLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_locationIconView];
    [_otherInfoLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_signatureLabel withOffset:5.];
    _otherInfoLabel.font = _signatureLabel.font;
    _otherInfoLabel.textColor = _signatureLabel.textColor;
    
    [_locationIconView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_otherInfoLabel];
    
    [_likeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_otherInfoLabel withOffset:23];
    [_likeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_otherInfoLabel];
    _likeLabel.font = _signatureLabel.font;
    _likeLabel.textColor = _signatureLabel.textColor;
}

- (void)setCellItem:(EVDiscoverUserModel *)cellItem
{
    _cellItem = cellItem;
    [self.iconImageView cc_setImageWithURLString:cellItem.logourl placeholderImageName:@"avatar" isVip:[cellItem.vip integerValue] vipSizeType:CCVipMiddle];
    self.remarksLabel.text = [NSString stringWithFormat:@"%@",cellItem.nickname];
    self.signatureLabel.text = cellItem.signature.length > 0 ? cellItem.signature : kDefaultSignature_other;
    
    // 根据类型显示其他信息
    if ( [cellItem.type isEqualToString:kCCDiscoverUserModelTypeNew] )
    {
        _otherInfoLabel.text = [NSString stringWithFormat:kE_GlobalZH(@"living_all_time"),cellItem.live_time];
    }
    else if ( [cellItem.type isEqualToString:kCCDiscoverUserModelTypeRecommend] )
    {
        _otherInfoLabel.text = [NSString stringWithFormat:@"%@  %@",kE_GlobalZH(@"e_fans"),cellItem.fans_count];
    }
    else if ( [cellItem.type isEqualToString:kCCDiscoverUserModelTypeHot] )
    {
        _otherInfoLabel.text = [NSString stringWithFormat:@"%@  %@",kE_GlobalZH(@"watch_all_people"),cellItem.watch_count];
    }
    else if ( [cellItem.type isEqualToString:kCCDiscoverUserModelTypeCity] )
    {
        _otherInfoLabel.text = [NSString stringWithFormat:@" %@",cellItem.location];
    }
    
    if ( [cellItem.type isEqualToString:kCCDiscoverUserModelTypeCity] )
    {
        _locationIconView.image = [UIImage imageNamed:@"person_circle_gps_blck"];
    }
    else
    {
        _locationIconView.image = nil;
    }
    
    self.likeLabel.text = [NSString stringWithFormat:@"%@  %@",kE_GlobalZH(@"eLike"),cellItem.like_count];
    
    //  当是自己时,不显示关注按钮
    self.focousButton.hidden = [cellItem.name isEqualToString:[EVLoginInfo localObject].name];
    NSString *genderImageName = [cellItem.gender isEqualToString:@"male"]?@"home_icon_man" : @"home_icon_woman";
    _genderImageView.image = [UIImage imageNamed:genderImageName];
    NSString *followedImageName = [cellItem.followed integerValue] == 0 ? @"person_icon_add" : @"person_icon_add_success" ;
    [_focousButton setImage:[UIImage imageNamed:followedImageName] forState:UIControlStateNormal];
    
}

- (void)buttonClicked:(UIButton *)button
{
    if ( self.action )
    {
        self.action(self.cellItem,button);
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype) cellForTabelView:(UITableView *)tableView
{
    static NSString *cellIndentifier = @"EVDiscoverUserCell";
    EVDiscoverUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if ( !cell )
    {
        cell = [[EVDiscoverUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    return cell;
}

@end
