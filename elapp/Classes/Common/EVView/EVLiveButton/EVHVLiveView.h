//
//  EVHVLiveView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/17.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EVLiveButtonType) {
    EVLiveButtonTypeLive,
    EVLiveButtonTypeVideo,
    EVLiveButtonTypePic,
};

typedef void(^liveButtonBlock)(EVLiveButtonType type, UIButton *btn);

@interface EVHVLiveView : UIView

@property (nonatomic, copy) liveButtonBlock buttonBlock;

@end
