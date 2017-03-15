//
//  EVPromptRedPacketView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVPromptRedPacketView.h"
#import <PureLayout.h>
#import "EVRedEnvelopeModel.h"

#define  brandText  kE_GlobalZH(@"easyvaas_red_pack")
@interface EVPromptRedPacketView ()

/** 昵称label */
@property ( nonatomic, weak ) UILabel *nickNameLabel;

/** 祝福语label */
@property ( nonatomic, weak ) UILabel *greetingsLabel;

/** 计时 */
@property ( nonatomic ) NSInteger time;

/** 红包信息的数组 */
@property ( nonatomic, strong ) NSMutableArray *redPackets;

@property ( weak, nonatomic ) UILabel *brandLabel;


@end

@implementation EVPromptRedPacketView

- (void)pushRedPacket:(EVRedEnvelopeItemModel *)model
{
    BOOL canShow = self.redPackets.count == 0;
    [self.redPackets addObject:model];
    if ( canShow )
    {
        self.model = model;
    }
}

- (void)dealloc
{
    [EVNotificationCenter removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpViews];
        _redPackets = [NSMutableArray array];
        [EVNotificationCenter addObserver:self selector:@selector(updateTime) name:EVUpdateTime object:nil];
    }
    return self;
}

- (void)setModel:(EVRedEnvelopeItemModel *)model
{
    _model = model;
    self.hidden = NO;
    self.time = 0;
    self.nickNameLabel.text = model.nickname;
    self.greetingsLabel.text = model.hnm;
    NSString *text = brandText;
    switch (model.htp) {
        case CCRedEnvelopeTypeAudience:
            text = kE_GlobalZH(@"gift_red_pack");
            break;
        case CCRedEnvelopeTypeAnchor:
            text = kE_GlobalZH(@"anchor_red_pack");
            break;
        case CCRedEnvelopeTypeSystem:
           self.nickNameLabel.text = kE_GlobalZH(@"easyvaas_red_pack");
            break;
            
        default:
            break;
    }
    self.brandLabel.text = text;
}

- (void)showRedPacket
{
    if ( self.redPackets.firstObject && self.delegate && [self.delegate respondsToSelector:@selector(showRedPacktWithItem:)] )
    {
//        self.hidden = YES;
        [self.delegate showRedPacktWithItem:self.redPackets.firstObject];
    }
}

- (void)updateTime
{
    self.time++;
    if ( self.time == 10 )
    {
       
        EVRedEnvelopeItemModel *model = self.redPackets.firstObject;
        if ( model )
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.hidden = YES;
            }];
            [self.redPackets removeObjectAtIndex:0];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ( self.redPackets.firstObject )
            {
                self.model = self.redPackets.firstObject;
                self.hidden = NO;
            }
            self.time = 0;
        });
        
    }
}

- (void)setUpViews
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRedPacket)];
    [self addGestureRecognizer:tap];
    
    self.hidden = YES;
    self.layer.cornerRadius = 8;
    self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"living_redpacket_message"];
    [self addSubview:backImageView];
    [backImageView autoPinEdgesToSuperviewEdges];
    
    // 昵称
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.textColor = [UIColor colorWithHexString:@"F7C35B"];
    nickNameLabel.font = EVNormalFont(14);
    [self addSubview:nickNameLabel];
    [nickNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8];
    [nickNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:11];
    _nickNameLabel = nickNameLabel;
    
    // 祝福语
    UILabel *greetingsLabel = [[UILabel alloc] init];
    greetingsLabel.textColor = [UIColor whiteColor];
    greetingsLabel.font = EVNormalFont(14);
    [self addSubview:greetingsLabel];
    [greetingsLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:nickNameLabel withOffset:3];
    [greetingsLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:nickNameLabel];
    _greetingsLabel = greetingsLabel;
    
    UILabel *brandLabel = [[UILabel alloc] init];
    brandLabel.backgroundColor = [UIColor clearColor];
    brandLabel.textColor = [UIColor colorWithHexString:@"403B37" alpha:0.6];
    brandLabel.text = brandText;
    brandLabel.font = EVNormalFont(10);
    [self addSubview:brandLabel];
    [brandLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:nickNameLabel];
    [brandLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    self.brandLabel = brandLabel;
}

@end
