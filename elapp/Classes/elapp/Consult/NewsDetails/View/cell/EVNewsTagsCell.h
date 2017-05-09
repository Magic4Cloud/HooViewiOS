//
//  EVNewsTagsCell.h
//  elapp
//
//  Created by 唐超 on 5/9/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTagView.h"

/**
 新闻详情标签cell
 */
@interface EVNewsTagsCell : UITableViewCell
@property (nonatomic, strong) SKTagView * cellTagView;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) NSArray * tagsModelArray;
@end
