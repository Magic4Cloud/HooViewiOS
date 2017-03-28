//
//  EVStartPageViewController.h
//  elapp
//
//  Created by 唐超 on 3/27/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 启动页
 */
@interface EVStartPageViewController : UIViewController
@property (nonatomic, copy)void(^dismissSelfBlock)();
@end
