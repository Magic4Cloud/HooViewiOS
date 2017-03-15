//
//  EVUserTagsViewController.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/21.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVViewController.h"


typedef void(^userTagsListBlock)(NSMutableArray *tagArray);
@interface EVUserTagsViewController : EVViewController

@property (nonatomic, copy) userTagsListBlock userTLBlock;
@end
