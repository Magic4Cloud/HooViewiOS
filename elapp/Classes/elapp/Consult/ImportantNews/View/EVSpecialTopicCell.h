//
//  EVSpecialTopicCell.h
//  elapp
//
//  Created by 唐超 on 4/6/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVNewsModel;
/**
 专题cell 
 */
@interface EVSpecialTopicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellViewCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellBgimageView;
@property (nonatomic, strong)EVNewsModel * speciaModel;
@end
