//
//  EVGroupInfoMemberCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVGroupInfoDetailCell.h"

@class EVGroupInfoMemberCell;

@protocol CCGroupInfoMemberCellDelegate <NSObject>

- (void)groupInfoMemberCell: (EVGroupInfoMemberCell *)cell didClickAddButton:(UIButton *)button;
- (void)groupInfoMemberCell: (EVGroupInfoMemberCell *)cell didClickRemoveButton:(UIButton *)button;

@end

@interface EVGroupInfoMemberCell : EVGroupInfoDetailCell

@property ( weak, nonatomic ) id<CCGroupInfoMemberCellDelegate> delegate;


@end
