//
//  EVHVLiveViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/8.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVLiveViewController.h"
#import "EVLiveEncode.h"
#import "EVHVPrePareController.h"

@interface EVHVLiveViewController ()<EVVideoCodingDelegate>

@property (nonatomic, strong) EVLiveEncode *liveEncode;

@end

@implementation EVHVLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setInitLiveEncode];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    EVHVPrePareController *prePareVC  = [[EVHVPrePareController alloc] init];
    prePareVC.view.backgroundColor = [UIColor clearColor];
    [self addChildViewController:prePareVC];
    [self.view addSubview:prePareVC.view];
}

- (void)setInitLiveEncode
{
    self.liveEncode = [[EVLiveEncode alloc]init];
    self.liveEncode.delegate = self;
    [self.liveEncode initWithLiveEncodeView:self.view];
    [self.liveEncode enableFaceBeauty:YES];
    
}

////支持旋转
//-(BOOL)shouldAutorotate{
//    return NO;
//}
//
////支持的方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscapeLeft;
//}
//
////一开始的方向  很重要
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationLandscapeLeft;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
