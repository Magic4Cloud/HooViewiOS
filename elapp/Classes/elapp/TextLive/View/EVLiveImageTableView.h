//
//  EVLiveImageTableView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/13.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HyphenateLite_CN/EMSDK.h>
#import "EVEaseMessageModel.h"
#import "EVWatchVideoInfo.h"


typedef void(^scrollViewBlock)(UIScrollView *scrollView);

@interface EVLiveImageTableView : UITableView

@property (nonatomic, strong) EMMessageBody *messageBody;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray*tpDataArray;

@property (nonatomic, strong) EVWatchVideoInfo *liveWatchVideo;

@property (nonatomic, copy) scrollViewBlock scrollVBlock;
- (void)updateMessageModel:(EVEaseMessageModel *)easeModel;
- (void)updateTpMessageModel:(EVEaseMessageModel *)easeModel;
- (void)updateStateModel:(EMMessage *)message;
- (void)updateWatchCount:(NSInteger)count;

- (void)updateHistoryArray:(NSMutableArray *)array;


@end
