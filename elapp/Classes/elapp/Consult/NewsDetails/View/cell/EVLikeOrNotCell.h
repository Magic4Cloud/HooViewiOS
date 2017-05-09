//
//  EVLikeOrNotCell.h
//  elapp
//
//  Created by 周恒 on 2017/5/9.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVLikeOrNotCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIButton *notLikeButton;

@property (weak, nonatomic) IBOutlet UIImageView *likeImage;

@property (weak, nonatomic) IBOutlet UILabel *numberOfLike;













@end
