//
//  elapp_util.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#ifndef elapp_util_h
#define elapp_util_h

/**
 *  使用说明 ，定义标注图片的宽高
 *  cc_absolute_x( 标注图上 x 方向的尺寸 )
 *  cc_absolute_y( 标注图赏 y 方向的尺寸 )
 */
// 标注图的宽高
//#define CC_ABSOLUTE_IMAGE_W
//#define CC_ABSOLUTE_IMAGE_H


// 当前设备固件版本是否 X.0或以后
#define OS_VERSION_9_LATER  [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0
#define OS_VERSION_8_LATER  [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
#define OS_VERSION_7_LATER  [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define OS_VERSION_6_LATER  [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0


#define cc_absolute_size_x( marksize, cc_absolute_image_w ) ( ScreenWidth * ( marksize ) / ( cc_absolute_image_w ) )
#define cc_absolute_size_y( marksize, cc_absolute_image_h ) ( ScreenHeight * ( marksize ) / ( cc_absolute_image_h ) )

// 使用以下函数必须制定标注图的宽高
#define cc_absolute_x( marksize ) cc_absolute_size_x( marksize, CC_ABSOLUTE_IMAGE_W )
#define cc_absolute_y( marksize ) cc_absolute_size_y( marksize, CC_ABSOLUTE_IMAGE_H )

#endif /* elapp_util_h */
