//
//  EVLiveEndBaseView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CCLiveEndBaseViewBUTTONFont 18

@interface EVLiveEndBaseView : UIView


@property (nonatomic, weak) UILabel *audienceCountLabel;
@property (nonatomic, weak) UILabel *riceCountLabel;
@property (nonatomic, weak) UILabel *likeCountLabel;
@property (nonatomic, weak) UILabel *commentCountLabel;
@property (nonatomic, weak) UILabel *tipLabel;
@property (nonatomic, weak) UIView *likeCountLine;
@property (nonatomic, weak) UIView *commentCountLine;

@end
