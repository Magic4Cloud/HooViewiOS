//
//  EVThreeImageCell.h
//  elapp
//
//  Created by 唐超 on 4/6/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVLineTableViewCell.h"
/**
 三张图片的cell
 */
@interface EVThreeImageCell : EVLineTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView3;
@property (weak, nonatomic) IBOutlet UILabel *cellDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellViewCountLabel;

@end
