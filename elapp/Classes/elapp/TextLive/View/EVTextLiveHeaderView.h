//
//  EVTextLiveHeaderView.h
//  elapp
//
//  Created by 唐超 on 5/4/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVWatchVideoInfo;
/**
 图文直播大v头部视图
 */
@interface EVTextLiveHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (nonatomic, strong) EVWatchVideoInfo * inforModel;
@end
