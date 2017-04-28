//
//  EVHotListCollectionViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/15.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVWatchVideoInfo.h"


@interface EVHotListCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) EVWatchVideoInfo *watchVideoInfo;

@property (nonatomic, strong) UIImageView *ishotImage;

@end
