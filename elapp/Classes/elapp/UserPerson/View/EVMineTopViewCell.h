//
//  EVMineTopViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/26.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVMineHeader.h"
#import "EVUserModel.h"
#import "EVLoginInfo.h"

@protocol EVMineTopViewCellDelegate <NSObject>

- (void)didClickButtonType:(UIMineClickButtonType)type;

@end
@class EVUserTagsView;
@interface EVMineTopViewCell : UITableViewCell

@property (nonatomic, weak) id <EVMineTopViewCellDelegate> delegate;

@property (nonatomic, strong) EVUserModel *userModel;

@property (nonatomic, assign) BOOL isSession;

@property (nonatomic, copy) NSString *ecoin;//火眼豆

@property (nonatomic, weak) EVUserTagsView *hvTagLabel;

@end
