//
//  EVLoginView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVLoginView.h"
#import <PureLayout.h>
#import <TTTAttributedLabel.h>

#define CC_ABSOLUTE_IMAGE_W         414.0
#define CC_ABSOLUTE_IMAGE_H         736.0

@interface EVLoginView ()<TTTAttributedLabelDelegate>
@property (strong, nonatomic) TTTAttributedLabel *attributedLabel;
@end

@implementation EVLoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setLoginView];
    }
    return self;
}

- (void)setLoginView
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc]init];
    backImageView.image = [UIImage imageNamed:@"login_pic_bg"];
    backImageView.frame = CGRectMake(0, ScreenHeight - backImageView.image.size.height ,ScreenWidth, backImageView.image.size.height);
    [self addSubview:backImageView];
    
    
    UIImageView *loginimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_logo"]];
    [self addSubview:loginimage];
    
// fix by 王伟
    [loginimage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:cc_absolute_x(100.0f)];
    [loginimage autoAlignAxisToSuperviewAxis:ALAxisVertical];
// fix by 王伟
    [loginimage autoSetDimensionsToSize:loginimage.frame.size];
    
    
    //登录
    UIButton *loginButton = [[UIButton alloc] init];
    [loginButton setBackgroundColor:[UIColor redColor]];
    loginButton.tag = EVLoginButton;
    loginButton.backgroundColor = [UIColor evMainColor];
    [loginButton setTitle:kE_Login forState: UIControlStateNormal];
    [loginButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
// fix by 王伟

    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:loginButton];
// fix by 王伟
    [loginButton autoSetDimensionsToSize:CGSizeMake(ScreenWidth-40,40)];
    [loginButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:loginimage withOffset:cc_absolute_x(82)];
    [loginButton autoAlignAxis:ALAxisVertical toSameAxisOfView:loginimage];
    loginButton.layer.cornerRadius = 6;
    loginButton.layer.masksToBounds = YES;
    [loginButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
  
    //注册
    UIButton *registButton = [[UIButton alloc] init];
    [registButton setBackgroundColor:[UIColor clearColor]];
    [registButton setTitle: kE_GlobalZH(@"e_regist") forState: UIControlStateNormal];
    registButton.tag = EVRegistButton;
    [registButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
// fix by 王伟
    registButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:registButton];
    [registButton autoSetDimensionsToSize:CGSizeMake(ScreenWidth-40, 40)];
    [registButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:loginButton withOffset:20];
    [registButton autoAlignAxis:ALAxisVertical toSameAxisOfView:loginButton];
    registButton.layer.cornerRadius = 6;
    registButton.layer.borderWidth = 1;
    registButton.layer.masksToBounds = YES;
    registButton.layer.borderColor = [UIColor evMainColor].CGColor;
    [registButton setTitleColor:[UIColor evMainColor] forState:(UIControlStateNormal)];
   
    //    /服务条款与协议
    TTTAttributedLabel *serviceagreement = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    [self addSubview:serviceagreement];
    _attributedLabel = serviceagreement;
    [serviceagreement autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:backImageView withOffset:10];
    [serviceagreement autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    [serviceagreement autoSetDimension:ALDimensionHeight toSize:cc_absolute_y(20.0f)];
    UIColor *textColor = [UIColor colorWithHexString:@"#ACACAC"];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString: kE_GlobalZH(@"login_agree_user_protocol") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:textColor}];
    serviceagreement.attributedText = attrStr;
    serviceagreement.delegate = self;
    [serviceagreement setLinkAttributes:@{NSForegroundColorAttributeName:[UIColor evMainColor]}];
    [serviceagreement setActiveLinkAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [serviceagreement addLinkToAddress:@{@"key":@"1"} withRange:NSMakeRange(8, 4)];
    
 
    
    //微博
    UIButton *weiboLoginButton = [[UIButton alloc] init];
    [weiboLoginButton setImage:[UIImage imageNamed:@"login_icon_weibo"] forState:UIControlStateNormal];
    weiboLoginButton.tag = EVWeibobtn;
    [weiboLoginButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
// fix by 王伟
    [self addSubview:weiboLoginButton];
    [weiboLoginButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:serviceagreement withOffset:-35];
    [weiboLoginButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:60];

    //微信
    UIButton *weixinLoginButton = [[UIButton alloc] init];
    [weixinLoginButton setImage:[UIImage imageNamed:@"login_icon_wechat"] forState:UIControlStateNormal];
    [self addSubview:weixinLoginButton];
    weixinLoginButton.tag = EVWeixinbtn;
    [weixinLoginButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
// fix by 王伟
    [weixinLoginButton autoAlignAxis:ALAxisVertical toSameAxisOfView:_attributedLabel];

    //QQ
    UIButton *qqLoingButton = [[UIButton alloc] init];
    [qqLoingButton setImage:[UIImage imageNamed:@"login_icon_qq"] forState:UIControlStateNormal];
    [self addSubview:qqLoingButton];
    qqLoingButton.tag = EVQQbtn;
    [qqLoingButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
// fix by 王伟
    [qqLoingButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:60];
    [@[weiboLoginButton, weixinLoginButton, qqLoingButton] autoAlignViewsToAxis:ALAxisHorizontal];
    
    
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = [UIColor evLineColor];
    [self addSubview:bottomLineView];
    [bottomLineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:50];
    [bottomLineView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-50];
    [bottomLineView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:qqLoingButton withOffset:-15];
    [bottomLineView autoSetDimension:ALDimensionHeight toSize:1];
    
    
    //第三方注册
    UILabel *thirdLabel = [[UILabel alloc] init];
    thirdLabel.text = kE_GlobalZH(@"other_login_way");
    thirdLabel.font = [UIFont systemFontOfSize:12];
    thirdLabel.backgroundColor = [UIColor whiteColor];
    thirdLabel.textColor = [UIColor colorWithHexString:@"#ACACAC"];
    [self addSubview:thirdLabel];
    [thirdLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:registButton];
    [thirdLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:bottomLineView];

}

- (void)buttonClicked:(UIButton *)button
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(loginView:clickButtonWithTag:)] )
    {
        [self.delegate loginView:self clickButtonWithTag:button.tag];
    }
}

//服务条款跟 隐私协议的代理方法
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents
{
    //    [self gotoShowTermWithType:CCPrivacyPolicy];
    if (self.delegate && [self.delegate respondsToSelector:@selector(attributedLabelButton)])
    {
        if ([addressComponents[@"key"] isEqualToString:@"1"])
        {
            [self.delegate attributedLabelButton];
        }
       
    }
}


@end

