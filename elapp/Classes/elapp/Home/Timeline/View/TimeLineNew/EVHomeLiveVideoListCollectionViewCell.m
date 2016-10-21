//
//  EVHomeLiveVideoListCollectionViewCell.m
//  elapp
//
//  Created by Ananwu on 2016/10/21.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#define VideoHeightRote 351.f / 375.f


#import "EVHomeLiveVideoListCollectionViewCell.h"
#import "EVCircleRecordedModel.h"
#import "NSString+Extension.h"

@implementation EVHomeLiveVideoListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (CGSize)cellSize
{
    return CGSizeMake(ScreenWidth, ScreenWidth * VideoHeightRote + 60);
}

#pragma mark - getters and setters

- (void)setModel:(EVCircleRecordedModel *)model
{
    _model = model;
    if ( ![NSString isBlankString:_model.logo_thumb]  )
    {
        _model.thumb = [_model.logo_thumb mutableCopy];
    }
}

- (void)setAvatarClick:(void (^)(EVCircleRecordedModel *))avatarClick
{
    _avatarClick = [avatarClick copy];
}


@end
