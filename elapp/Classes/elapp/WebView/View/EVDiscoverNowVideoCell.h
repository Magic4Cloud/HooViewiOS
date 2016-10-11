//
//  EVDiscoverNowVideoCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVNowVideoItem;

#define CCDiscoverNowVideoCellTopMargin 10

typedef enum : NSUInteger {
    CCDiscoverNowVideoCell_NOW,
    CCDiscoverNowVideoCell_SEARCH,
} CCDiscoverNowVideoCellTYPE;

@protocol CCDiscoverNowVideoCellDelegate <NSObject>

@optional
- (void)discoverCellDidClickHeaderIcon:(EVNowVideoItem *)item;

@end

@interface EVDiscoverNowVideoCell : UITableViewCell

@property (nonatomic,weak) id<CCDiscoverNowVideoCellDelegate> delegate;

@property (nonatomic,assign) BOOL isFirstCell;
@property (nonatomic,strong) EVNowVideoItem *videoItem;
@property (assign, nonatomic) CCDiscoverNowVideoCellTYPE type; /**< 因为是共用的cell，需要判断，在发现的现在页面使用，还是在搜索页面使用。如果现在页面，底部有一条灰色带；如果在搜索页面，则灰色条带在底部 */

- (void)updateDataWithAnimation:(EVNowVideoItem *)videoItem;

+ (NSString *)cellID;

@end
