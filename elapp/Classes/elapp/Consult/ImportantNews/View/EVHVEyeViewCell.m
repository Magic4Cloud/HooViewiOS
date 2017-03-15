//
//  EVHVEyeViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/4.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVEyeViewCell.h"

@interface EVHVEyeViewCell ()

@property (nonatomic, weak) UIButton *titleButton;

@property (weak, nonatomic) IBOutlet UIButton *firstButton;

@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@property (weak, nonatomic) IBOutlet UIButton *threeButton;

@property (weak, nonatomic) IBOutlet UIView *firstLabel;

@property (weak, nonatomic) IBOutlet UIView *secondLabel;
@property (weak, nonatomic) IBOutlet UIView *threeLabel;

@property (nonatomic , strong) NSMutableArray *labelArray;


@end

@implementation EVHVEyeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
    self.firstLabel.layer.borderColor = [UIColor evMainColor].CGColor;
    self.firstLabel.layer.borderWidth = 1;
    self.secondLabel.layer.borderColor = [UIColor evMainColor].CGColor;
    self.secondLabel.layer.borderWidth = 1;
    
    self.threeLabel.layer.borderColor = [UIColor evMainColor].CGColor;
    self.threeLabel.layer.borderWidth = 1;
    
    
    
    // Initialization code
}

- (IBAction)newsClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsButton:)]) {
        [self.delegate newsButton:sender];
    }

}

- (IBAction)moreNews:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreButton:)]) {
        [self.delegate moreButton:sender];
    }
    
}

- (void)setEyesArray:(NSArray *)eyesArray
{
    _eyesArray = eyesArray;
    NSArray *buttonArray = @[_firstButton,_secondButton,_threeButton];
    if (eyesArray.count > 3) {
        return;
    }
    NSArray *labelA = @[_firstLabel,_secondLabel,_threeLabel];
   
    
    for (NSInteger i = 0; i < _eyesArray.count; i++) {
        UILabel *Qlabel = labelA[i];
        Qlabel.hidden = NO;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(40, 0, ScreenWidth - 70, 50);
        titleLabel.numberOfLines = 2;
        titleLabel.tag = 3000+i;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.textColor = [UIColor evTextColorH1];
        [buttonArray[i] addSubview:titleLabel];
        titleLabel.font = [UIFont textFontB3];
        if (_eyesArray.count - 1 != i) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 49, ScreenWidth - 42, 1)];
            lineView.backgroundColor = [UIColor evLineColor];
            [buttonArray[i] addSubview:lineView];
        }
        
    }
    for (NSInteger i = 0 ;i < eyesArray.count; i++) {
        UILabel *lbl = [self viewWithTag:i+3000];
        EVBaseNewsModel *newsModel = eyesArray[i];
        lbl.text = newsModel.title;
    }
    
}


- (NSMutableArray *)labelArray
{
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
