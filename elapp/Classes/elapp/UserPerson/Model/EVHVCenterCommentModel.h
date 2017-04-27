//
//  EVHVCenterCommentModel.h
//  elapp
//
//  Created by 周恒 on 2017/4/24.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVUserModel.h"
#import "EVCommentTopicModel.h"

/**
 个人主页（普）评论列表
 */
@interface EVHVCenterCommentModel : NSObject

@property (nonatomic, copy) NSString * id; //评论Id
@property (nonatomic, copy) NSString * time; //发布时间
@property (nonatomic, copy) NSString * heats; //热度（点赞数）
@property (nonatomic, copy) NSString * content; //内容
@property (nonatomic, copy) NSString *like; //是否点赞

@property (nonatomic, strong) EVUserModel *user;

@property (nonatomic, strong) EVCommentTopicModel *topic;


@end
