//
//  EVLivePrePareView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLivePrePareView.h"
#import "EVShareManager.h"
#import <PureLayout.h>
#import "EVLiveTitleTextView.h"
#import "NSString+Extension.h"

@class EVLiveShareMenuView;

static NSInteger const shareBtnBaseTag = 999;
static NSInteger const shareLabBaseTag = 888;



#define kShareButtonWH 60
#define kShareButtonMarginTitleLabel 37


#define kDismissAnimationTime 0.3


#define kINNSER_MARGIN 30
#define kMaxWordCount 20


@interface EVLivePrePareView () <UITextViewDelegate>

@property (nonatomic,weak) UILabel *locationLabel;

@property (weak, nonatomic) UILabel *synchronizedToWeiBoLabel;

@property (nonatomic,weak) UIView *settingContentView;



@property (weak, nonatomic) UIButton *cancelButton;

@property (weak, nonatomic) UIButton *permissionButton;


@property (nonatomic,weak) UIButton *changeCameraButton;

@property (weak, nonatomic)  UIButton *coverButton;

@property (weak, nonatomic) UIButton *beautyButton;  /**< 美颜按钮 */

@property (nonatomic,strong) UIColor *buttonTitleColor;

@property (nonatomic,strong) UIFont *buttonTitleFont;

@property ( strong, nonatomic ) UIButton *selectedShareButton;

@property ( weak, nonatomic ) UIImageView *coverBtnTopImageView; // 加号图标

@property ( weak, nonatomic ) UILabel *coverBtnBottomLabel;

@property ( strong, nonatomic ) NSLayoutConstraint *startButtonBottomConstraint;  // 开始按钮底部的约束

@property ( strong, nonatomic ) NSLayoutConstraint *coverButtonTopConstraint;     // 封面顶部约束

@property (assign, nonatomic) BOOL hasWord; /**< 标记editview是否有文字 */

@property (nonatomic, weak) UIView *midContentView;

@property (nonatomic,weak) UIButton *toggleButton;

@property (nonatomic,weak) UIView *captureView;

@property (nonatomic, weak) UIImageView *backImageView;
@end

@implementation EVLivePrePareView

- (void)dealloc
{
    EVLog(@"EVLivePrePareView -- dealloc");
    [EVNotificationCenter removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
//        self.backgroundColor = [UIColor colorWithHexString:@"#303030"];
//        self.alpha = 0.56;
        [self setUp];
        [self setUpNoticaiton];
    }
    return self;
}

