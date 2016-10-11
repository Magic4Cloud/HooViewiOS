//
//  EVCacheTableViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVCacheTableViewCell : UITableViewCell

@property (copy, nonatomic) NSString *titleStr;  /**< 标题 */
@property (copy, nonatomic) NSString *detailTitleStr;  /**< 详情 */
@property (assign, nonatomic) BOOL isCleaning;  /**< 是否正在清除缓存 */

- (void)startAnimating;

@end
