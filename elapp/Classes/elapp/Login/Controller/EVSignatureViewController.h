//
//  EVSignatureViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVViewController.h"

typedef void(^commitText)(NSString *text);                  // 提交个性签名

@interface EVSignatureViewController : EVViewController

@property (copy, nonatomic) NSString *text;                 // 个性签名

@property (copy, nonatomic) commitText commitBlock;         // 提交

@end
