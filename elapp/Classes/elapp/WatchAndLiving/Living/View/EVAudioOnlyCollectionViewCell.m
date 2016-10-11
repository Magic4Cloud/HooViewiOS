//
//  EVAudioOnlyCollectionViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

//


#import "EVAudioOnlyCollectionViewCell.h"
#import <PureLayout.h>
#import "EVAudioOnlyCollectionViewCellItem.h"

@interface EVAudioOnlyCollectionViewCell ()

@property (nonatomic,weak) UIImageView *selectedImageView;
@property (nonatomic,weak) UIImageView *imageView;

@end

@implementation EVAudioOnlyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:imageView];
    [imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.imageView = imageView;
    
    UIImageView *selectedImageView = [[UIImageView alloc] init];
    selectedImageView.hidden = YES;
    selectedImageView.image = [UIImage imageNamed:@"live_audio_ready_background_chosen"];
    [self.contentView addSubview:selectedImageView];
    CGFloat margin = 6;
    [selectedImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:margin];
    [selectedImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:margin];
    self.selectedImageView = selectedImageView;
}

- (void)setItem:(EVAudioOnlyCollectionViewCellItem *)item
{
    _item = item;
    self.imageView.image = item.image;
    self.selectedImageView.hidden = !item.selected;
}

+ (NSString *)cellID
{
    return @"EVAudioOnlyCollectionViewCell";
}

@end
