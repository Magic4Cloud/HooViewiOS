//
//  EVTextViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVTextViewController.h"
#import "PureLayout.h"

#define CC_ABSOLUTE_IMAGE_W         414.0
#define CC_ABSOLUTE_IMAGE_H         736.0

@interface EVTextViewController ()

@property (strong, nonatomic) UIButton *dismissBtn; // 退出

@end

@implementation EVTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    
    //
    switch (self.type)
    {
        case EVTermOfService:
            self.title = kService_provision;
            break;
        case EVPrivacyPolicy:
            self.title = kPrivacy_policy;
            break;
    }
}

- (void)setType:(EVTextVCType)type
{
    _type = type;
}

- (void)config
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"用户注册协议.rtf" ofType:nil];
    UITextView *textView = [[UITextView alloc] init];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithData:[NSData dataWithContentsOfFile:path] options:@{} documentAttributes:nil error:nil];
    [attriStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor textBlackColor]} range:NSMakeRange(0, attriStr.length)];
    textView.attributedText = attriStr;
    textView.backgroundColor = [UIColor evBackgroundColor];
    textView.editable = NO;
    [self.view addSubview:textView];
    [textView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [textView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [textView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [textView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:64];


    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, ScreenWidth, 64.f)];
    navView.backgroundColor = [UIColor evBackgroundColor];
    [self.view addSubview:navView];
    
    [self.dismissBtn setImage:[UIImage imageNamed:@"login_icon_close_bloack"] forState:UIControlStateNormal];
    [self.dismissBtn addTarget:self action:@selector(dismissBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:self.dismissBtn];
    [self.dismissBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:cc_absolute_x(20.0f)];
    [self.dismissBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:cc_absolute_y(5.0f)];
    [self.dismissBtn autoSetDimension:ALDimensionHeight toSize:cc_absolute_y(44.0f)];
    [self.dismissBtn autoSetDimension:ALDimensionWidth toSize:cc_absolute_x(44.0f)];
}

#pragma mark - event response
- (void)dismissBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setters and getters

- (UIButton *)dismissBtn {
    if ( !_dismissBtn )
    {
        _dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _dismissBtn;
}

@end
