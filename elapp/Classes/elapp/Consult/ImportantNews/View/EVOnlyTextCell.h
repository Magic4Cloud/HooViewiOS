//
//  EVOnlyTextCell.h
//  elapp
//
//  Created by 唐超 on 4/6/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 纯文字cell
 */
@interface EVOnlyTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellViewCountLabel;

@end
