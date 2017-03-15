//
//  EVOtherPersonVideoTableViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVOtherPersonVideoTableViewCell.h"
#import "EVUserVideoModel.h"
#import "NSString+Extension.h"
#import "EVImageViewWithMask.h"

@interface EVOtherPersonVideoTableViewCell ()

@property (weak, nonatomic) IBOutlet EVImageViewWithMask *videoshot;    // 视频截图
@property (weak, nonatomic) IBOutlet UILabel *stamp;                    // 时间戳
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;               // 视频标题
@property (weak, nonatomic) IBOutlet UILabel *intro;                    // 视频简介
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UIButton *pwdLocker;                   // 密码锁

@end

@implementation EVOtherPersonVideoTableViewCell

#pragma mark - class methods

+(NSString *)cellID
{
    return @"CCOtherPersonVideoTableViewCellID";
}


#pragma mark - life circle

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self configUI];
}


#pragma mark - private methods

- (void)configUI
{
    self.videoshot.contentMode = UIViewContentModeScaleAspectFill;
    self.duration.font = [[EVAppSetting shareInstance] normalFontWithSize:12.0f];
    self.stamp.font = [[EVAppSetting shareInstance] normalFontWithSize:14.0f];
    self.stamp.textColor = [UIColor colorWithHexString:@"#666666"];
    self.videoTitle.font = [[EVAppSetting shareInstance] normalFontWithSize:14.0f];
}

// 采用富文本的形式对label的内容进行展示
- (void)setLabel:(UILabel *)label WithWatch:(NSUInteger)watchCount like:(NSUInteger)likeCount comment:(NSUInteger)commentCount type:(CCCellType)type
{
    [label setAttributeTextWithWatch:watchCount like:likeCount comment:commentCount fontSize:11.0f titleToTitleWhitespaceNumbers:3 type:type];
}

#pragma mark - getters and setters

// 根据model展示cell
- (void)setModel:(EVUserVideoModel *)model {
    _model = model;
    switch (model.permission) {
        case EVLivePermissionSquare: {
            // 视频标题
            self.videoTitle.text = self.model.title;
            break;
        }
        case EVLivePermissionPrivate: {
            // 视频标题
            self.videoTitle.text = @"私密直播";
            break;
        }
        case EVLivePermissionPassWord: {
            self.videoTitle.text = @"密码直播";
            break;
        }
        case EVLivePermissionPay: {
            self.videoTitle.text = @"付费直播";
            break;
        }
    }
    
    // 视频截图
    [self.videoshot cc_setImageWithURLString:self.model.thumb placeholderImage:[UIImage imageWithALogoWithSize:self.videoshot.bounds.size isLiving:NO] complete:nil];
    
   
    
    CCCellType type = CCCellTypeVideo;
    if ( model.mode == 0 )
    {
        type = CCCellTypeVideo;
    }
    else if ( model.mode == 1 )
    {
        type = CCCellTypeAudeo;
    }
    
    // 观看数、点赞数、评论数
    [self setLabel:self.intro WithWatch:self.model.watch_count like:self.model.like_count comment:self.model.comment_count type:type];
    
    // 展示是否正在直播
    if (self.model.living == 1) {
        self.duration.text =  kE_GlobalZH(@"living");
        self.duration.backgroundColor = [UIColor colorWithHexString:@"#aa3333"];
        
    } else {
        self.duration.text = [NSString clockTimeDurationWithSpan:self.model.duration];
        self.duration.backgroundColor = [UIColor clearColor];
        self.duration.textColor = [UIColor whiteColor];
    }
    self.stamp.text = [NSString dateTimeStampWithStoptime:self.model.live_start_time];

    self.pwdLocker.hidden = YES;
}

@end
