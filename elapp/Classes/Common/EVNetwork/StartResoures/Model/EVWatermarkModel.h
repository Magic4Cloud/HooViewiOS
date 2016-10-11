//
//  EVWatermarkModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "CCBaseObject.h"

/*
 CGFloat x_pos = 494;
 CGFloat y_pos = 20;
 CGFloat width = 170;
 CGFloat height = 66;
 */

#define kRight_up                               @"rightup"
#define kRight_down                             @"rightdown"
#define kLeft_down                              @"leftdown"
#define kLeft_up                                @"leftup"

#define kWatermarkDefault_X                     552
#define kWatermarkDefault_Y                     110
#define kWatermarkDefault_W                     146
#define kWatermarkDefault_H                     54

#define kWatermarkDefaultRelativeFrame          CGRectMake(0, 0, 720, 1280);

@interface EVWatermarkModel : CCBaseObject

@property (assign, nonatomic) BOOL enable; /**< 水印是否可用 */
@property (assign, nonatomic) CGFloat height; /**< 水印高度 */
@property (assign, nonatomic) CGFloat width; /**< 水印宽度 */
@property (assign, nonatomic) CGFloat x_pos; /**< x 位置 */
@property (assign, nonatomic) CGFloat y_pos; /**< y 位置 */
@property (copy, nonatomic) NSString *region;  /**< 水印方向, eg:rightup(右上) */
@property (copy, nonatomic) NSString *url;  /**< 水印url */
@property (strong, nonatomic) UIImage *watermarkImg; /**< 水印图片 */

@end
