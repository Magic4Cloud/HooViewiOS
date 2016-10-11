//
//  EVVideoPlayer.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVVideoPlayer.h"
#import "EVPlayer.h"

@interface EVVideoPlayer ()<EVPlayerDelegate>

@property (nonatomic, strong) EVPlayer *evPlayer;

@end

@implementation EVVideoPlayer

#pragma mark - init 
- (id)initWithContentURL:(NSString  *)uri{
    if (self = [super init]) {
        self.evPlayer = [[EVPlayer alloc] init];
        self.evPlayer.URI = uri;
        self.evPlayer.delegate = self;
    }
    return self;
}


- (void)setPresentview:(UIView *)presentview
{
    _presentview = presentview;
     self.evPlayer.playerContainerView = self.presentview;
}


- (void)setVid:(NSString *)vid
{
    _vid = vid;
 
}

#pragma mark - evPlayerDelegate
- (void)    EVPlayer:(EVPlayer *)player
     didChangedState:(EVPlayerState)state
{
    EVPlayerState evState = (EVPlayerState)state;
    if ([self.delegate respondsToSelector:@selector(evVideoPlayer:didChangedState:)]) {
        [self.delegate evVideoPlayer:self didChangedState:evState];
    }
}
- (void)    EVPlayer:(EVPlayer *)player
 updateBufferentCent:(int)percent
            position:(int)position
{

}

#pragma mark - ijk instance method

- (void)againPlay
{
     [self.evPlayer play];
}
- (void)play {
    [self.evPlayer playPrepareComplete:^(EVPlayerResponseCode responseCode, NSDictionary *result, NSError *err) {
        if (responseCode == EVPlayerResponse_Okay) {
            [self.evPlayer play];
        }
    }];
}
- (void)pause {
    [self.evPlayer pause];
}
- (void)shutdown {
    [self.evPlayer shutDown];
    self.evPlayer = nil;
    self.evPlayer.delegate = nil;
}

#pragma mark - ijk class method

#pragma mark - setter
- (void)setDelegate:(id<EVVideoPlayerDelegate>)delegate {
    _delegate = delegate;
    if (delegate == nil) {
        _evPlayer.delegate = nil;
    } else {
        _evPlayer.delegate = self;
    }
}
- (void)setScalingMode:(MPMovieScalingMode)scalingMode {
    _scalingMode = scalingMode;
}
- (void)setCurrentPlaybackTime:(NSTimeInterval)currentPlaybackTime {
    self.evPlayer.currentPlaybackTime = currentPlaybackTime;
}
- (void)setAudioThumbImage:(UIImage *)audioThumbImage {
    _audioThumbImage = audioThumbImage;
}

- (void)dealloc
{
    self.evPlayer = nil;
    self.evPlayer.delegate = nil;
}

#pragma mark - getter
- (UIView *)view {
    return self.evPlayer.playerContainerView;
}
- (NSTimeInterval)duration {
    return self.evPlayer.duration;
}
- (NSTimeInterval)playableDuration {
    return self.evPlayer.playableDuration;
}
- (NSTimeInterval)currentPlaybackTime {
    return self.evPlayer.currentPlaybackTime;
}

@end
