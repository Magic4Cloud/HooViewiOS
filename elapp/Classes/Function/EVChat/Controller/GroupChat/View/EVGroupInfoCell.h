//
//  EVGroupInfoCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
@class EVGroupInfoModel;

typedef void(^CCGroupInfoCellActionBlock)(UIView *view);

typedef enum : NSUInteger {
    CCGroupInfoMemberCellStyleMember,
    CCGroupInfoMemberCellStyleOwner,
} CCGroupInfoMemberCellStyle;

@interface EVGroupInfoCell : UITableViewCell

@property (weak,nonatomic) UILabel *titleLabel;
@property ( weak, nonatomic ) UILabel *infoLabel;

@property ( strong, nonatomic ) NSLayoutConstraint *titleLabelHorizontal;
@property (copy, nonatomic) CCGroupInfoCellActionBlock action;

@property ( strong, nonatomic ) EVGroupInfoModel *cellItem;
@property (assign, nonatomic) CCGroupInfoMemberCellStyle memberStyle;


//- (void) setAction:(void (^)(UIView *view))action;

+ ( instancetype )cellForTabelView:(UITableView *)tableView clazz:(NSString *)clazz;

@end
