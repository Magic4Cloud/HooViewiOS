//
//  EVChooseNewsModel.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVBaseObject.h"

@interface EVChooseNewsModel : EVBaseObject

@property (nonatomic, copy) NSString *newsID;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, strong) NSArray *stocks;
@end
