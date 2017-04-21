//
//  EVShopCheatsCell.h
//  elapp
//
//  Created by 唐超 on 4/19/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVCheatsModel;
/**
 我的购买  秘籍cell
 */
@interface EVShopCheatsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellBeansLabel;

@property (nonatomic, strong) EVCheatsModel * cheatsModel;
@end
