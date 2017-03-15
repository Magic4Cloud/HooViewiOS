//
//  EVHotImageCollectionViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/13.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVWatchVideoInfo.h"
@interface EVHotImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) EVWatchVideoInfo *watchVideoInfo;

@property (nonatomic, strong) EVWatchVideoInfo *liveVideoInfo;

@end
