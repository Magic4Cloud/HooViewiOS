//
//  EVSharePartView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/3.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVWebViewShareView.h"

/**
 分享
 */
@interface EVSharePartView : UIView

/** 分享模块的容器view*/
@property (nonatomic, strong) UIView *containView;
/** 分享方式:微信 微博等*/
@property (nonatomic, strong) EVWebViewShareView *eVWebViewShareView;
/** 取消按钮*/
@property (nonatomic, strong) UIButton *cancelBtn;
/** 取消按钮点击回调*/
@property (nonatomic, copy) void (^cancelShareBlock)();

@end
