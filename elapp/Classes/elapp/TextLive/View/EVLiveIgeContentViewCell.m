//
//  EVLiveIgeContentViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/13.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVLiveIgeContentViewCell.h"
#import <HyphenateLite_CN/EMSDK.h>

@interface EVLiveIgeContentViewCell ()


@property (nonatomic, weak) UIView *contentHView;



@property (nonatomic, weak) UIImageView *messageImageView;

@property (nonatomic, strong) NSLayoutConstraint *imageViewWid;

@property (nonatomic, strong) NSLayoutConstraint *imageViewHig;

@property (nonatomic, strong) NSLayoutConstraint *clabelHig;

@property (nonatomic, strong) NSLayoutConstraint *rclabelHig;





@end

@implementation EVLiveIgeContentViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        self.backgroundColor = [UIColor evBackgroundColor];
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    UIImageView *leftCircleIgeView = [[UIImageView alloc] init];
    [self addSubview:leftCircleIgeView];
    self.leftCircleIgeView = leftCircleIgeView;
    leftCircleIgeView.frame = CGRectMake(12, 16, 22,22);
    leftCircleIgeView.layer.cornerRadius = 11;
    leftCircleIgeView.clipsToBounds = YES;
    leftCircleIgeView.backgroundColor = [UIColor clearColor];
    leftCircleIgeView.image = [UIImage imageNamed:@"ic_normal"];
    
    
    
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    self.lineView = lineView;
    [lineView autoAlignAxis:ALAxisVertical toSameAxisOfView:leftCircleIgeView];
    [lineView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:leftCircleIgeView];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [lineView autoSetDimension:ALDimensionWidth toSize:2];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#5f85d0"];
    
    
    UILabel *dateLabel = [[UILabel alloc] init];
    [self addSubview:dateLabel];
    [dateLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:leftCircleIgeView];
    [dateLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:leftCircleIgeView];
    [dateLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:leftCircleIgeView withOffset:10];
    [dateLabel autoSetDimension:ALDimensionWidth toSize:100];
    self.dateLabel = dateLabel;
    dateLabel.font = [UIFont textFontB2];
    dateLabel.textColor = [UIColor evTextColorH2];
    
    
    UIView *contentHView = [[UIView alloc] init];
    [self addSubview:contentHView];
    contentHView.layer.cornerRadius = 4.f;
    contentHView.clipsToBounds = YES;
    contentHView.backgroundColor = [UIColor whiteColor];
    self.contentHView = contentHView;
    [contentHView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:dateLabel];
    [contentHView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:leftCircleIgeView withOffset:10];
    [contentHView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:11];
    [contentHView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    
    UILabel *contentLabel = [[UILabel alloc] init];
    [contentHView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    contentLabel.textColor = [UIColor colorWithHexString:@"#AC4242"];
    contentLabel.font = [UIFont textFontB2];
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [contentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
    [contentLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8];
    self.clabelHig  = [contentLabel autoSetDimension:ALDimensionHeight toSize:0];
    [contentLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
    
    
    UILabel *rpContentLabel = [[UILabel alloc ]init];
    [contentHView addSubview:rpContentLabel];
    self.rpContentLabel = rpContentLabel;
     rpContentLabel.textColor = [UIColor evTextColorH2];
    rpContentLabel.font = [UIFont textFontB2];
    rpContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    rpContentLabel.numberOfLines = 0;
    rpContentLabel.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    [rpContentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
    [rpContentLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
    self.rclabelHig  = [rpContentLabel autoSetDimension:ALDimensionHeight toSize:0];
    [rpContentLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [contentHView addSubview:imageView];
    self.messageImageView = imageView;
    [imageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    self.imageViewWid =    [imageView autoSetDimension:ALDimensionWidth toSize:0];
    self.imageViewHig =    [imageView autoSetDimension:ALDimensionHeight toSize:0];
}

- (void)setEaseMessageModel:(EVEaseMessageModel *)easeMessageModel
{
    _easeMessageModel = easeMessageModel;

    if (easeMessageModel.hType) {
        if ([easeMessageModel.hType isEqualToString:@"txt"]) {
            self.contentLabel.hidden = NO;
            self.messageImageView.hidden = YES;
            _contentLabel.text = [NSString stringWithFormat:@"%@",easeMessageModel.text];
 
        }else if ([easeMessageModel.hType isEqualToString:@"img"]) {
            self.contentLabel.hidden = YES;
            self.messageImageView.hidden = NO;
            UIImage *image = easeMessageModel.thumbnailImage;
            if (image == nil) {
                image = easeMessageModel.image;
            }
            self.messageImageView.image = image;
            self.imageViewHig.constant = easeMessageModel.imageSize.height;
            self.imageViewWid.constant = easeMessageModel.imageSize.width;
        }
        self.rclabelHig.constant = easeMessageModel.rpLhig;
        self.clabelHig.constant = easeMessageModel.titleSize.height;
        self.rpContentLabel.text = easeMessageModel.rpContent;
        self.rpContentLabel.hidden = easeMessageModel.isReply ? NO : YES;
        NSString *time = [NSString stringWithFormat:@"%lld",easeMessageModel.timestamp];
        self.dateLabel.text = [self timeWithTimeIntervalString:time];
        
        if (easeMessageModel.state ==  EVEaseMessageTypeStateHl) {
            self.leftCircleIgeView.image = [UIImage imageNamed:@"ic_highlight"];
            self.lineView.backgroundColor = [UIColor colorWithHexString:@"#FFB31D"];
             self.contentLabel.textColor = [UIColor colorWithHexString:@"#FF772D"];
        }else if (easeMessageModel.state ==  EVEaseMessageTypeStateRp) {
            self.leftCircleIgeView.image = [UIImage imageNamed:@"ic_answer"];
            self.lineView.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
            self.contentLabel.textColor = [UIColor evTextColorH1];
            self.rpContentLabel.textColor = [UIColor evTextColorH2];
        }else {
            
            self.leftCircleIgeView.image = [UIImage imageNamed:@"ic_normal"];
            self.lineView.backgroundColor = [UIColor colorWithHexString:@"#5f85d0"];
            self.contentLabel.textColor = [UIColor colorWithHexString:@"5f85d0"];
            
        }
    }else {
        
        if (easeMessageModel.bodyType == EMMessageBodyTypeText) {
            self.contentLabel.hidden = NO;
            self.messageImageView.hidden = YES;
            _contentLabel.text = [NSString stringWithFormat:@"%@",easeMessageModel.text];
            
        }else if (easeMessageModel.bodyType == EMMessageBodyTypeImage) {
            self.contentLabel.hidden = YES;
            self.messageImageView.hidden = NO;
            UIImage *image = easeMessageModel.thumbnailImage;
            if (image == nil) {
                image = easeMessageModel.image;
            }
            self.messageImageView.image = image;
            self.imageViewHig.constant = easeMessageModel.imageSize.height;
            self.imageViewWid.constant = easeMessageModel.imageSize.width;
        }
        self.rclabelHig.constant = easeMessageModel.rpLhig;
        self.clabelHig.constant = easeMessageModel.titleSize.height;
        self.rpContentLabel.text = easeMessageModel.rpContent;
        self.rpContentLabel.hidden = easeMessageModel.isReply ? NO : YES;
        NSString *time = [NSString stringWithFormat:@"%lld",easeMessageModel.timestamp];
        self.dateLabel.text = [self timeWithTimeIntervalString:time];
        
        if (easeMessageModel.state ==  EVEaseMessageTypeStateHl) {
            self.leftCircleIgeView.image = [UIImage imageNamed:@"ic_highlight"];
            self.lineView.backgroundColor = [UIColor colorWithHexString:@"#FFB31D"];
            self.contentLabel.textColor = [UIColor colorWithHexString:@"#FF772D"];
        }else if (easeMessageModel.state ==  EVEaseMessageTypeStateRp) {
            self.leftCircleIgeView.image = [UIImage imageNamed:@"ic_answer"];
            self.lineView.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
            self.contentLabel.textColor = [UIColor evTextColorH1];
            self.rpContentLabel.textColor = [UIColor evTextColorH2];
        }else {
            self.leftCircleIgeView.image = [UIImage imageNamed:@"ic_normal"];
            self.lineView.backgroundColor = [UIColor colorWithHexString:@"#5f85d0"];
            self.contentLabel.textColor = [UIColor colorWithHexString:@"5f85d0"];
        }
    }
  
//    switch (easeMessageModel.state) {
//        case EVEaseMessageTypeStateNor:
//        {
//         
//        }
//            break;
//        case EVEaseMessageTypeStateHl:
//        {
//            
//        }
//            break;
//        case EVEaseMessageTypeStateSt:
//        {
//            self.leftCircleIgeView.image = [UIImage imageNamed:@"ic_top"];
//            self.lineView.backgroundColor = [UIColor colorWithHexString:@"#672f87"];
//        }
//            break;
//            
//        default:
//            break;
//    }
}


- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
