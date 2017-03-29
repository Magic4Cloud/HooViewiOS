//
//  EVConsultGuideView.h
//  elapp
//
//  Created by 周恒 on 2017/3/16.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^knowBlock)();
typedef void(^knowBlockLive)();
typedef void(^endGuideBlock)();

/**
 新手引导页
 */
@interface EVConsultGuideView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet UIImageView *liveBackImage;
@property (weak, nonatomic) IBOutlet UIImageView *marketBackImage;

@property (weak, nonatomic) IBOutlet UIButton *knowButton;
@property (weak, nonatomic) IBOutlet UIButton *knowButton2;
@property (weak, nonatomic) IBOutlet UIButton *knowButton3;
@property (weak, nonatomic) IBOutlet UIButton *knowButton4;
@property (weak, nonatomic) IBOutlet UIButton *knowButton5;

@property (nonatomic, copy) knowBlock _knowBlock;
@property (nonatomic, copy) knowBlockLive _knowBlockLive;
@property (nonatomic, copy) endGuideBlock _endGuideBlock;




@end
