//
//  EVHVVideoCommentModel.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/16.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVBaseObject.h"

@interface EVHVVideoCommentModel : EVBaseObject

@property (nonatomic, copy) NSString *commentID;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) NSInteger heats;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_avatar;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSString *vip;

@property (nonatomic, assign) CGFloat cellHeight;

@end
