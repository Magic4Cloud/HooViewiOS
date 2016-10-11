//
//  EVDiscoverUserCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

@class EVDiscoverUserModel;

typedef void(^FocousButtonAction)(EVDiscoverUserModel *cellItem,UIButton *button);

@interface EVDiscoverUserCell : UITableViewCell

@property ( strong, nonatomic ) EVDiscoverUserModel *cellItem;  // cell要显示的模型对象
@property ( copy, nonatomic ) FocousButtonAction action;        // cell上关注按钮点击事件回调

/**
 *  获取可重用的cell对象
 *
 *  @param tableView cell所在的tableview
 *
 *  @return cell对象
 */
+ (instancetype) cellForTabelView:(UITableView *)tableView;

@end
