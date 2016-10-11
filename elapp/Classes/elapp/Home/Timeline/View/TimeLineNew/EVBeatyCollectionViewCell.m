//
//  EVBeatyCollectionViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVBeatyCollectionViewCell.h"
#import <PureLayout.h>
#import "EVCircleRecordedModel.h"
#import "EVBeautyView.h"

#define CCBeatyCollectionViewCellHeaderH 60.0f
#define CCBeatyCollectionViewCellTailH 40.0f
#define kMarginLeft 10.0f
#define CCBeatyCollectionViewCellH (CCBeatyCollectionViewCellHeaderH + CCBeatyCollectionViewCellTailH + ScreenWidth + kMarginLeft)
#define CCBeatyCollectionViewCellW ScreenWidth
#define CCBeatyCollectionViewCellID @"CCBeatyCollectionViewCellID"

@interface EVBeatyCollectionViewCell ()

@property (weak, nonatomic) EVBeautyView *beautyView;  /**< 美颜视图 */

@end

@implementation EVBeatyCollectionViewCell

#pragma mark - public class methods

+ (CGSize)cellSize
{
    return CGSizeMake(CCBeatyCollectionViewCellW, CCBeatyCollectionViewCellH);
}

+ (NSString *)cellIdentifier
{
    return CCBeatyCollectionViewCellID;
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

#pragma mark - private methods
- (void)addCustomSubviews
{
    self.contentView.backgroundColor = [UIColor evBackgroundColor];
    
    EVBeautyView *beautyView = [[EVBeautyView alloc] init];
    [self.contentView addSubview:beautyView];
    self.beautyView = beautyView;
    [beautyView autoPinEdgesToSuperviewEdges];
}


#pragma mark - getters and setters

- (void)setModel:(EVCircleRecordedModel *)model
{
    _model = model;
    
    self.beautyView.model = model;
}

- (void)setAvatarClick:(void (^)(EVCircleRecordedModel *))avatarClick
{
    _avatarClick = [avatarClick copy];
    self.beautyView.avatarClick = self.avatarClick;
}

@end
