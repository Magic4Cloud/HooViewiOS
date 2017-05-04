//
//  EVJoinChatCell.h
//  elapp
//
//  Created by 唐超 on 5/4/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVEaseMessageModel;
/**
 某某加入聊天室 cell
 */
@interface EVJoinChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (nonatomic, strong)EVEaseMessageModel * messageModel;
@end
