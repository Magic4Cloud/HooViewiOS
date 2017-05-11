//
//  EVtextLiveHChatCell.h
//  elapp
//
//  Created by 唐超 on 5/3/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVHVMessageCellModel.h"
#import "EVEaseMessageModel.h"

/**
 图文直播聊天页面
 */
@class EVtextLiveHChatCell,EVHVMessageCellModel;
@protocol EVtextLiveHChatCellDelegate <NSObject>
@optional
- (void)longPressCell:(EVtextLiveHChatCell *)cell easeModel:(EVEaseMessageModel *)easeModel ;

@end


@interface EVtextLiveHChatCell : UITableViewCell
@property (nonatomic, strong) EVHVMessageCellModel *messageCellModel;


@property (nonatomic, strong) EVEaseMessageModel *easeMessageModel;
@property (nonatomic, strong)EVHVMessageCellModel * videoMessageModel;
@property (nonatomic, weak) id<EVtextLiveHChatCellDelegate> delegate;
@end