- (void)setUpNoticaiton
{
    [EVNotificationCenter addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
    [EVNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [EVNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)textChange
{
    [self checkTitle];
}
// 键盘弹出
- (void)keyboardWillShow:(NSNotification *)notification
{

    //NSDictionary *info = notification.userInfo;
    //NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    //CGFloat keybaordHeight = [value CGRectValue].size.height;
//    self.startButtonBottomConstraint.constant = ScreenHeight > 568 ? - keybaordHeight - 40.f : -keybaordHeight;
//    self.coverButtonTopConstraint.constant = ScreenHeight > 568 ? 90 / 614.f * ScreenHeight : 63.f;
    // 隐藏分类列表并将选中分类按钮设置为未选中
//        self.startButtonBottomConstraint.constant = - 140;
//        self.coverButtonTopConstraint.constant = 180.f;
}
// 键盘收回
- (void)keyboardWillHide:(NSNotification *)notification
{
//    self.startButtonBottomConstraint.constant = - 140;
//    self.coverButtonTopConstraint.constant = 180.f;
}

- (BOOL)checkTitle
{
    NSInteger wordCount = [self.editView.text numOfWordWithLimit:0];
    EVLog(@"---%@",self.editView.text);
    if ( wordCount > kMaxWordCount )
    {
        [EVProgressHUD showError:kE_GlobalZH(@"topic_title_length") toView:self];
        return NO;
    }
    return YES;
}

- (void)setHasWord:(BOOL)hasWord
{
    if ( _hasWord != hasWord )
    {
        _hasWord = hasWord;
        if ( _hasWord )
        {
            [self.editView resignFirstResponder];
            self.editView.tintColor = [UIColor evMainColor];
            [self.editView becomeFirstResponder];
        }
        else
        {
            [self.editView resignFirstResponder];
            self.editView.tintColor = [UIColor clearColor];
            [self.editView becomeFirstResponder];
            
        }
    }

}

//- (void)setTitle:(NSString *)title
//{
//    self.editView.text = title;
//}

//- (NSString *)title
//{
//    return self.editView.text;
//}

- (void)setCaptureSuccess:(BOOL)captureSuccess
{
    _captureSuccess = captureSuccess;
    self.coverButton.selected = captureSuccess;
    [self endCaptureImage];
}


- (void)setCoverImage:(UIImage *)coverImage
{
    _coverImage = coverImage;
    [self.coverButton setImage:_coverImage forState:UIControlStateNormal];
    self.coverButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverBtnTopImageView.hidden = _coverImage != nil;
    self.coverBtnBottomLabel.hidden = _coverImage != nil;
}

- (void)setUp
{
    UIImageView *backImageView = [[UIImageView alloc] init];
    [self addSubview:backImageView];
    backImageView.backgroundColor = [UIColor clearColor];
    backImageView.image = [UIImage imageNamed:@"IOS_bg"];
    [backImageView autoPinEdgesToSuperviewEdges];
    self.backImageView = backImageView;
    
    _buttonTitleColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _buttonTitleFont = [UIFont systemFontOfSize:15];
    UIView *settingContentView = [[UIView alloc] init];
    settingContentView.backgroundColor = [UIColor clearColor];
    [self addSubview:settingContentView];
    self.settingContentView = settingContentView;
    [settingContentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
//    UIView *bgView = [[UIView alloc] init];
//    [self.settingContentView addSubview:bgView];
//    [bgView autoPinEdgesToSuperviewEdges];
//    bgView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.tag = EVLivePrePareViewButtonCancel;
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton setImage:[UIImage imageNamed:@"hv_back_return"] forState:UIControlStateNormal];
    [self.settingContentView addSubview:cancelButton];
    [cancelButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:35];
    [cancelButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [cancelButton autoSetDimensionsToSize:CGSizeMake(40, 40)];
    self.cancelButton = cancelButton;


    UILabel *titleLabel = [[UILabel alloc] init];
    [self.settingContentView addSubview:titleLabel];
    [titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:cancelButton];
    [titleLabel autoSetDimensionsToSize:CGSizeMake(100, 25)];
    titleLabel.text = @"我的直播间";
    titleLabel.font = [UIFont systemFontOfSize:18.f];
    titleLabel.textColor = [UIColor evMainColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
//    CGFloat topBtnWith = 40.f;
//    CGFloat topBtnHeight = 40.f;
    
//    // 切换摄像头
//    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.changeCameraButton = changeButton;
//    [settingContentView addSubview:changeButton];
//    changeButton.tag = EVLivePrePareViewButtonToggleCamera;
//    [changeButton autoSetDimensionsToSize:CGSizeMake(topBtnWith, topBtnHeight)];
//    [changeButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:cancelButton];
//    [changeButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:cancelButton withOffset: - 5.f];
//    [changeButton setImage:[UIImage imageNamed:@"setting_icon_change"] forState:UIControlStateNormal];
    
    
//    UIButton *permissionButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [settingContentView addSubview:permissionButton];
//    permissionButton.tag = EVLivePrePareViewButtonPermission;
//    [permissionButton setTitle:kE_GlobalZH(@"el_permission") forState:(UIControlStateNormal)];
//    [permissionButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    [permissionButton setBackgroundColor:[UIColor clearColor]];
//    [permissionButton autoSetDimensionsToSize:CGSizeMake(topBtnWith, topBtnHeight)];
//    [permissionButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:cancelButton];
//    [permissionButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:changeButton withOffset: - 5.f];
    
//    UIButton *categoryButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [settingContentView addSubview:categoryButton];
//    self.categoryButton = categoryButton;
//    categoryButton.tag = EVLivePrePareViewButtonCategory;
//    [categoryButton setTitle:kE_GlobalZH(@"el_topic") forState:(UIControlStateNormal)];
//    [categoryButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    [categoryButton setBackgroundColor:[UIColor clearColor]];
//    [categoryButton autoSetDimensionsToSize:CGSizeMake(60, topBtnHeight)];
//    [categoryButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:cancelButton];
//    [categoryButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:permissionButton withOffset: - 5.f];
    
    UIView *editBackView = [[UIView alloc] init];
    [self.settingContentView addSubview:editBackView];
    editBackView.backgroundColor = [UIColor colorWithHexString:@"#5C2D7E"];
    editBackView.alpha = 0.3;
    [editBackView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:80];
    [editBackView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [editBackView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [editBackView autoSetDimension:ALDimensionHeight toSize:100];
    
    
    UITextField *editTextFiled = [[UITextField alloc] init];
    [self.settingContentView addSubview:editTextFiled];
    [editTextFiled autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:80];
    [editTextFiled autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [editTextFiled autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [editTextFiled autoSetDimension:ALDimensionHeight toSize:100];
    editTextFiled.backgroundColor = [UIColor clearColor];
    editTextFiled.textColor = [UIColor whiteColor];
    editTextFiled.textAlignment = NSTextAlignmentCenter;
    editTextFiled.placeholder = @"好的标题会吸引更多的人噢";
    editTextFiled.font = [UIFont systemFontOfSize:16.f];
    editTextFiled.alpha = 1;
    self.editTextFiled = editTextFiled;
//    [self.editTextFiled becomeFirstResponder];

    

    // 添加封面
    UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    coverButton.tag = EVLivePrePareViewButtonCover;
    coverButton.backgroundColor = [UIColor clearColor];
    UIImage *coverImage = [UIImage imageNamed:@"btn__live_cover_n"];
    [coverButton setBackgroundImage:coverImage forState:(UIControlStateNormal)];
    [self.settingContentView addSubview:coverButton];
    self.coverButton = coverButton;
    [coverButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [coverButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_editTextFiled withOffset:40];
    [coverButton autoSetDimensionsToSize:CGSizeMake(coverImage.size.width, coverImage.size.height)];
    coverButton.layer.cornerRadius = 7.5f;
    coverButton.layer.masksToBounds = YES;
    
//    UILabel *bottomLabel = [[UILabel alloc] init];
//    [coverButton addSubview:bottomLabel];
//    self.coverBtnBottomLabel = bottomLabel;
//    [bottomLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7];
//    [bottomLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
//    bottomLabel.text = kE_GlobalZH(@"e_cover");
//    bottomLabel.textColor = [UIColor whiteColor];
//    bottomLabel.font = EVNormalFont(13);
//    
//    
//    UIImageView *topImageView = [[UIImageView alloc] init];
//    [coverButton addSubview:topImageView];
//    self.coverBtnTopImageView = topImageView;
//    [topImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
//    [topImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
//    topImageView.image = [UIImage imageNamed:@"setting_icon_photo"];
    
   
    

    
//    // 直播标题
//    EVLiveTitleTextView *editView = [[EVLiveTitleTextView alloc] init];
//    editView.delegate = self;
//    editView.returnKeyType = UIReturnKeyDone;
//    editView.backgroundColor = [UIColor blackColor];
//    editView.font = [UIFont systemFontOfSize:16.f];
//    editView.placeholder = kE_GlobalZH(@"living_nickname");
//    editView.textAlignment = NSTextAlignmentCenter;
//    editView.tintColor = [UIColor evMainColor];
//    editView.textColor = [UIColor whiteColor];
//    [self.settingContentView addSubview:editView];
//    [editView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:settingContentView withOffset:80];
//    [editView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
//    [editView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
//    [editView autoSetDimension:ALDimensionHeight toSize:60];
//    self.editView = editView;
//    [editView becomeFirstResponder];
    
    
    [self setUpMenuButtons];
    [self setUpCaptureView];
    
}

- (void)setUpCaptureView
{
    // captureView
    UIView *captureView = [[UIView alloc] init];
    captureView.backgroundColor = [UIColor clearColor];
    captureView.hidden = YES;
    [self addSubview:captureView];
    self.captureView = captureView;
    [captureView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    UIButton *captureImageButton = [[UIButton alloc] init];
    captureImageButton.tag = EVLivePrePareViewButtonCaptureAnImage;
    [captureView addSubview:captureImageButton];
    [captureImageButton setBackgroundImage:[UIImage imageNamed:@"living_over_action"] forState:UIControlStateNormal];
    [captureImageButton setTitle:kE_GlobalZH(@"shoot_cover") forState:UIControlStateNormal];
    [captureImageButton setTitleColor:[UIColor evMainColor] forState:UIControlStateNormal];
    [captureImageButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kINNSER_MARGIN];
    [captureImageButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kINNSER_MARGIN];
    [captureImageButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:25];
    [captureImageButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *toogleButton = [[UIButton alloc] init];
    toogleButton.tag = EVLivePrePareViewButtonToggleCamera;
    [captureView addSubview:toogleButton];
    [toogleButton setImage:[UIImage imageNamed:@"setting_icon_change"] forState:UIControlStateNormal];
    [toogleButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:captureImageButton];
    [toogleButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:captureImageButton withOffset:-16];
    [toogleButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.toggleButton = toogleButton;
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"live_ready_icon_closed"] forState:UIControlStateNormal];
    [captureView addSubview:cancelButton];
    [cancelButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kINNSER_MARGIN];
    [cancelButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kINNSER_MARGIN];
    [cancelButton autoSetDimensionsToSize:CGSizeMake(20, 20)];
    [cancelButton addTarget:self action:@selector(endCaptureImage) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ( [text isEqualToString:@"\n"] )
    {
        [textView resignFirstResponder];
        return NO;
    }
    else
    {
        NSString * replacedText = [textView.text stringByReplacingCharactersInRange:range withString:text];
        if ( replacedText.length > kMaxWordCount )
        {
            textView.text = [replacedText substringToIndex:kMaxWordCount];
            return NO;
        }
    }
    
    return YES;
}


- (void)setUpMenuButtons
{
    CGFloat startButtonHeight = 40.f;//ScreenHeight * 60.0 / 736.0;
    //CGFloat startButtonMarginBottom = 216 + startButtonHeight; //55 * ScreenHeight / 736.0;
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.tag = EVLivePrePareViewButtonLiveStart;
    [self.settingContentView addSubview:startButton];
    [startButton setTitle:kE_GlobalZH(@"start_living") forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    startButton.backgroundColor = [UIColor redColor];
    startButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startButton.layer.cornerRadius =20.f;
    
    self.startButtonBottomConstraint = [startButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.settingContentView withOffset:-140];
    [startButton autoSetDimensionsToSize:CGSizeMake(124, 40)];
    [startButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [startButton autoSetDimension:ALDimensionHeight toSize:startButtonHeight];
    startButton.backgroundColor = [UIColor evMainColor];
    self.startLiveButton = startButton;
    startButton.alpha = 1;
    

    
    // 中间一行图标的容器视图
    UIView *midContentView = [[UIView alloc] init];
    [self.settingContentView addSubview:midContentView];
    [midContentView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:startButton withOffset: - 20];
    [midContentView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [midContentView autoSetDimension:ALDimensionHeight toSize:40];
    [midContentView autoSetDimension:ALDimensionWidth toSize:ScreenWidth];
    self.midContentView = midContentView;
    
    NSMutableArray *shareImageNormalArray = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *shareImageSelectedArray = [NSMutableArray arrayWithCapacity:5];
    //NSMutableArray *shareLabelNormalArray = [NSMutableArray arrayWithCapacity:5];
    // 判断本地安装的可分享的APP
    if ( [EVShareManager qqInstall] )
    {
        [shareImageNormalArray addObject:@"btn_qq_n"];
        [shareImageSelectedArray addObject:@"btn_qq_s"];
        [shareImageNormalArray addObject:@"btn_qzone_n"];
        [shareImageSelectedArray addObject:@"btn_qzone_s"];
//        [shareLabelNormalArray addObject:kE_GlobalZH(@"share_QQ")];
    }
    if ( [EVShareManager weixinInstall] )
    {
        [shareImageNormalArray addObject:@"btn_wechat_n"];
        [shareImageSelectedArray addObject:@"btn_wechat_s"];
//        [shareLabelNormalArray addObject:kE_GlobalZH(@"share_friend")];
        
        [shareImageNormalArray addObject:@"btn_moments_n"];
        [shareImageSelectedArray addObject:@"btn_moments_s"];
//        [shareLabelNormalArray addObject:kE_GlobalZH(@"share_wechat")];
    }
    if ( [EVShareManager weiBoInstall]  )
    {
        [shareImageNormalArray addObject:@"btn_weibo_n"];
        [shareImageSelectedArray addObject:@"btn_weibo_s"];
//        [shareLabelNormalArray addObject:kE_GlobalZH(@"share_weibo")];
    }
    
    NSInteger shareButtonCount = shareImageSelectedArray.count;
    
    UILabel *shareTitle = [[UILabel alloc] init];
    [self.settingContentView addSubview:shareTitle];
    [shareTitle setTextAlignment:NSTextAlignmentCenter];
    [shareTitle setTextColor:[UIColor evTextColorH2]];
    [shareTitle setFont:[UIFont systemFontOfSize:16.f]];
    [shareTitle setText:@"分享到这里获得更高人气"];
    [shareTitle autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [shareTitle autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:midContentView withOffset:-10];
    [shareTitle autoSetDimensionsToSize:CGSizeMake(200, 22)];

    for (int i = 0; i < shareImageNormalArray.count; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = shareBtnBaseTag + i;
        [midContentView addSubview:button];
        [button autoAlignAxis:ALAxisHorizontal toSameAxisOfView:midContentView];
        [button autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:i * (ScreenWidth / shareButtonCount)];
        [button autoSetDimension:ALDimensionWidth toSize:ScreenWidth / shareButtonCount];
        NSString *normalImage = shareImageNormalArray[i];
        NSString *selectedImage = shareImageSelectedArray[i];
        [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(shareButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
//        UILabel *label = [UILabel new];
//        label.tag = shareLabBaseTag + i;
//        label.font = [UIFont systemFontOfSize:11];
//        label.textColor = [UIColor whiteColor];
//        [midContentView addSubview:label];
//        label.text = shareLabelNormalArray[i];
//        label.alpha = 0.f;
//        [label autoAlignAxis:ALAxisVertical toSameAxisOfView:button];
//        [label autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:button withOffset:-3];
        
//        //缓存记忆上一次的事件
//        BOOL shareHide = [CCUserDefault boolForKey:EVShareHide];
//        if (shareHide == YES) {
//        }else{
            // 默认选中朋友圈分享
//            if ( [shareImageNormalArray[i] isEqualToString:@"btn_wechat_n"] )
//            {
//                [self shareButtonDidClicked:button];
//            }
//        }
        
    }
    
    for (UIView *subView in self.settingContentView.subviews)
    {
        if ( [subView isKindOfClass:[UIButton class]] )
        {
            UIButton *btn = (UIButton *)subView;
            [btn addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (UIView *)viewWithTag:(NSInteger)tag
{
    return [self.settingContentView viewWithTag:tag];
}

#pragma mark - CCLiveToggleViewDelegate
- (void)startCaptureImage
{
    [self.editView resignFirstResponder];
//    self.settingContentView.hidden = YES;
//    self.captureView.hidden = NO;
  
}

- (void)endCaptureImage
{
    self.settingContentView.hidden = NO;
    self.captureView.hidden = YES;
//    self.backImageView.hidden= YES;
}


// 点击分享按钮
- (void) shareButtonDidClicked:(UIButton *)button
{
    button.selected = !button.selected;
    if ( self.selectedShareButton != button )
    {
        self.selectedShareButton.selected = NO;
    }
    self.selectedShareButton = button;
    
    //修改  添加分享缓存  记忆上一次的事件
    BOOL shareHide = button.selected ? NO:YES;
    [CCUserDefault setBool:shareHide forKey:EVShareHide];
    
    if (!button.selected) {
        return;
    }
    NSInteger currentTag = button.tag - shareBtnBaseTag;
    NSInteger labelTag = currentTag + shareLabBaseTag;
    UILabel *lab = [self.midContentView viewWithTag:labelTag];
    
    CGFloat scale = 3;
    [UIView animateWithDuration:kDismissAnimationTime * scale animations:^{
        lab.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kDismissAnimationTime * scale  animations:^{
            lab.alpha = 0.0;
        }];
    }];
}

- (void)setSelectedShareButton:(UIButton *)selectedShareButton
{
    _selectedShareButton = selectedShareButton;
    if ( self.selectedShareButton.selected == NO )
    {
        self.currShareTye = EVLivePrePareViewShareNone;
    }
    else
    {
        // 获取选中的分享按钮的图片
        UIImage *normalImage = [_selectedShareButton imageForState:UIControlStateNormal];
        
        // 判断是哪个图片从而判断分享按钮
        if ( [normalImage isEqual:[UIImage imageNamed:@"btn_moments_n"]] )
        {
            self.currShareTye = EVLivePrePareViewShareFriendCircle;
        }
        else if( [normalImage isEqual:[UIImage imageNamed:@"btn_qq_n"]] )
        {
            self.currShareTye = EVLivePrePareViewShareQQ;
        }
        else if( [normalImage isEqual:[UIImage imageNamed:@"btn_wechat_n"]] )
        {
            self.currShareTye = EVLivePrePareViewShareWeixin;
        }
        else if( [normalImage isEqual:[UIImage imageNamed:@"btn_weibo_n"]] )
        {
            self.currShareTye = EVLivePrePareViewShareSina;
        }else if ([normalImage isEqual:[UIImage imageNamed:@"btn_qzone_n"]]) {
            self.currShareTye = EVLivePrePareViewShareQQZone;
        }
    }
}

#pragma mark - actions

- (void)buttonDidClicked:(UIButton *)button
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(livePrePareView:didClickButton:)] )
    {
        if ( button.tag == EVLivePrePareViewButtonLiveStart )
        {
            if ( ![self checkTitle] )
            {
                [self.editView becomeFirstResponder];
                return;
            }
        }
        
        if ( button.tag == EVLivePrePareViewButtonCover )
        {
            [self.editTextFiled resignFirstResponder];
        }
        
        [self.delegate livePrePareView:self didClickButton:button.tag];
    }
}


- (void)setLoadingInfo:(NSString *)loadingInfo canStart:(BOOL)start
{
    if ( !start )
    {
        self.startLiveButton.userInteractionEnabled = NO;
        self.startLiveButton.alpha = 1.0;
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////
- (UIButton *)getShareButtonWithImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName withType:(EVLivePrePareViewButtonType)type
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    [button autoSetDimensionsToSize:CGSizeMake(kShareButtonWH, kShareButtonWH)];
    button.tag = type;
    return button;
}

- (void)disMiss
{   
    CGRect frame = self.frame;
    frame.origin.y = frame.size.height;
    [UIView animateWithDuration:kDismissAnimationTime animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)checkCurrShareType:(EVLivePrePareViewShareType)type
{
    if ( self.currShareTye == type )
    {
        self.currShareTye = EVLivePrePareViewShareNone;
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superview endEditing:YES];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGPoint locationLabelCenter = self.locationLabel.center;
//    locationLabelCenter.y = self.locationButton.frame.origin.y - self.locationLabel.frame.size.height * 0.5 - 4;
//    locationLabelCenter.x = self.locationButton.center.x;
    self.locationLabel.center = locationLabelCenter;
}
@end
