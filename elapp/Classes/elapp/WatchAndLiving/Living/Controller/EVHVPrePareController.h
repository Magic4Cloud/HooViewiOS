//
//  EVHVPrePareController.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/7.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVViewController.h"


typedef void(^coverImageBlock)(UIImage *coverImage);

@interface EVHVPrePareController : EVViewController

@property(nonatomic, copy) coverImageBlock coverImage;

@end
