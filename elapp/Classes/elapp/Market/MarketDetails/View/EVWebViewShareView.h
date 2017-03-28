//
//  EVWebViewShareView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/3.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVEnums.h"

/**
 分享
 */
@protocol EVWebViewShareViewDelegate <NSObject>

- (void)shareType:(EVLiveShareButtonType)type;

@end

@interface EVWebViewShareView : UIView

@property (nonatomic, weak) id<EVWebViewShareViewDelegate> delegate;

@end
