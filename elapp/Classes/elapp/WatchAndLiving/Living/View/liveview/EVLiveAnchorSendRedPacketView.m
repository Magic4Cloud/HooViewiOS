//
//  EVLiveAnchorSendRedPacketView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVLiveAnchorSendRedPacketView.h"
#import <PureLayout.h>
#import "EVChatTextView.h"
#import "NSString+Extension.h"

#define kElementHeight 34
#define kPacketViewHeight 367

#define defaultGreeting  kE_GlobalZH(@"congratulation_fortune_lucky")
#define defaultPacketsErrorStr  kE_GlobalZH(@"once_most_send_red_num")
#define defaultEcoinErrorStr  kE_GlobalZH(@"coin_num_most_red_num")
#define defaultGreetingErrorStr  kE_GlobalZH(@"blessing_most_ten_num")

#define kEcoinCount      kE_GlobalZH(@"most_not_self_coin")
#define defaultTextColor [UIColor colorWithHexString:@"#403B37"]

typedef NS_ENUM(NSInteger, CCElementType)
{
    CCElementNumber,
    CCElementEcoins
};

@interface EVLiveAnchorSendRedPacketView () <UITextFieldDelegate, UITextViewDelegate>

/** 容器 */
@property ( nonatomic, strong ) UIWindow *container;

/** 领取红包的人数 */
@property ( nonatomic, weak ) UITextField *packetsTF;

/** 红包的总共钱数 */
@property ( nonatomic, weak ) UITextField *ecoinsTF;

/** 发送红包 */
@property ( nonatomic, weak ) UIButton *sendBtn;

/** 祝福语 */
@property ( nonatomic, weak ) EVChatTextView *greetingTextView;

/** 填写红包信息高度约束 */
@property ( nonatomic, weak ) NSLayoutConstraint *packetViewHC;

/** 红包信息 */
@property ( nonatomic, weak ) UIView *packetView;

@end

@implementation EVLiveAnchorSendRedPacketView

