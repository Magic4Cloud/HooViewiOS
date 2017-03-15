//
//  EVHVPrePareController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/7.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVPrePareController.h"
#import "EVLivePrePareView.h"
#import "EVLiveEncode.h"
#import "UzysImageCropperViewController.h"
#import "EVRecoderInfo.h"
#import "UIViewController+Extension.h"
#import "AppDelegate.h"

typedef NS_ENUM(NSInteger, EVToggleCameraType)
{
    EVToggleCameraPrepare,
    EVToggleCameraLiving
};

#define kCropImageSize                      CGSizeMake(640, 640)

@interface EVHVPrePareController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation EVHVPrePareController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self addCamera];

    // Do any additional setup after loading the view.
    
}

- (void)addCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        //如果没有提示用户
        [EVProgressHUD showError:@"手机上没有摄像头"];
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (self.coverImage) {
        self.coverImage(editImage);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
