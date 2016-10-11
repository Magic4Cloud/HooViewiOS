//
//  EVSegmentView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol EVSegmentDelegate <NSObject>

- (void)segmentButtonTag:(NSInteger)btnTag;

@end

@interface EVSegmentView : UIView

- (instancetype)initWithFrame:(CGRect)frame segmentArrat:(NSArray *)segmentArray;
@property (nonatomic, weak) id<EVSegmentDelegate> delegate;

@end
