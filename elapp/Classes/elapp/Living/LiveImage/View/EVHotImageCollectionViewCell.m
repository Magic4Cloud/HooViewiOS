//
//  EVHotImageCollectionViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/13.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHotImageCollectionViewCell.h"
#import "NSString+Extension.h"


@interface EVHotImageCollectionViewCell ()

@property (nonatomic, weak) UIImageView *headImageView;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *watchLabel;

@end

@implementation EVHotImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    UIImageView *headImageView = [[UIImageView alloc] init];
    [self addSubview:headImageView];
    headImageView.layer.cornerRadius = 25;
    headImageView.clipsToBounds = YES;
    self.headImageView = headImageView;
    headImageView.image = [UIImage imageNamed:@"Account_bitmap_user"];
    [headImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [headImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [headImageView autoSetDimensionsToSize:CGSizeMake(50, 50)];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    nameLabel.font = [UIFont textFontB2];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor evTextColorH1];
    [nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:headImageView withOffset:8];
    [nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [nameLabel autoSetDimension:ALDimensionHeight toSize:22];
    
    
    UILabel *watchLabel = [[UILabel alloc] init];
    [self addSubview:watchLabel];
    watchLabel.font = [UIFont textFontB3];
    watchLabel.textColor = [UIColor evTextColorH2];
    self.watchLabel = watchLabel;
    watchLabel.textAlignment = NSTextAlignmentCenter;
    [watchLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:nameLabel];
    [watchLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [watchLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [watchLabel autoSetDimension:ALDimensionHeight toSize:20];
    
}


- (void)setWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo
{
    _watchVideoInfo = watchVideoInfo;
    [self.headImageView cc_setImageWithURLString:watchVideoInfo.logourl placeholderImage:[UIImage imageNamed:@"Account_bitmap_user"]];
}

- (void)setLiveVideoInfo:(EVWatchVideoInfo *)liveVideoInfo
{
    _liveVideoInfo = liveVideoInfo;
 
    self.nameLabel.text = [NSString stringWithFormat:@"%@",liveVideoInfo.name];
    NSString *WatchC = [NSString shortNumber:liveVideoInfo.viewcount];
    self.watchLabel.text = [NSString stringWithFormat:@"%@人参与",WatchC];
}
@end
