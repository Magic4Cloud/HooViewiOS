//
//  EVUserTagsModel.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/26.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVBaseObject.h"

@interface EVUserTagsModel : EVBaseObject

@property (nonatomic, assign) NSInteger tagid;
@property (nonatomic, copy) NSString *tagname;
@property (nonatomic, assign) BOOL tagSelect;

@end
