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

#import "EVWebViewShareView.h"
#define  iWid (ScreenWidth * 0.6)
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
    self.view.backgroundColor = [UIColor evSeparetorGrayColor];
    
    UIView * navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:backBtn];
    backBtn.frame = CGRectMake(0, 20, 64, 44);
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [backBtn setImage:[UIImage imageNamed:@"btn_return_n"] forState:(UIControlStateNormal)];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.view addSubview:titleLabel];
    [titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:backBtn];
    [titleLabel autoSetDimensionsToSize:CGSizeMake(100, 22)];
    titleLabel.text = @"截屏分享";
    titleLabel.font = [UIFont textFontB2];
    titleLabel.textColor = [UIColor evBackGroundDeepGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    

    UIImageView *cutIgeView = [[UIImageView alloc] init];
    [self.view addSubview:cutIgeView];
    cutIgeView.layer.shadowOffset = CGSizeMake(1, 1);
    cutIgeView.layer.shadowOpacity = 0.8;
    cutIgeView.layer.shadowRadius = 2;
    cutIgeView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    self.cutIgeView = cutIgeView;
    [cutIgeView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [cutIgeView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view withOffset:-30];
    
    self.cutIgeViewWid =  [cutIgeView autoSetDimension:ALDimensionWidth toSize:self.imageWid];
    self.cutIgeViewHig =    [cutIgeView autoSetDimension:ALDimensionHeight toSize:self.imageHig];
    cutIgeView.image = self.cutImage;
    
//    [self.view addSubview:self.eVSharePartView];
    
    
    EVWebViewShareView * shareView = [[EVWebViewShareView alloc] initWithFrame:CGRectMake(0, ScreenHeight-110, ScreenWidth, 110)];
    shareView.delegate =  self;
    [self.view addSubview:shareView];
}


- (void)shareType:(EVLiveShareButtonType)type
{
    
    ShareType shareType = ShareTypeMineTextLive;
    
    [UIImage gp_imageWithURlString:[EVLoginInfo localObject].logourl comoleteOrLoadFromCache:^(UIImage *image, BOOL loadFromLocal) {
        [[EVShareManager shareInstance] shareContentWithPlatform:type shareType:shareType titleReplace:_name descriptionReplaceName:@"" descriptionReplaceId:nil URLString:nil image:image outImage:self.cutImage];
    }];
}

- (void)backClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
