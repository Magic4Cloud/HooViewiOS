//
//  EVCommentCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVComment, EVCommentCell;

//extern NSString *sysMsgTitle;

#define DefaultCommentLabelMarinV 0
#define DefaultCommentLabelMarginH 0
#define CCCommentCellBackgroundColor [UIColor colorWithHexString:@"#FFFFFF" alpha:0.9]
#define CCCommentCellCornerradius 12.5

typedef NS_ENUM(NSInteger, CCCommentClickType)
{
    CCCommentClickTypeComment,
    CCCommentClickTypeNickName,
    CCCommentClickTypeReplyName
};

@protocol CCCommentCellDelegate <NSObject>

@optional
//- (void)commentCell:(EVCommentCell *)cell
//         didClicked:(CCCommentClickType)type;

@end

@interface EVCommentCell : UITableViewCell

@property (nonatomic,weak) id<CCCommentCellDelegate> delegate;

/**
 *  数据模型
 */
@property (nonatomic,strong) EVComment *comment;

+ (NSString *)cellID;

/** 昵称和评论是否可以点击 */
@property (nonatomic, assign) BOOL enable;

@end
