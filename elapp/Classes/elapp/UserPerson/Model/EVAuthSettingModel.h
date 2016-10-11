//
//  EVAuthSettingModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "CCBaseObject.h"
#import "EVSystemPublic.h"

#define k_focusCellName kE_GlobalZH(@"have_people_follow_me_remind")
#define k_disturbCellName kE_GlobalZH(@"night_free_disturb")
#define k_liveCellName kE_GlobalZH(@"living_message_remind")

typedef enum : NSUInteger {
    EVAuthSettingModelTypeDefault,
    EVAuthSettingModelTypeSwitch,
    EVAuthSettingModelTypeAccount,
    EVAuthSettingModelTypeLogOut,
    EVAuthSettingModelTypeClear
} EVAuthSettingModelType;

@interface EVAuthSettingModel : CCBaseObject

@property (nonatomic, assign) BOOL live;            /**< 直播消息推送总开关，"1"推送，"0"不推送 */
@property (nonatomic, assign) BOOL follow;          /**< 关注消息推送开关，"1"推送，"0"不推送 */
@property (nonatomic, assign) BOOL disturb;         /**< 免打扰开关，"1"开启，"0"关闭 */
@property (assign, nonatomic) BOOL personalMsgOpen; /**< 私信推送开关 */

@property (nonatomic, copy) NSString *name;         /**< 行名 */
@property (nonatomic, assign) NSInteger isOn;       /**< 是否打开：1 或者 0 表示switch 2表示indicator，这个属性用来区分不同的cell */

@property (nonatomic, assign) BOOL wrong;           /**< 请求错误 */

@property (assign, nonatomic) EVAuthSettingModelType type;

@property (copy, nonatomic) NSString *midText;      /**< 中间文本 */

@property (copy, nonatomic) NSString *rightText;




- (void)updateDataWithDictionary:(NSDictionary *)dict;

+ (instancetype) modelWithName:(NSString *)name type:(EVAuthSettingModelType)type;

@end
