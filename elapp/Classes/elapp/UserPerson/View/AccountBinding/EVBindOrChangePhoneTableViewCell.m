//
//  EVBindOrChangePhoneTableViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVBindOrChangePhoneTableViewCell.h"
#import <PureLayout.h>
#import "EVRelationWith3rdAccoutModel.h"

#define CCBindOrChangePhoneTableViewCellID @"CCBindOrChangePhoneTableViewCellID"
#define CCBindOrChangePhoneTableViewCellHeight 55.0f

@interface EVBindOrChangePhoneTableViewCell ()

@property (weak, nonatomic) UILabel *status;  /**< 状态：绑定/未绑定 */
@property (weak, nonatomic) UILabel *phone;  /**< 绑定的手机号 */
@property (weak, nonatomic) UIButton *bindOrChangePhoneBtn;  /**< 绑定/更换手机号button */

@end

@implementation EVBindOrChangePhoneTableViewCell

#pragma mark - public class methods

+ (NSString *)cellID
{
    return CCBindOrChangePhoneTableViewCellID;
}

+ (CGFloat)cellHeight
{
    return CCBindOrChangePhoneTableViewCellHeight;
}


#pragma mark - life circle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self addCustomSubviews];
    }
    
    return self;
}


#pragma mark - event reponse

- (void)bindOrChangePhone:(UIButton *)btn
{
    if ( self.bindOrChangePhone )
    {
        self.bindOrChangePhone(self.model);
    }
}


#pragma mark - prvivate methods

- (void)addCustomSubviews
{
    UIView *container = [[UIView alloc] init];
    [self.contentView addSubview:container];
    [container autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0f, 16.0f, .0f, 16.0f)];
    
    
    UILabel *title = [UILabel labelWithDefaultTextColor:[UIColor textBlackColor] font:EVNormalFont(14.0f)];
    title.text = kE_GlobalZH(@"e_phone_num");
    [container addSubview:title];
    [title autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [title autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:.0f];
    
    UILabel *status = [UILabel labelWithDefaultTextColor:[UIColor colorWithHexString:@"#bcb3ab"] font:EVNormalFont(12.0f)];
    status.text = kE_GlobalZH(@"alreddy_binding");
    [container addSubview:status];
    self.status = status;
    [status autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:.0f];
    [status autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:title withOffset:4.0f];
    
    UILabel *phone = [UILabel labelWithDefaultTextColor:[UIColor colorWithHexString:@"#858585"] font:EVNormalFont(12.0f)];
    phone.text = @"13213155884";
    [container addSubview:phone];
    self.phone = phone;
    [phone autoAlignAxis:ALAxisHorizontal toSameAxisOfView:status];
    [phone autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:status withOffset:10.0f];
    
    UIButton *bindOrChangeBtn = [[UIButton alloc] init];
    [container addSubview:bindOrChangeBtn];
    self.bindOrChangePhoneBtn = bindOrChangeBtn;
    [bindOrChangeBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:.0f];
    [bindOrChangeBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [bindOrChangeBtn autoSetDimension:ALDimensionWidth toSize:80.0f];
    [bindOrChangeBtn autoSetDimension:ALDimensionHeight toSize:24.0f];
    [bindOrChangeBtn setTitle:kE_GlobalZH(@"change_phone_num") forState:UIControlStateNormal];
    [bindOrChangeBtn.titleLabel setFont:EVNormalFont(12.0f)];
    [bindOrChangeBtn setTitleColor:[UIColor evMainColor] forState:UIControlStateNormal];
    bindOrChangeBtn.layer.borderColor = ([UIColor evMainColor]).CGColor;
    bindOrChangeBtn.layer.borderWidth = .5f;
    bindOrChangeBtn.layer.cornerRadius = 12.0f;
    [bindOrChangeBtn addTarget:self action:@selector(bindOrChangePhone:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - getters and setters

- (void)setModel:(EVRelationWith3rdAccoutModel *)model
{
    _model = model;
    
    self.phone.text = self.model.token;
    if ( self.model.token.length > 0 )
    {
        [self.bindOrChangePhoneBtn setTitle:kE_GlobalZH(@"change_phone_num") forState:UIControlStateNormal];
        self.status.text = kE_GlobalZH(@"alreddy_binding");
    }
    else
    {
        [self.bindOrChangePhoneBtn setTitle:kE_GlobalZH(@"binding_phone_num") forState:UIControlStateNormal];
        self.status.text = kE_GlobalZH(@"not_binding");
    }
}

@end
