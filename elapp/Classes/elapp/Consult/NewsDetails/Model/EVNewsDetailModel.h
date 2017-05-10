//
//  EVNewsDetailModel.h
//  elapp
//
//  Created by 唐超 on 5/9/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVNewsModel.h"
@interface EVAuthorModel : NSObject

@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, copy) NSString *bind;//是否绑定 0未绑定
@property (nonatomic, copy) NSString * descriptionStr;
@end

@interface EVStockModel : NSObject

@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * market;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * persent;

@end

@interface EVTagModel : NSObject

@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * name;
@end
/**
 新闻详情model
 */
@interface EVNewsDetailModel : NSObject
/*"data": {
 "id": "新闻ID",
 "author": {
 "id": "作者ID",
 "name": "火眼财经",
 "avatar": "作者头像"
 },
 "time": "2016-12-23 11:07",
 "title": "莫迪回应废钞",
 "subTitle": "子标题",
 "digest": "摘要",
 "source": "新闻来源",
 "cover": "封面图片",
 "stock": [
 {
 "code": "000586",
 "market": "股票市场",
 "name": "汇源通信",
 "persent": "+0.17"
 }
 ],
 "tag": [
 {
 "id": "标签ID",
 "name": "标签名称"
 }
 ],
 "voteCount": 0,
 "viewCount": 0,
 "content": "HTML",
 "commentCount": 0,
 "recommendPerson": {
 "id": "uuid",
 "avatar": "http://rs.hooview.com/img.png",
 "name": "杜斯基",
 "introduction": "杜斯基的个人简介"
 },
 "recommendNews": [
 {
 "id": "新闻ID",
 "cover": "新闻封面",
 "title": "新闻标题",
 "time": "发布时间",
 "viewCount": "阅读数"
 }
 ]
 }
 },
*/
@property (nonatomic, copy) NSString * id;
@property (nonatomic, strong) EVAuthorModel * author;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subTitle;
@property (nonatomic, copy) NSString * digest;
@property (nonatomic, copy) NSString * source;
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, strong) NSArray * stock;//(EVStockModel)
@property (nonatomic, strong) NSArray * tag;//(EVTagModel)
@property (nonatomic, copy) NSString * voteCount;
@property (nonatomic, copy) NSString * viewCount;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * commentCount;
@property (nonatomic, strong) EVAuthorModel * recommendPerson;
@property (nonatomic, strong) NSArray * recommendNews;//(EVNewsModel)
@property (nonatomic, strong) NSArray *posts;//(EVHVVideoCommentModel)

@end

