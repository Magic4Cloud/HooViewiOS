//
//  EVLiveVideoCollectionViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLiveVideoCollectionViewCell.h"
#import <PureLayout.h>

#define CCLiveVideoCollectionViewCellH 240.0f
#define CCLiveVideoCollectionViewCellID @"CCLiveVideoCollectionViewCellID"

@interface EVLiveVideoCollectionViewCell ()

@property (weak, nonatomic) EVLiveVideoView *liveVideoV;  /**< 直播视频视图 */

@end

@implementation EVLiveVideoCollectionViewCell

#pragma mark - public class methods

+ (CGSize)cellSize
{
    return CGSizeMake(ScreenWidth, CCLiveVideoCollectionViewCellH);
}

+ (NSString *)cellIdentifier
{
    return CCLiveVideoCollectionViewCellID;
}

- (void)setDelegate:(id<CCLiveVideoViewDelegate>)delegate
{
    _delegate = delegate;
    self.liveVideoV.delegate = delegate;
}

#pragma mark - life circle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self addCustomSubviews];
    }
    
    return self;
}
// fix by 马帅伟 删除了drawRect:方法

#pragma mark - private methods

- (void)addCustomSubviews
{
    self.contentView.backgroundColor = CCBackgroundColor;
    [self liveVideoV];
}

- (void)replaceThumbWithLastModel:(EVCircleRecordedModel *)lastModel newModel:(EVCircleRecordedModel *)newModel
{
    [self.liveVideoV replaceThumbWithLastModel:lastModel newModel:newModel];
}

#pragma mark - setters and getters

- (void)setCellItem:(EVCircleRecordedModel *)cellItem
{
    _cellItem = cellItem;
    
    self.liveVideoV.model = cellItem;
}

static UIImage *backImage = nil;
- (UIImage *)backImage
{
    if (!backImage)
    {
        backImage = [[UIImage imageNamed:@"home_card_back_projection"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    }
    return backImage;
}

- (EVLiveVideoView *)liveVideoV
{
    if (!_liveVideoV)
    {
        UIImageView *backImageView = [[UIImageView alloc] initWithImage:[self backImage]];
        [self.contentView addSubview:backImageView];
        [backImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        EVLiveVideoView *liveVideoV = [[EVLiveVideoView alloc] init];
        [self.contentView addSubview:liveVideoV];
        _liveVideoV = liveVideoV;
        [liveVideoV autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [liveVideoV autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    }
    return _liveVideoV;
}

@end
