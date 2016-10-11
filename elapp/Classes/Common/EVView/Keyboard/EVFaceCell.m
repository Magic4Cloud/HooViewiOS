//
//  EVFaceCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVFaceCell.h"
#import "EVFace.h"
#import <PureLayout.h>

@interface EVFaceCell ()

@property (nonatomic, weak) UIImageView *faceImageView;

@end

@implementation EVFaceCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        UIImageView *faceImageView = [[UIImageView alloc] init];
        faceImageView.clipsToBounds = YES;
        faceImageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:faceImageView];
        [faceImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [faceImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        self.faceImageView = faceImageView;
    }
    return self;
}

- (void)setFace:(EVFace *)face
{
    _face = face;
    self.faceImageView.image = face.faceImage;
}

@end
