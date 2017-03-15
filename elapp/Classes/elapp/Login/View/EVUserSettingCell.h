//
//  EVUserSettingCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVSystemPublic.h"

@class EVLoginInfo,EVUserTagsView;

#define kNameTitle  kE_GlobalZH(@"nickname_title")
#define kSexTitle  kE_GlobalZH(@"sex_title")
#define kBirthDayTitle  kE_GlobalZH(@"birthDayTitle")
#define kConstellation  kE_GlobalZH(@"constellation")
#define kLocationTitle  kE_GlobalZH(@"location_title")
#define kIntroTitle  kE_GlobalZH(@"signature_title")
#define kHeaderImage kE_GlobalZH(@"user_image")


typedef NS_ENUM(NSInteger, EVKeyBoardType) {
    EVKeyBoardNormal,       //
    EVKeyBoardLocation,     // 选择地理位置
    EVKeyBoardSex           // 选择性别
};

typedef NS_ENUM(NSInteger, EVCellStyleType) {
    EVCellStyleNomal,
    EVCellStyleHeaderImage,
    EVCellStyleSignature,
    EVCellStyleName,
    EVCellStyleTags,
    EVCellStylePreNum
};
typedef void(^ConstellationBlock)(NSString *Contellation);
@interface CCUserSettingItem : NSObject
@property (nonatomic, copy) NSString *settingTitle;         // cell的名称
@property (nonatomic, copy) NSString *contentTitle;         // cell的内容

@property (nonatomic, copy) NSString *placeHolder;          // textField的placeholder

@property (nonatomic,assign) BOOL hiddenLine;               // 隐藏下划线
@property (nonatomic, assign) BOOL access;                  // 是否可编辑

@property (nonatomic,assign) EVKeyBoardType keyBoardType;   // 键盘类型

@property (nonatomic, strong) EVLoginInfo *loginInfo;       // 用户信息

@property (nonatomic, assign) EVCellStyleType cellStyleType;

@property (nonatomic, copy) NSString *logoUrl;

@property (nonatomic, strong) UIImage *logoImage;

@end


@interface EVUserHeaderImageItem: NSString

@end

@interface EVUserSettingCell : UITableViewCell

@property (nonatomic, weak) EVUserTagsView *userTagsView;
@property (nonatomic, strong) CCUserSettingItem *settingItem;   // 个人设置模型
@property (nonatomic, copy) ConstellationBlock constellationB;
- (void)textFiledResignFirstResponse;
- (void)textFieldBecomeFirstResponse;

@end