- (void)dealloc
{
    _container.hidden = YES;
    [_container resignKeyWindow];
//    _container = nil;
    [_packetsTF removeObserver:self forKeyPath:@"text"];
    [_ecoinsTF removeObserver:self forKeyPath:@"text"];
    [EVNotificationCenter removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpView];
        [EVNotificationCenter addObserver:self selector:@selector(keyBoardShow) name:UIKeyboardWillShowNotification object:nil];
        [EVNotificationCenter addObserver:self selector:@selector(keyBoardHide) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)keyBoardShow
{
    CGFloat y = ScreenHeight / 2 - kPacketViewHeight / 2 - 100;
    [self animationWithDuration:1 y:y complition:nil];
}

- (void)keyBoardHide
{
    CGFloat y = ScreenHeight / 2 - kPacketViewHeight / 2;
    [self animationWithDuration:1 y:y complition:nil];
}

- (void)show
{
    self.container.hidden = NO;
    CGFloat y = ScreenHeight / 2 - kPacketViewHeight / 2;
    [self animationWithDuration:0.5 y:y complition:nil];
}

- (void)animationWithDuration:(CGFloat)duration y:(CGFloat)y complition:(void (^ __nullable)(BOOL finished))complete
{
    CGRect frame = self.packetView.frame;
    frame.origin.y = y;
    [UIView animateWithDuration:duration animations:^{
        self.packetView.frame = frame;
    } completion:complete];
}

- (void)dismiss
{
    CGFloat y = ScreenHeight;
    self.container.hidden = YES;
    [self animationWithDuration:0.5 y:y complition:^(BOOL finished){
        self.sendBtn.enabled = NO;
        self.sendBtn.alpha = 0.6;
        self.packetsTF.text = @"";
        self.ecoinsTF.text = @"";
        self.greetingTextView.text = @"";
        self.greetingTextView.placeHolderHidden = NO;
        [self hideKeyBoard];
    }];
}

- (void)send
{
    NSInteger numOfPackets = [self.packetsTF.text integerValue];
    NSInteger ecoins = [self.ecoinsTF.text integerValue];
    
    if ( numOfPackets > 50 )
    {
        [EVProgressHUD showError:defaultPacketsErrorStr];
        return;
    }
    if ( ecoins < numOfPackets )
    {
        [EVProgressHUD showError:defaultEcoinErrorStr];
        return;
    }
    if ( [self.greetingTextView.text numOfWordWithLimit:10] > 10 )
    {
        [EVProgressHUD showError:defaultGreetingErrorStr];
        return;
    }
    NSString *greeting = self.greetingTextView.text;
    if ( !greeting || [greeting isEqualToString:@""] )
    {
        greeting = defaultGreeting;
    }
    if ( self.delegate && [self.delegate respondsToSelector:@selector(liveAnchorSendPacketViewView:packets:ecoins:greetings:)] )
    {
        [self.delegate liveAnchorSendPacketViewView:self packets:numOfPackets ecoins:ecoins greetings:greeting];
    }
    [self dismiss];
}

- (void)hideKeyBoard
{
    [self.packetsTF resignFirstResponder];
    [self.ecoinsTF resignFirstResponder];
    [self.greetingTextView resignFirstResponder];
}

- (void)setUpView
{
    // 容器
    UIWindow *container = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    container.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.7];
    container.hidden = YES;
    [container makeKeyAndVisible];
    _container = container;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [container addGestureRecognizer:tap];
    
    // 填写红包信息
    UIView *packetView = [[UIView alloc] initWithFrame:CGRectMake(container.center.x - 275 / 2, container.frame.size.height, 275, kPacketViewHeight)];
    packetView.layer.cornerRadius = 9;
    packetView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    [container addSubview:packetView];
    _packetView = packetView;
    
    // "发红包"
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headBtn setTitle:kE_GlobalZH(@"send_red_pack") forState:UIControlStateNormal];
    [headBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    headBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    headBtn.titleLabel.font = EVNormalFont(18);
    headBtn.userInteractionEnabled = NO;
    [headBtn setBackgroundImage:[UIImage imageNamed:@"living_icon_sendRedPacket"] forState:UIControlStateNormal];
    [packetView addSubview:headBtn];
    [headBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    
    // 红包个数
    UIView *packetsNumContainer = [self containerViewWithType:CCElementNumber];
    [packetView addSubview:packetsNumContainer];
    [packetsNumContainer autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13];
    [packetsNumContainer autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:13];
    [packetsNumContainer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:headBtn withOffset:10];
    
    // 发送的火眼豆数
    UIView *ecoinsNumContainer = [self containerViewWithType:CCElementEcoins];
    [packetView addSubview:ecoinsNumContainer];
    [ecoinsNumContainer autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13];
    [ecoinsNumContainer autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:13];
    [ecoinsNumContainer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:packetsNumContainer withOffset:10];
    
    // 祝福语
    EVChatTextView *meetingTextView = [[EVChatTextView alloc] init];
    meetingTextView.delegate = self;
    meetingTextView.backgroundColor = [UIColor whiteColor];
    meetingTextView.textColor = [UIColor blackColor];
    meetingTextView.placeHoder = defaultGreeting;
    meetingTextView.layer.cornerRadius = 4.5f;
    meetingTextView.placeHoderTextColor = [UIColor colorWithHexString:@"#403B37" alpha:.6];
    meetingTextView.font = EVNormalFont(14);
    [packetView addSubview:meetingTextView];
    [meetingTextView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13];
    [meetingTextView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:13];
    [meetingTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:ecoinsNumContainer withOffset:10];
    [meetingTextView autoSetDimension:ALDimensionHeight toSize:70];
    _greetingTextView = meetingTextView;
    
    // send red packet
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:kE_GlobalZH(@"send_red_pack") forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.backgroundColor = [UIColor colorWithHexString:@"#DF4243"];
    sendBtn.enabled = NO;
    sendBtn.alpha = 0.6;
    sendBtn.layer.cornerRadius = 6;
    [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.titleLabel.font = EVNormalFont(16);
    [packetView addSubview:sendBtn];
    [sendBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:30];
    [sendBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [sendBtn autoSetDimension:ALDimensionHeight toSize:34];
    [sendBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13];
    [sendBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:13];
    _sendBtn = sendBtn;
    
    // 关闭
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"living_icon_cancel"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [packetView addSubview:closeBtn];
    [closeBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [closeBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
}

- (UIView *)containerViewWithType:(CCElementType)type
{
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor clearColor];
    
    // 上部分
    UIView *contentView = [[UIView alloc] init];
    contentView.layer.cornerRadius = 3;
    contentView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:contentView];
    [contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [contentView autoSetDimension:ALDimensionHeight toSize:kElementHeight];
    
    UILabel *elementTitleLabel = [[UILabel alloc] init];
    elementTitleLabel.font = EVBoldFont(14);
    elementTitleLabel.textColor = defaultTextColor;
    [contentView addSubview:elementTitleLabel];
    [elementTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13];
    [elementTitleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    // 单位  个/火眼豆
    UILabel *classifier = [[UILabel alloc] init];
    classifier.textColor = defaultTextColor;
    classifier.font = EVBoldFont(14);
    [contentView addSubview:classifier];
    [classifier autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    // 输入
    UITextField *tf = [[UITextField alloc] init];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.tintColor = [UIColor blackColor];
    tf.font = EVNormalFont(14);
    tf.textAlignment = NSTextAlignmentRight;
    tf.delegate = self;
    [tf addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [contentView addSubview:tf];
    [tf autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [tf autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [tf autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:classifier withOffset:-5];
    [tf autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:elementTitleLabel withOffset:5 relation:NSLayoutRelationLessThanOrEqual];
    [classifier autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:13];

    // 提示语
    UILabel *alertLabel = [[UILabel alloc] init];
    alertLabel.textColor = [UIColor colorWithHexString:@"#403B37" alpha:0.6];
    alertLabel.font = EVNormalFont(11);
    [containerView addSubview:alertLabel];
    [alertLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:contentView withOffset:7];
    [alertLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [alertLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:contentView];
    
    if ( type == CCElementNumber )
    {
        elementTitleLabel.text = kE_GlobalZH(@"red_pack_num");
        classifier.text = kE_GlobalZH(@"e_one");
        tf.placeholder = kE_GlobalZH(@"enter_red_pack_num");
        alertLabel.text = [NSString stringWithFormat:@"  %@",kE_GlobalZH(@"once_most_send_red_num")];
        self.packetsTF = tf;
    }
    else
    {
        elementTitleLabel.text = kE_GlobalZH(@"all_send_red");
        classifier.text = kE_Coin;
        tf.placeholder = kE_GlobalZH(@"enter_red_pack_num");
        alertLabel.text = kE_GlobalZH(@"luck_red_pack_every_people_coin_random");
        self.ecoinsTF = tf;
    }
    return containerView;
}

#pragma mark - UITextField delegate

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ( [object isKindOfClass:[UITextField class]] && [keyPath isEqualToString:@"text"] )
    {
        if ( [self.packetsTF.text integerValue] > 0 && [self.ecoinsTF.text integerValue] > 0 )
        {
            self.sendBtn.enabled = YES;
            self.sendBtn.alpha = 0.9f;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( [string isEqualToString:@""] )
    {
        return YES;
    }
    
//    BOOL validate = [self validateNumber:string];
//    
//    if ( textField == self.packetsTF && [textField.text integerValue] * 10 + [string integerValue] > 50 )
//    {
//        self.sendBtn.enabled = NO;
//        self.sendBtn.alpha = 0.6;
//        [EVProgressHUD showError:defaultPacketsErrorStr];
//        return NO;
//    }
//    
//    if ( textField == self.ecoinsTF && [textField.text integerValue] > self.anchorEcoinCount) {
//        [EVProgressHUD showError:kEcoinCount];
//        return NO;
//    }
    
    return YES;
}

- (BOOL)validateNumber:(NSString*)number
{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    
    if ( !res )
    {
        [EVProgressHUD showError:kE_GlobalZH(@"only_send_num")];
    }
    return res;
}

#pragma mark - UITextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ( textView == self.greetingTextView )
    {
        CGFloat y = ScreenHeight / 2 - kPacketViewHeight / 2 - 100;
        [self animationWithDuration:0.2 y:y complition:nil];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ( textView == self.greetingTextView )
    {
    }
    return YES;
}

@end
