//
//  EVTextLiveHeaderView.m
//  elapp
//
//  Created by 唐超 on 5/4/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVTextLiveHeaderView.h"
#import "EVWatchVideoInfo.h"
#import "EVUserTagsModel.h"
@implementation EVTextLiveHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView * view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
        view.frame = self.bounds;
        [self addSubview:view];
        _avatarImageView.layer.cornerRadius = 30;
        _avatarImageView.layer.masksToBounds = YES;
        _followButton.layer.cornerRadius = 4;
        _followButton.layer.masksToBounds = YES;
    }
    return self;
}

- (IBAction)followButtonClick:(UIButton *)sender {
    
}

- (void)setInforModel:(EVWatchVideoInfo *)inforModel
{
    if (!inforModel) {
        return;
    }
    _inforModel = inforModel;
    [_avatarImageView cc_setImageWithURLString:inforModel.logourl placeholderImage:[UIImage imageNamed:@"Account_bitmap_user"]];
    
    [self.introduceLabel setText:inforModel.signature];
    [_nameLabel setText:inforModel.nickname];
    
    NSMutableString * tagsText = [NSMutableString string];
    NSString * tagsString;
    for (EVUserTagsModel *model in inforModel.tags) {
        [tagsText appendFormat:@"%@，",model.tagname];
        tagsString = [tagsText substringToIndex:tagsText.length-1];
    }
    _tagsLabel.text = tagsString;
    NSString * fansCount = [NSString stringWithFormat:@"%d",inforModel.fans_count];
    
    _followCountLabel.text = [NSString stringWithFormat:@"%@",[fansCount thousandsSeparatorString]];
}

@end
