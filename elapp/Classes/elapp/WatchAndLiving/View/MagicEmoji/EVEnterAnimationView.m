//
//  EVEnterAnimationView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVEnterAnimationView.h"
#import "EVAudience.h"

#define kAnimationKey @"animationKey"
#define kAnimationValue @"animationX"

#define kImageWid 272
#define KImageHig 84
#define kLabelY   40
#define kToBottomHig 340

@interface EVEnterAnimationView ()
{
    CGRect rectMake;
    NSTimeInterval timeInterval;//时间
    BOOL isAnimation;
    BOOL isStar;
}
@property (nonatomic,weak)UIImageView *oneImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,weak)UIScrollView *scrollView;
@property (nonatomic,strong)NSMutableArray *animationArray;
@property (nonatomic,weak)UILabel *backLabel;


@end

@implementation EVEnterAnimationView
- (NSMutableArray *)animationArray
{
    if (_animationArray == nil) {
        _animationArray = [NSMutableArray array];
    }
    return _animationArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
        isStar = YES;
        
    }
    return self;
}

- (void)setUpView
{
    self.userInteractionEnabled = NO;
    
    UIImageView *oneImageV = [[UIImageView alloc]init];
    oneImageV.image = [UIImage imageNamed:@"FourEnterImage"];
    oneImageV.frame = CGRectMake(ScreenWidth, ScreenHeight - kToBottomHig,kImageWid,KImageHig);
    [self addSubview:oneImageV];
    self.oneImageView = oneImageV;
    
    
    
    UIScrollView *paoMaView = [[UIScrollView alloc]init];
    paoMaView.frame = CGRectMake(113, kLabelY,88, 20);
    paoMaView.scrollsToTop = YES;
    paoMaView.scrollEnabled = NO;
    paoMaView.backgroundColor = [UIColor clearColor];
    [oneImageV addSubview:paoMaView];
    self.scrollView = paoMaView;
    
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont boldSystemFontOfSize:14.0];
    nameLabel.text = kE_GlobalZH(@"e_no");
     nameLabel.backgroundColor = [UIColor clearColor];
    [paoMaView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    
    UILabel *backLabel = [[UILabel alloc]init];
    backLabel.frame = CGRectMake(207,kLabelY,69, 20);
    backLabel.font = [UIFont systemFontOfSize:14.0];
    backLabel.backgroundColor = [UIColor clearColor];
    backLabel.textAlignment = NSTextAlignmentLeft;
    backLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    backLabel.text = kE_GlobalZH(@"come_in_room");
    [oneImageV addSubview:backLabel];
    self.backLabel = backLabel;
}

- (void)starAnimation:(NSString*)str time:(float)time
{
    self.nameLabel.text = str;
    CGSize sizeOfText = [self.nameLabel sizeThatFits:CGSizeZero];
    self.nameLabel.frame = CGRectMake(0, 0,sizeOfText.width,20);
    self.nameLabel.textColor = [UIColor colorWithHexString:@"#FFED3F"];
    timeInterval = [self displayDurationForString:self.nameLabel.text];
    rectMake = CGRectMake(0, 0, sizeOfText.width, sizeOfText.height);
    isAnimation = sizeOfText.width > 90 ? YES : NO;
    if (isAnimation == YES) {
        self.backLabel.frame = CGRectMake(207,kLabelY,69, 20);
        [self animationTime:time];
    }else{
        self.backLabel.frame = CGRectMake(sizeOfText.width+119,kLabelY,69,20);
        return;
    }
}

- (void)animationTime:(float)time
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:timeInterval animations:^{
            self.nameLabel.frame = CGRectMake(-(rectMake.size.width-85), 0,rectMake.size.width,20);
        } completion:^(BOOL finished) {
            
        }];
    });
    
}

- (void)enterAnimation:(NSArray *)userArray
{
    [self.animationArray addObjectsFromArray:userArray];
    if (isStar == YES) {
        isStar = NO;
        [self xunhuanAnimation];
    }else{
        return;
    }
}

- (void)xunhuanAnimation
{
    if (self.animationArray.count >= 1) {
        EVAudience *Dict = [self.animationArray objectAtIndex:0];
        if (Dict.vip_level >= 3) {
            float duration = (float)(2*Dict.vip_level-2);
            NSString *vipLevel = [NSString stringWithFormat:@"%ld",Dict.vip_level];
            [self keyAnimationName:Dict.nickname userLevel:vipLevel duration:duration];
        }else{
            [self.animationArray removeObjectAtIndex:0];
            if (self.animationArray.count == 0) {
                isStar = YES;
            }else{
                [self xunhuanAnimation];
            }
        }
    }else{
        isStar = YES;
    }
}

- (void)keyAnimationName:(NSString *)name userLevel:(NSString *)userLevel duration:(float)duration
{
    [self starAnimation:name time:[userLevel floatValue]/3];
    [self enterUserLevel:[userLevel intValue]];
    self.oneImageView.hidden = NO;
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    keyAnimation.values= @[[NSValue valueWithCGPoint:CGPointMake(self.oneImageView.frame.origin.x+150, self.oneImageView.frame.origin.y)],
                           [NSValue valueWithCGPoint:CGPointMake(-self.oneImageView.frame.size.width, self.oneImageView.frame.origin.y)]];
    keyAnimation.duration = duration;
    keyAnimation.delegate = self;
    self.oneImageView.frame =  CGRectOffset(self.oneImageView.frame,ScreenWidth+self.oneImageView.frame.size.width, 0);
    [keyAnimation setValue:kAnimationValue forKey:kAnimationKey];
    [self.oneImageView.layer addAnimation:keyAnimation forKey:@"keyAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:kAnimationKey] isEqualToString:kAnimationValue]) {
        self.oneImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, ScreenHeight - kToBottomHig,kImageWid, KImageHig);
        self.nameLabel.frame = CGRectMake(0, 0,rectMake.size.width,20);
        [self.animationArray removeObjectAtIndex:0];
        if (self.animationArray.count == 0) {
            isStar = YES;
        }else{
          [self xunhuanAnimation];
        }
        [self.oneImageView.layer removeAnimationForKey:kAnimationKey];
    }
}

- (void)enterUserLevel:(int)enterLevelType
{
    switch (enterLevelType) {
        case EnterLevelNone:
            break;
        case EnterLevelOne:
            break;
        case EnterLevelTwo:
            break;
        case EnterLevelThree:
            self.oneImageView.image = [UIImage imageNamed:@"ThreeEnterImage"];
            break;
        case EnterLevelFour:
            self.oneImageView.image = [UIImage imageNamed:@"FourEnterImage"];
            break;
        case EnterLevelFive:
            self.oneImageView.image = [UIImage imageNamed:@"FiveEnterImage"];
            break;
        case EnterLevelSix:
            self.oneImageView.image = [UIImage imageNamed:@"SixEnterImage"];
            break;
        default:
            break;
    }
}

- (NSTimeInterval)displayDurationForString:(NSString*)string {
    return string.length/5;
}

- (void)dealloc
{
    [self.oneImageView.layer removeAnimationForKey:kAnimationKey];
}
@end
