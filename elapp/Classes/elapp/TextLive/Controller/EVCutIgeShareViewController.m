//
//  EVCutIgeShareViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/27.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVCutIgeShareViewController.h"
#import "EVSharePartView.h"
#import "EVShareManager.h"
#import "EVLoginInfo.h"

#define  iWid (ScreenWidth * 0.8)
@interface EVCutIgeShareViewController ()<EVWebViewShareViewDelegate>

@property (nonatomic, weak) UIImageView *cutIgeView;

@property (nonatomic, strong) NSLayoutConstraint *cutIgeViewWid;
@property (nonatomic, strong) NSLayoutConstraint *cutIgeViewHig;

@property (nonatomic, assign) CGFloat imageWid;
@property (nonatomic, assign) CGFloat imageHig;

@property (nonatomic, strong) EVSharePartView *eVSharePartView;
@end

@implementation EVCutIgeShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:backBtn];
    backBtn.frame = CGRectMake(0, 20, 64, 44);
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [backBtn setImage:[UIImage imageNamed:@"btn_return_w_n"] forState:(UIControlStateNormal)];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.view addSubview:titleLabel];
    [titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:backBtn];
    [titleLabel autoSetDimensionsToSize:CGSizeMake(100, 22)];
    titleLabel.text = @"截屏分享";
    titleLabel.font = [UIFont textFontB2];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:shareBtn];
    shareBtn.frame = CGRectMake(ScreenWidth - 64, 20, 64, 44);
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [shareBtn setImage:[UIImage imageNamed:@"btn_share_w_n"] forState:(UIControlStateNormal)];
    
    
    UIImageView *cutIgeView = [[UIImageView alloc] init];
    [self.view addSubview:cutIgeView];
    self.cutIgeView = cutIgeView;
    [cutIgeView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [cutIgeView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    self.cutIgeViewWid =  [cutIgeView autoSetDimension:ALDimensionWidth toSize:self.imageWid];
    self.cutIgeViewHig =    [cutIgeView autoSetDimension:ALDimensionHeight toSize:self.imageHig];
    cutIgeView.image = self.cutImage;
    
    [self.view addSubview:self.eVSharePartView];
    
    //取消分享
    __weak typeof(self) weakSelf = self;
    self.eVSharePartView.cancelShareBlock = ^() {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.eVSharePartView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
        }];
    };
}

- (void)shareViewShowAction
{
    [UIView animateWithDuration:0.3 animations:^{
        self.eVSharePartView.frame = CGRectMake(0, 0, ScreenHeight,  ScreenHeight);
    }];
}

- (void)shareType:(EVLiveShareButtonType)type
{
//    if (self.urlStr == nil) {
//        
//        [EVProgressHUD showError:@"加载完成在分享"];
//        
//    }
    
    ShareType shareType = ShareTypeMineTextLive;
    
    [UIImage gp_imageWithURlString:[EVLoginInfo localObject].logourl comoleteOrLoadFromCache:^(UIImage *image, BOOL loadFromLocal) {
        [[EVShareManager shareInstance] shareContentWithPlatform:type shareType:shareType titleReplace:nil descriptionReplaceName:@"" descriptionReplaceId:nil URLString:nil image:image outImage:self.cutImage];
    }];
}

- (void)backClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareClick:(UIButton *)btn
{
    [self shareViewShowAction];
    
}

- (void)setCutImage:(UIImage *)cutImage
{
    _cutImage = cutImage;
    if (cutImage.size.width > iWid) {
        self.cutIgeViewWid.constant = iWid;
        self.imageWid = iWid;
        self.cutIgeViewHig.constant = (cutImage.size.width * iWid)/cutImage.size.width;
        self.imageHig = (cutImage.size.height * iWid)/cutImage.size.width;
    }else {
        self.imageWid = cutImage.size.width;
        self.cutIgeViewWid.constant = cutImage.size.width;
        self.cutIgeViewHig.constant = cutImage.size.height;
        self.imageHig = cutImage.size.height;
    }
    self.cutIgeView.image = cutImage;
}

#pragma mark - lazy loading
- (EVSharePartView *)eVSharePartView {
    if (!_eVSharePartView) {
        _eVSharePartView = [[EVSharePartView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
        _eVSharePartView.backgroundColor = [UIColor colorWithHexString:@"#303030" alpha:0.7];
        _eVSharePartView.eVWebViewShareView.delegate = self;
    }
    return _eVSharePartView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
