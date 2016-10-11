//
//  EVMessageItemFrame.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EVMessageItem;

#define MESSAGE_TIME_MARGIN_TOP                     17
#define MESSAGE_MESSAGE_CONTENT_MARGIN_TIME         23
#define MESSAGE_HEADER_MARGIN_SIDE                  15
#define MESSAGE_HEADER_MARGIN_CONTENT               9
#define MESSAGE_HEADER_WIDTH_HEIGHT                 40

#define MESSAGE_VOICE_MIN_WITDTH                    65
#define MESSAGE_VOICE_IMAGE_WIDTH_HEIGHT            10

#define MESSAGE_IMAGE_WIDTH_HEIGHT                  100

#define MESSAGE_TIME_FONT                           [UIFont systemFontOfSize:10]
#define MESSAGE_MESSAGE_FONT                        [UIFont systemFontOfSize:14]
#define MESSAGE_VOICE_FONT                          [UIFont systemFontOfSize:12]

#define MESSAGE_MAX_CONTENT_WIDTH                   (ScreenWidth * 0.6)
#define MESSAGE_VOICE_DESC(time)                    [NSString stringWithFormat:@"%ld '", (time)]

#define MESSAGE_MAGIN                               14
#define MESSAGE_BODY_LEFT                           -4

#define MESSAGE_INNER_MARGIN_TOP                    28
#define MESSAGE_INNER_MARGIN_BOTTOM                 13
#define MESSAGE_INNER_MARGIN_LEFT                   13
#define MESSAGE_INNER_MARGIN_RIGHT                  28

//#define MESSAGE_INNER_MARGIN_TOP                    14
//#define MESSAGE_INNER_MARGIN_BOTTOM                 14
//#define MESSAGE_INNER_MARGIN_LEFT                   17
//#define MESSAGE_INNER_MARGIN_RIGHT                  17

#define MESSAGE_LOCATION_LABEL_HEIGHT               20

@interface EVMessageItemFrame : NSObject

@property (nonatomic, assign) BOOL timeLabelHidden;
@property (nonatomic, assign) CGRect timeLabelFrame;

@property (nonatomic, assign) CGRect contentFrame;
@property (nonatomic, assign) CGRect bodyContentFrame;

@property (nonatomic, assign) CGRect locationFrame;

@property (nonatomic, assign) CGRect voiceContentFrame;
@property (nonatomic, assign) CGRect voiceImageFrame;
@property (nonatomic, assign) CGRect voiceLabelFrame;

@property (nonatomic, assign) CGRect headerIconFrame;
@property (nonatomic, assign) CGRect redEnveloopeFrame;

- (void)setMessageItem:(EVMessageItem *)item;

@end
