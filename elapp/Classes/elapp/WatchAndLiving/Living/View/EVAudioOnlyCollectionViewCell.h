//
//  EVAudioOnlyCollectionViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVAudioOnlyCollectionViewCellItem;

@interface EVAudioOnlyCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) EVAudioOnlyCollectionViewCellItem *item;

+ (NSString *)cellID;

@end
