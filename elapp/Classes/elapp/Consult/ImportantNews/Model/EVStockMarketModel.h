//
//  EVStockMarketModel.h
//  elapp
//
//  Created by 唐超 on 4/10/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 股市大盘model
 */
@interface EVStockMarketModel : NSObject
@property (nonatomic, copy)NSString * name;
@property (nonatomic, copy)NSString * changepercent;
@property (nonatomic, copy)NSString * close;
@property (nonatomic, copy)NSString * open;
@property (nonatomic, copy)NSString * symbol;
@end
