//
//  EVAudienceLoveView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EVVideoTopView.h"

#define CCAudienceLoveViewLoveButtonWH          50
#define CCAudienceLoveViewHeight                300
#define CCAudienceLoveViewWidth                 150
#define MAX_IMAGE_COUNT                         20

@protocol TouchLoveCountDelegate <NSObject>

- (void)touchLoveCount:(NSInteger)count;

@end

@interface EVAudienceLoveView : UIView <CCAudiencceInfoViewDelegate, CCAudiencceInfoViewProtocol>
/** 此处用来显示的 */
@property (nonatomic, assign) NSInteger likeCount;


@property (nonatomic , weak) id <TouchLoveCountDelegate> delegete;

- (void)starAnimation;

- (void)audienceInfoViewUpdate:(CCAudiencceInfoViewProtocolDataType)type
                         count:(NSInteger)count;

- (void)registAnimation;

@end
