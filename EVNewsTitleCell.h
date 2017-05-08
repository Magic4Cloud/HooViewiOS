//
//  EVNewsTitleCell.h
//  elapp
//
//  Created by 唐超 on 5/8/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 新闻标题cell
 */
@interface EVNewsTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellTimeLabel;

@end
