//
//  EVNickNameAndLevelView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

// 音乐的播放状态
typedef NS_ENUM(NSUInteger, EVLevelModeType) {
   EVLevelModeTypeLine,
    EVLevelModeTypeNmBack,
};
@interface EVNickNameAndLevelView : UIView
/** 昵称，readonly */
@property ( weak, nonatomic, readonly ) UILabel *nickNameLabel;

/** 昵称 */
@property ( nonatomic, copy ) NSString *nickName;

/** 性别 */
@property ( nonatomic, copy ) NSString *gender;



@property (nonatomic, assign) EVLevelModeType levelModeType;

@property ( nonatomic, assign ) BOOL isShowGender;

@end
