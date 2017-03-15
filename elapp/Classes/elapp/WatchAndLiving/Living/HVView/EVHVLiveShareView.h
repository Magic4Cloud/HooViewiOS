//
//  EVHVLiveShareView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/14.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EVEnums;
typedef void(^liveShareTypeBlock)(EVLiveShareButtonType type);

@interface EVHVLiveShareView : UIView

@property (nonatomic, copy) liveShareTypeBlock shareTypeBlock;
@end
