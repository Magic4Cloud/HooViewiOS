//
//  EVFriendCircleRanklistCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EVFriendCircleRanklistModel.h"

@interface EVFriendCircleRanklistCell : UITableViewCell

@property (nonatomic, strong) CCFriendCircleRanklistSendModel *sendModel;
@property (nonatomic, strong) CCFriendCircleRanklistReceiveModel *receiveModel;

@property (nonatomic, strong) UIImageView *ranklistImg;
@property (nonatomic, strong) UILabel *ranklistLabel;
@property (nonatomic, strong) UILabel *dividingLine;
@end
