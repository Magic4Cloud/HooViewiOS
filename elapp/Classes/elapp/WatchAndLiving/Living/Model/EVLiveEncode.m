//
//  EVLiveEncode.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVLiveEncode.h"
#import "EVStreamer.h"
#import "EVControllerContacter.h"
#import "EVBaseToolManager+EVLiveAPI.h"


#define CCEnterForeGround        @"CCEnterForeGround"
#define CCEnterBackGround        @"CCEnterBackGround"

#define CCMuteButton             @"MuteButton"

@interface EVLiveEncode ()<EVStreamerDelegate,CCControllerContacterProtocol>
@property (nonatomic, strong) EVStreamer  *recorder;


@property (nonatomic, strong) EVControllerContacter *contacter;

@property (nonatomic, strong) EVControllerItem *controllerItem;

@property (nonatomic, strong) UIView *videoView;

@property (nonatomic, copy) NSString *live_url;

@property (nonatomic,strong) EVBaseToolManager *engine;//请求
@end

@implementation EVLiveEncode

- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didEnterForeground)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [self initContacterListener];
        
    }
    return self;
}

- (void)setWatermakLogoInfo:(NSDictionary *)watermakLogoInfo
{
    _watermakLogoInfo = watermakLogoInfo;
//    self.recorder.watermakLogoInfo = watermakLogoInfo;
}


- (void)EVStreamerRecordAudioBufferList:(AudioBufferList *)audioBufferList
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(EVRecordAudioBufferList:)]) {
        [self.delegate EVRecordAudioBufferList:audioBufferList];
    }
}

#pragma mark - CCRecoderDelegate
- (void)EVStreamerUpdateState:(EVStreamerState)state
                        error:(NSError *)error
{
    switch ( state )
    {
        case EVStreamerStateAudioInitalError:
        case EVStreamerStateVideoInitialError:
        case EVStreamerStateSessionWarning:
        case EVStreamerStateEncoderError:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(codingStateChanged:)]) {
                [self.delegate codingStateChanged:EVEncodedStateEncoderError];
            }
        }
            break;
            
        case EVStreamerStateConnecting:
        {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(codingStateChanged:)]) {
                [self.delegate codingStateChanged:EVEncodedStateConnecting];
            }
        }
            break;
        case EVStreamerStateStreamReady:
        case EVStreamerStateConnected:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(codingStateChanged:)]) {
                [self.delegate codingStateChanged:EVEncodedStateConnected];
            }
        }
            break;
            
        case EVStreamerStateReconnecting:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(codingStateChanged:)]) {
                [self.delegate codingStateChanged:EVEncodedStateReconnecting];
            }
        }
            break;
            
        case EVStreamerStateStreamOptimizeComplete:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(codingStateChanged:)]) {
                [self.delegate codingStateChanged:EVEncodedStateStreamOptimizComplete];
            }
        }
            break;
            
        case EVStreamerStateStreamOptimizing:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(codingStateChanged:)]) {
                [self.delegate codingStateChanged:EVEncodedStateStreamOptimizing];
            }
        }
            break;
        case EVStreamerStateInitNetWorkError:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(codingStateChanged:)]) {
                [self.delegate codingStateChanged:EVEncodedStateInitNetworkErreor];
            }
            
        }
            break;
        case EVStreamerStateNoNetwork:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(codingStateChanged:)]) {
                [self.delegate codingStateChanged:EVEncodedStateNoNetWork];
            }
        }
            break;
            
        case EVStreamerStatePhoneCallComeIn:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(codingStateChanged:)]) {
                [self.delegate codingStateChanged:EVEncodedStatePhoneCallComeIn];
            }
        }
            break;
            
        case EVStreamerStateLivingIsInterruptedByPhone:
        case EVStreamerStateLivingIsInterruptedByOther:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(codingStateChanged:)]) {
                [self.delegate codingStateChanged:EVEncodedStateLivingIsInterruptedByOther];
            }
        }
            break;
            
        case EVStreamerStateNetworkUnsuitForStreaming_lv1:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(codingStateChanged:)]) {
                [self.delegate codingStateChanged:EVEncodedStateNetWorkStateUnSuitForStreaming_lv1];
            }
        }
            break;
            
        case EVStreamerStateNetworkUnsuitForStreaming_lv2:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(codingStateChanged:)]) {
                [self.delegate codingStateChanged:EVEncodedStateNetWorkStateUnSuitForStreaming_lv2];
            }
        }
            break;
            
        default:
            break;
    }
    
}
- (void)getCapture:(void(^)(UIImage *image))imageBlock
{
    [self.recorder getCapture:imageBlock];
}

