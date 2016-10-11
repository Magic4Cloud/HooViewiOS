//
//  EVChatMessageContentButton.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVChatMessageContentButton : UIButton

//bubble imgae
@property (nonatomic, strong) UIImageView *backImageView;

//audio
@property (nonatomic, strong) UIView *voiceBackView;
@property (nonatomic, strong) UILabel *second;
@property (nonatomic, strong) UIImageView *voice;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, assign) BOOL isMyMessage;

- (void)benginLoadVoice;

- (void)didLoadVoice;

-(void)stopPlay;

@end
