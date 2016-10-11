//
//  EVOtherPersonVideoTableViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVUserVideoModel;

@interface EVOtherPersonVideoTableViewCell : UITableViewCell

@property (strong, nonatomic) EVUserVideoModel *model;  // 当前cell展示的数据

/**
 *  获取当前cell的可重用标识符
 *
 *  @return 可重用标识符字符串
 */
+(NSString *)cellID;

@end
