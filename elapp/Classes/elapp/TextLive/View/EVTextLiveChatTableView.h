//
//  EVTextLiveChatTableView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/23.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVEaseMessageModel.h"

@protocol EVTextLiveTableViewDelegate <NSObject>

- (void)longPressModel:(EVEaseMessageModel *)model;

- (void)tableViewDidScroll:(UIScrollView *)scrollView;

@end


@interface EVTextLiveChatTableView : UITableView

- (void)updateMessageModel:(EVEaseMessageModel *)model;

- (void)updateWatchCount:(NSInteger)count;


@property (nonatomic, weak) id<EVTextLiveTableViewDelegate> tDelegate;

- (void)updateHistoryArray:(NSMutableArray *)array;

@end
