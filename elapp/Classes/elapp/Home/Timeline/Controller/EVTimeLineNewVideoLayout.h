//
//  EVTimeLineNewVideoLayout.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface EVTimeLineNewVideoLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat margin;   /**< 间距 */
@property (nonatomic, assign) CGFloat headHeight;   /**< 组头高度 */
@property (assign, nonatomic) CGFloat firstSectionItemHeight; /**< 第一组中cell的高度 */
@property (assign, nonatomic) CGFloat secondSectionItemHeight; /**< 第二组中cell的高度 */

@end
