//
//  EVNewsAuthorsCell.h
//  elapp
//
//  Created by 周恒 on 2017/5/9.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVNewsAuthorsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *authorImage;
@property (weak, nonatomic) IBOutlet UILabel *authorName;

@property (weak, nonatomic) IBOutlet UILabel *authorIntroduce;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeading;

@property (weak, nonatomic) IBOutlet UIView *authorBackView;

@end
