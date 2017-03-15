//
//  EVCommentTableView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

#define kDefaultTableHeight 138

@interface EVCommentTableView : UITableView

- (void)pushCellToPool:(UITableViewCell *)cell;

- (UITableViewCell *)popCellFromPoolWithID:(NSString *)cellID;

@end