- (void)setFocusFloat:(CGPoint)focusFloat
{
    _focusFloat = focusFloat;
    __weak typeof(self) wself = self;
    [_recorder cameraWithLocation:self.focusFloat fail:^(NSError *focusError) {
        if (wself.delegate && [wself.delegate respondsToSelector:@selector(cameraFocusFail:)]) {
            [wself.delegate cameraFocusFail:kE_GlobalZH(@"focus_fail")];
        }
    }];
}

- (void)switchCamera:(BOOL)front
            complete:(void(^)(BOOL success , NSError *error))complete
{
    [self.recorder switchCamera:front complete:complete];
}


//方法
- (void)cameraZoomWithFactor:(CGFloat)zoomFactor
                        fail:(void(^)(NSError *error))failBlock
{
    [_recorder cameraZoomWithFactor:zoomFactor fail:failBlock];
}

- (void)didEnterForeground
{
    [self.contacter boardCastEvent:CCEnterForeGround withParams:nil];
}

- (void)didEnterBackground
{
    
    [self.contacter boardCastEvent:CCEnterBackGround withParams:nil];
}

- (void)initContacterListener
{
    [self.controllerItem.events addObjectsFromArray:@[ CCEnterBackGround, CCEnterForeGround]];
    [self.contacter addListener:self.controllerItem];
}

- (void)setIsMute:(BOOL)isMute
{
    _isMute = isMute;
    [_recorder setMute:_isMute];
}

#pragma CCControllerContacterProtocol
- (void)receiveEvents:(NSString *)event withParams:(NSDictionary *)params
{
    if ( [event isEqualToString:CCEnterBackGround] )
    {
        [self enterBackground];
        
    }
    else if ( [event isEqualToString:CCEnterForeGround] )
    {
        [self enterForeground];
    }
}

- (void)enterBackground
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(enterBackground)]) {
        [self.delegate enterBackground];
    }
//    if (self.startLiving == NO) {
//        
//        return;
//    }
    [self.recorder pause];
}

- (void)enterForeground
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(enterForeground)]) {
        [self.delegate enterForeground];
    }
//    if (self.startLiving == NO) {
//        return;
//    }else{
         self.startLiving = YES;
         [self.recorder resume];
//    }
}


- (void)initWithLiveEncodeView:(UIView *)view
{
    self.recorder = [[EVStreamer alloc] init];
    _recorder.delegate = self;
    self.recorder.presentView = view;
    self.videoView = view;
    [self.recorder livePrepareComplete:^(EVStreamerResponseCode responseCode, NSDictionary *result, NSError *err) {
        NSLog(@"prepare--- %ld -------- %@ -------  %@",responseCode,result,err);
    }];
}


- (void)upDateLiveUrl:(NSString *)url
{
    self.recorder.URI = url;
    self.live_url = url;
}

- (void)enableFaceBeauty:(BOOL)enabled
{
    [self.recorder enableFaceBeauty:enabled];
}

- (void)startEncoding
{
    [self.recorder liveStartComplete:^(EVStreamerResponseCode responseCode, NSDictionary *result, NSError *err) {
        NSLog(@"livestart--- %ld -------- %@ -------  %@",responseCode,result,err);
        if (responseCode == EVStreamerResponse_Okay) {
            [self.recorder start];
        }
    }];
}

- (void)shutDownEncoding
{
    // 关闭编码
    [_recorder shutDown];
    _recorder = nil;
}


// 停止上报数据 ＋ 停止推流
- (void)shutDwonStream
{
    [_recorder shutDown];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.engine cancelAllOperation];
}
- (EVControllerContacter *)contacter
{
    if ( _contacter == nil )
    {
        _contacter = [[EVControllerContacter alloc] init];
    }
    return _contacter;
}

- (EVControllerItem *)controllerItem
{
    if ( _controllerItem == nil )
    {
        _controllerItem = [[EVControllerItem alloc] init];
        _controllerItem.delegate = self;
    }
    return _controllerItem;
}

- (EVBaseToolManager *)engine
{
    if ( _engine == nil )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}
@end
