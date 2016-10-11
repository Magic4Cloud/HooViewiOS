//
//  EVDiscoverUserCellFooterView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonAction)();

@interface EVDiscoverUserCellFooterView : UITableViewHeaderFooterView

@property (copy, nonatomic) ButtonAction action;


+ (instancetype) sectionFooterForTableView:(UITableView *)tableView;

@end
