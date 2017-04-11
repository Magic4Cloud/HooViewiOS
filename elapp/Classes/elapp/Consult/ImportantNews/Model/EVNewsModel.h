//
//  EVNewsModel.h
//  elapp
//
//  Created by 唐超 on 4/7/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 首页新闻model
 */
@interface EVNewsModel : NSObject
@property (nonatomic, copy)NSString * newsID;
@property (nonatomic, copy)NSString * type;
@property (nonatomic, copy)NSArray * cover;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * time;
@property (nonatomic, copy)NSString * viewCount;

@property (nonatomic, assign)float  cellHeight;
/* "id": 8189,
 "type": 1,
 "cover": [],
 "title": "商业新力量 迈向新未来",
 "time": "2017-04-05 11:05:49",
 "viewCount": 6428*/
@end
