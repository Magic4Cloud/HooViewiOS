//
//  EVConsultGuideView.m
//  elapp
//
//  Created by 周恒 on 2017/3/16.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVConsultGuideView.h"

@interface EVConsultGuideView()
{
    NSString * imageNameSuffix;
}
@end

@implementation EVConsultGuideView



- (IBAction)knowButton:(id)sender {
    if (ScreenWidth == 320) {
        imageNameSuffix = @"5";
    }
    else if(ScreenWidth == 375)
    {
        imageNameSuffix = @"";
    }
    else
    {
        imageNameSuffix = @"plus";
    }
    
    self.backImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"hooview%@",imageNameSuffix]];
    self.knowButton.hidden = YES;
    self.knowButton2.hidden = NO;
}

- (IBAction)knowButton2:(id)sender {
    self.backImage.hidden = YES;
    self.liveBackImage.hidden = NO;
    self.knowButton2.hidden = YES;
    self.knowButton3.hidden = NO;
    if (self._knowBlock) {
        self._knowBlock();
    }
}

- (IBAction)knowButton3:(id)sender {
    self.liveBackImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"imglive%@",imageNameSuffix]];
    self.knowButton3.hidden = YES;
    self.knowButton4.hidden = NO;
}

- (IBAction)knowButton4:(id)sender {
    self.knowButton4.hidden = YES;
    self.liveBackImage.hidden = YES;
    self.marketBackImage.hidden = NO;
    self.knowButton5.hidden = NO;
    if (self._knowBlockLive) {
        self._knowBlockLive();
    }
}

- (IBAction)knowButton5:(id)sender {
    self.knowButton5.hidden = YES;
    if (self._endGuideBlock) {
        self._endGuideBlock();
    }
}



@end
