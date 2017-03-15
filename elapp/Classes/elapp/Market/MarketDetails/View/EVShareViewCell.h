//
//  EVShareViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/3.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVEnums.h"

typedef NS_ENUM(NSInteger, ShareWay){
    ShareWayQQ = 0,     //分享到QQ
    ShareWayWeiBo,      //分享到微博
    ShareWayFriends,    //分享到朋友圈
    ShareWayWeiChat,    //分享到微信
    ShareWayQZone       //分享到QQ空间
};

@interface EVShareViewCell : UICollectionViewCell

/** 分享方式btn*/
@property (weak, nonatomic) UIButton *shareWayBtn;
/** 分享方式的名字label*/
@property (weak, nonatomic) UILabel *shareWayNameLabel;
/** 点击分享方式的回调*/
@property (nonatomic, copy) void (^shareBtnClickBlock)(UIButton *);

@end
