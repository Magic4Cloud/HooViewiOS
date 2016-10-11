//
//  EVAudienceCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVAudience;

#define kCollectionViewItemSize 35

@interface EVAudienceCell : UICollectionViewCell
/** 数据模型 */
@property (nonatomic,strong) EVAudience *audience;
/** cell 重用 id */
+ (NSString *)audienceCellID;

@end
