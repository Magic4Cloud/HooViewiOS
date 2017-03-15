//
//  EVPersonalCenterViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVViewController.h"
@class EVProfileHeaderView;

@interface EVPersonalCenterViewController : EVViewController

@property ( weak, nonatomic ) UICollectionView * collectionView;
@property ( weak, nonatomic ) UITableView *tableView;
@property ( strong, nonatomic ) EVProfileHeaderView *tableHeaderView;

/**

 *
 *  点击头像变大图
 *
 *  @param lastAvatar 图片
 *
 */
- ( void )biggerAvatar:(UIImage *)lastAvatar;

@end

@interface EVCollectionFlowLayout : UICollectionViewFlowLayout



@end
