//
//  EVCircleLiveVideoTableViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVCircleLiveVideoTableViewCell.h"
#import "EVBeautyView.h"
#import <PureLayout/PureLayout.h>

#define EVBeatyCollectionViewCellHeaderH 60.0f
#define EVBeatyCollectionViewCellTailH 40.0f
#define kMarginLeft 10.0f
#define EVBeatyCollectionViewCellH (EVBeatyCollectionViewCellHeaderH + EVBeatyCollectionViewCellTailH + ScreenWidth + kMarginLeft)
#define EVCircleLiveVideoTableViewCellID @"EVCircleLiveVideoTableViewCellID"

@interface EVCircleLiveVideoTableViewCell ()

@property (weak, nonatomic) EVBeautyView *beautyView;  /**< 美颜视图 */

@end

@implementation EVCircleLiveVideoTableViewCell

#pragma mark - public class methods

+ (CGFloat)cellHeight
{
    return EVBeatyCollectionViewCellH;
}

+ (NSString *)cellIdentifier
{
    return EVCircleLiveVideoTableViewCellID;
}

+ (instancetype) cellForTableView:(UITableView *) tableView
{
    EVCircleLiveVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EVCircleLiveVideoTableViewCellID];
    if ( cell == nil )
    {
        cell = [[EVCircleLiveVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EVCircleLiveVideoTableViewCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


#pragma mark - life circle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self createSubviews];
    }
    return self;
}


#pragma mark - private methods

- (void)createSubviews
{
    self.contentView.backgroundColor = [UIColor evBackgroundColor];
    
    EVBeautyView *beautyView = [[EVBeautyView alloc] init];
    [self.contentView addSubview:beautyView];
    self.beautyView = beautyView;
    [beautyView autoPinEdgesToSuperviewEdges];
    [beautyView autoSetDimension:ALDimensionHeight toSize:EVBeatyCollectionViewCellH];
}


#pragma mark - getters and setters

- (void)setCellItem:(EVCircleRecordedModel *)cellItem
{
    _cellItem = cellItem;
    self.beautyView.model = cellItem;
}

- (void)setAvatarClick:(void (^)(EVCircleRecordedModel *))avatarClick
{
    _avatarClick = [avatarClick copy];
    self.beautyView.avatarClick = self.avatarClick;
}

@end
