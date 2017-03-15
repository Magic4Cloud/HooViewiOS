//
//  EVChatViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVHVMessageCellModel.h"
#import "EVEaseMessageModel.h"


@class EVChatViewCell;
@protocol EVChatViewCellDelegate <NSObject>

- (void)longPressCell:(EVChatViewCell *)cell easeModel:(EVEaseMessageModel *)easeModel ;

@end


@interface EVChatViewCell : UITableViewCell

@property (nonatomic, strong) EVHVMessageCellModel *messageCellModel;


@property (nonatomic, strong) EVEaseMessageModel *easeMessageModel;

@property (nonatomic, weak) id<EVChatViewCellDelegate> delegate;

@end
