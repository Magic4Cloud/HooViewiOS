//
//  EVBaseNewsModel.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/13.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVBaseObject.h"

@interface EVBaseNewsModel : EVBaseObject

@property (nonatomic, copy) NSString *newsID;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *viewCount;

@end
