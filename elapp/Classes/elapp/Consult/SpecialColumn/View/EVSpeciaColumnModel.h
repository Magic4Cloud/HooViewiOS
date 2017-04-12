//
//  EVSpeciaColumnModel.h
//  elapp
//
//  Created by 周恒 on 2017/4/11.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVSpeciaAuthor.h"


@interface EVSpeciaColumnModel : NSObject
@property (nonatomic, strong)  EVSpeciaAuthor *author;

@property (nonatomic, copy)NSString *newsID;
@property (nonatomic, copy)NSString * cover;
@property (nonatomic, copy)NSString * newsid;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * introduce;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat cellWidth;


@end
