//
//  EVChooseNewsCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/5.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVChooseNewsCell.h"
#import "NSString+Extension.h"
#import "EVStockBaseModel.h"

@interface EVChooseNewsCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneStockLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoStockLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeStockLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneLabelWid;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoLabelWid;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeLabelWid;

@end


@implementation EVChooseNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setChooseNewsModel:(EVChooseNewsModel *)chooseNewsModel
{
    _chooseNewsModel = chooseNewsModel;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[NSString compareCurrentTime:chooseNewsModel.time]];
    self.contentLabel.text = [NSString stringWithFormat:@"%@",chooseNewsModel.title];
    
    if (chooseNewsModel.stocks.count == 0) {
        self.oneStockLabel.hidden = YES;
        self.twoStockLabel.hidden = YES;
        self.threeStockLabel.hidden = YES;
    }
    
    if (chooseNewsModel.stocks.count == 1) {
        [self loadStockLabel:self.oneStockLabel count:0 layoutF:self.oneLabelWid];
        self.twoStockLabel.hidden = YES;
        self.threeStockLabel.hidden = YES;
        self.oneStockLabel.textColor = [UIColor colorWithHexString:@"#FE494A"];
    }
    
    if (chooseNewsModel.stocks.count == 2) {
       [self loadStockLabel:self.oneStockLabel count:0 layoutF:self.oneLabelWid];
        [self loadStockLabel:self.twoStockLabel count:1 layoutF:self.twoLabelWid];
        self.twoStockLabel.hidden = NO;
        self.threeStockLabel.hidden = YES;
        self.twoStockLabel.textColor = [UIColor colorWithHexString:@"#FE494A"];
    }
    
    if (chooseNewsModel.stocks.count >= 3) {
        [self loadStockLabel:self.oneStockLabel count:0 layoutF:self.oneLabelWid];
        [self loadStockLabel:self.twoStockLabel count:1 layoutF:self.twoLabelWid];
        [self loadStockLabel:self.threeStockLabel count:2 layoutF:self.threeLabelWid];
        self.twoStockLabel.hidden = NO;
        self.threeStockLabel.hidden = NO;
        self.threeStockLabel.textColor = [UIColor colorWithHexString:@"#FE494A"];
    }
    
    
}


- (void)loadStockLabel:(UILabel *)label count:(NSInteger)count layoutF:(NSLayoutConstraint *)layoutF
{
    EVStockBaseModel *stockModel = _chooseNewsModel.stocks[count];
    NSString *stockF = @"%";
    NSString *persentS = [stockModel.persent floatValue] > 0 ? [NSString stringWithFormat:@"+%@%@",stockModel.persent,stockF] : [NSString stringWithFormat:@"%@%@",stockModel.persent,stockF];
    label.text = [NSString stringWithFormat:@"%@ %@",stockModel.name,persentS];
    CGSize widSize = [label sizeThatFits:CGSizeZero];
    layoutF.constant = widSize.width;
    label.textColor = [stockModel.persent floatValue] > 0 ? [UIColor evAssistColor] : [UIColor evSecondColor];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
