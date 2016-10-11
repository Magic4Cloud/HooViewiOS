//
//  EVNotFoundCityFooterView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

typedef void(^ClickLabelBlock)();

#import <UIKit/UIKit.h>

@interface EVNotFoundCityFooterView : UITableViewHeaderFooterView

@property (copy, nonatomic) NSString *text;

/**
 *  设置label的点击事件
 *
 *  @param action 点击事件的block
 */
- (void) setClickLabelAction:( ClickLabelBlock )action;

/**
 *  获取CCNotFoundCityFooterView对象
 *
 *  @param tableView cell所在的tableview
 *
 *  @return CCNotFoundCityFooterView对象
 */
+ (instancetype) sectionFooterForTableView:(UITableView *)tableView;

@end
