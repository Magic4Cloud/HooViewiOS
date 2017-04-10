//
//  EVRecommendCell.h
//  elapp
//
//  Created by 唐超 on 4/6/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVRecommendModel;
/**
 牛人推荐cell
 */
@interface EVRecommendCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic,strong)NSMutableArray * recommentArray;
@property (nonatomic, copy)void(^didselectedIndexIWithModelBlock)(EVRecommendModel * model);
@end
