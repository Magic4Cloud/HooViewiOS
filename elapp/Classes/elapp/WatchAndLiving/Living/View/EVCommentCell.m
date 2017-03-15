//
//  EVCommentCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVCommentCell.h"
#import <PureLayout.h>
#import "EVComment.h"

//NSString *sysMsgTitle = [NSString stringWithFormat:kE_GlobalZH(@"system_news")];
#define kSpecialKey @"special"
#define kSpecialReplyKey @"specialKey"
#define kDefaultCornerRadius 5

#define EMOJI_LABEL_CLICK_NICK_NAME                 1
#define EMOJI_LABEL_CLICK_REPLY_NICK_NAME           2
#define EMOJI_LABEL_CLICK_COMMENT                   3

#define RedEnvelopWidth 36

@protocol CCEmojiLabelDelegate <NSObject>

@optional
- (void)emojiLabelDidClicked:(CCCommentClickType)type;

@end

@interface CCCommentLabel : UILabel

@property (nonatomic,assign) CGRect usernicknameFrame;
@property (nonatomic,assign) CGRect replynickFrame;
@property (nonatomic,weak) EVComment *comment;

@property (nonatomic,weak) id<CCEmojiLabelDelegate> delegate;

@end

@implementation CCCommentLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGRect nickNameFrame = CGRectMake(self.comment.textOrigin, 0, self.comment.prefixNameAttributeString.size.width + self.comment.textOrigin, self.comment.prefixNameAttributeString.size.height + 5);
    
    NSLog(@"_comment  name  %ld    %@",[_comment.name integerValue],_comment);
    if ( _comment == nil || ![_delegate respondsToSelector:@selector(emojiLabelDidClicked:)] )
    {
        return;
    }
    // 触摸对象
    UITouch *touch = [touches anyObject];
    // 触摸点x
    CGPoint point = [touch locationInView:self];
    NSInteger clickType = CCCommentClickTypeComment;
    if ( CGRectContainsPoint(nickNameFrame, point) )
    {
        clickType = CCCommentClickTypeNickName;
    }
    else
    {
    }
    
    [_delegate emojiLabelDidClicked:clickType];
}

@end

@interface EVCommentCell () <CCEmojiLabelDelegate>

@property (nonatomic,weak) CCCommentLabel *commentLabel;

/** 评论label距右边的距离 */
@property (nonatomic, strong) NSLayoutConstraint *commentLabelRightConstraint;

/** 红包图片 */
@property (nonatomic, weak) UIImageView *redEvelopImageView;

/** 红包宽度约束 */
@property (nonatomic, weak) NSLayoutConstraint *redEvelopeWConstraint;

/** 外面的白框 */
@property (nonatomic, weak) UIView *containerView;



@end

@implementation EVCommentCell

static NSString *cellID = @"commentcell";
- (void)dealloc
{
    EVLog(@"CCCommentCell dealloc");
}

+ (NSString *)cellID
{
    return cellID;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.contentView.transform = CGAffineTransformMakeRotation(M_PI);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // 文字外面的白色框
    UIView *containerView = [[UIView alloc] init];
    [self.contentView addSubview:containerView];
    [containerView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:CCCommentCellTopMargin];
    [containerView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [containerView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0 relation:NSLayoutRelationGreaterThanOrEqual];
    containerView.layer.cornerRadius = CCCommentCellCornerradius;
    _containerView = containerView;
    
    // label
    CCCommentLabel *commentLabel = [[CCCommentLabel alloc] init];
    commentLabel.delegate = self;
    commentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    commentLabel.numberOfLines = 0;
    commentLabel.font = EVBoldFont(16);
    commentLabel.textColor = [UIColor whiteColor];
    [containerView addSubview:commentLabel];
    self.commentLabel = commentLabel;
    [commentLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [commentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    _commentLabelRightConstraint = [commentLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:DefaultCommentLabelMarginH];
    
    if ( IOS8_OR_LATER )
    {
        [containerView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [commentLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    }
    else
    {
        [containerView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:DefaultCommentLabelMarinV];
        [commentLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:containerView withOffset:DefaultCommentLabelMarinV];
    }
    
    // 红包图片
    UIImageView *redEvelopeImageView = [[UIImageView alloc] init];
    redEvelopeImageView.image = [UIImage imageNamed:@"money"];
    [containerView addSubview:redEvelopeImageView];
    [redEvelopeImageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [redEvelopeImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    _redEvelopeWConstraint = [redEvelopeImageView autoSetDimension:ALDimensionWidth toSize:RedEnvelopWidth];
    [redEvelopeImageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:commentLabel];
    redEvelopeImageView.hidden = YES;
    _redEvelopImageView = redEvelopeImageView;

    _enable = YES;
}

- (void)reductView
{
    self.commentLabel.comment = _comment;
    self.redEvelopeWConstraint.constant = 0;
    self.redEvelopImageView.hidden = YES;
    self.commentLabelRightConstraint.constant = -DefaultCommentLabelMarginH;
    self.commentLabel.layer.cornerRadius = 0;
    self.commentLabel.backgroundColor = [UIColor clearColor];
    self.commentLabel.layer.borderColor = [UIColor clearColor].CGColor;
    self.commentLabel.layer.borderWidth = 0;
}

- (void)setComment:(EVComment *)comment
{
    _comment = comment;
    if ( _comment == nil )
    {
        self.commentLabel.attributedText = nil;
        return;
    }
    
    [self reductView];

    self.commentLabel.attributedText = comment.commentAttributeString;
    switch (comment.commentType)
    {
        case CCCommentComment:
            [self normalMessage:comment];
            break;
        case CCCommentPresent:
        case CCCommentEmoji:
            [self presentMessage:comment];
            break;
        case CCCommentFocus:
            [self focusMessage:comment];
            break;
        case CCCommentSysMsg:
            [self systemMessage:comment];
            break;
        case CCCommentRedEnvelop:
            [self redEvelopeSysMsg:comment];
            break;
    }
    if ( !IOS8_OR_LATER )
    {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)normalMessage:(EVComment *)comment
{
}

// 礼物提醒消息
- (void)presentMessage:(EVComment *)comment
{
    
}

// 关注主播消息
- (void)focusMessage:(EVComment *)comment
{
}

// 系统提示消息
- (void)systemMessage:(EVComment *)comment
{
}

// 系统消息提醒红包
- (void)redEvelopeSysMsg:(EVComment *)comment
{
    CGFloat radius = 5;
    self.commentLabel.layer.cornerRadius = radius;
    self.commentLabel.backgroundColor = [UIColor whiteColor];
    self.commentLabel.layer.masksToBounds = YES;
    self.redEvelopImageView.hidden = NO;
    self.commentLabelRightConstraint.constant = -DefaultCommentLabelMarginH - RedEnvelopWidth + radius * 2;
    self.redEvelopeWConstraint.constant = RedEnvelopWidth;
}

#pragma mark - CCEmojiLabelDelegate
- (void)emojiLabelDidClicked:(CCCommentClickType)type
{
//    if ( [_delegate respondsToSelector:@selector(commentCell:didClicked:)] )
//    {
//        [_delegate commentCell:self didClicked:type];
//    }
}

@end
