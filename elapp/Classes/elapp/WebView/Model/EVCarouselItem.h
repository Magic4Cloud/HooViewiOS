//
//  EVCarouselItem.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "CCEnums.h"
#import "CCBaseObject.h"

@class CCCarouselContent;

typedef NS_ENUM(NSInteger, CCCarouselItemType)
{
    CCCarouselItemUnknow = -1,
    CCCarouselItemForecast = 0,
    CCCarouselItemActivity = 1,
    CCCarouselItemWebType = 2
};

@interface EVCarouselItem : CCBaseObject

/*
 thumb：轮播图片地址
 content: 轮播数据内容，json格式
 */

@property (nonatomic, copy) NSString *thumb;        /**< 轮播图片地址 */

/** 轮播图滚动的位置 */
@property (nonatomic, assign) CGPoint contentOffset;

/** 对应的轮播图片,如果还没下载完返回为空 */
@property (nonatomic,strong) UIImage *image;

/*
 json格式具体如下：
 预告信息：{"type":0,"data":{"notice_id":"11658503"}}
 活动信息：{"type":1,"data":{"activity_id":"11658503"}}
 H5页面信息：{"type":2,"data":{"web_url":"http://12345.html"}}
 */
@property (nonatomic, strong) NSDictionary *content;    /**< 轮播数据内容，json格式 */
@property (nonatomic, strong) NSDictionary *data;       /**< 具体数据内容 */

@property (nonatomic, assign) CCCarouselItemType type;

@property (nonatomic, copy) NSString *noticeID;         /**< 预告ID */
@property (nonatomic, copy) NSString *activetyID;       /**< 活动ID */
@property (nonatomic, copy) NSString *web_url;          /**< h5页面地址 */
@property (nonatomic, copy) NSString *title;            /**< web页面活动标题 */




@end
