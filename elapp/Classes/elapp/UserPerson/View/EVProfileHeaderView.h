//
//  EVProfileHeaderView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVSystemPublic.h"
#define CCProfileControlTitleVideo  kE_GlobalZH(@"living_video")
#define CCProfileControlTitleAudio  kE_GlobalZH(@"living_audio")
#define CCProfileControlTitleFans   kE_GlobalZH(@"e_fans")
#define CCProfileControlTitleFocus kNavigatioBarFollow

extern CGFloat const EVProfileHeaderViewRoomHeight;     /**< 房间+房间上方padding总高度 */

typedef enum : NSUInteger {
    EVProfileHeaderViewStyleMine,
    EVProfileHeaderViewStyleOtherPerson
} EVProfileHeaderViewStyle;

@class EVProfileControl;
@class EVHeaderButton;
@class CCProfileHeaderView;

@protocol EVProfileDelegate <NSObject>

@optional

/**
 *  @author 杨尚彬
 *
 *  点击底部四个按钮的代理方法
 *
 *  @param control 点击的control
 */
- (void)clickProfileControl:(EVProfileControl *)control;

/**
 *  @author 杨尚彬
 *
 *  点击头像的代理方法
 *
 *  @param button 头像按钮
 */
- (void)clickHeaderButton:(EVHeaderButton *)button image:(UIImage *)image;

- (void)clickEditDataButton:(UIButton *)remarkButton;


@end
@class EVUserModel;

@interface EVProfileHeaderView : UICollectionReusableView

@property (strong, nonatomic) EVUserModel *userModel;
@property ( weak, nonatomic ) id<EVProfileDelegate> delegate;
@property (assign, nonatomic) EVProfileHeaderViewStyle style;
@property (assign, nonatomic) CGFloat expectedHeight;
@property (assign, nonatomic) BOOL otherContreIsLiving;     /**< 他人中心，显示正在直播  >>  add by 刘传瑞 */

- (void)hiddenEditMarkButton:(BOOL)YorN;
@end
