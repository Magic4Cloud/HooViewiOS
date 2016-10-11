//
//  EVNoDisturbAllTableViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^switcherHandle)(BOOL on);

@interface EVNoDisturbAllTableViewCell : UITableViewCell

@property (copy, nonatomic) switcherHandle switchHandle;
@property (assign, nonatomic) BOOL live; /**< 是否接受直播通知 */

@end
