//
//  EVConsultStockViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/4.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVConsultStockViewCell.h"
#import "EVCSStockButton.h"


@interface EVConsultStockViewCell ()

@property (nonatomic, weak) EVCSStockButton *csStockButton;

@end

@implementation EVConsultStockViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super  initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    NSArray *titleArray = @[@"上证",@"深成",@"创业板"];
    for (NSInteger i = 0; i < 3; i++) {
        EVCSStockButton *csStockBtn = [[EVCSStockButton alloc] init];
        csStockBtn.frame = CGRectMake(-1 + (i * ScreenWidth/3),0, ScreenWidth/3, 88);
        [self addSubview:csStockBtn];
        self.csStockButton = csStockBtn;
        csStockBtn.tag = 1000+i;
        [csStockBtn.nameLabel setText:titleArray[i]];
        [csStockBtn addTarget:self action:@selector(csStockClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

- (void)csStockClick:(EVCSStockButton *)btn
{
    if (self.scStock) {
        self.scStock(btn);
    }
}


- (void)setStockDataArray:(NSArray *)stockDataArray
{
    _stockDataArray = stockDataArray;
    for (NSInteger i = 0; i < stockDataArray.count; i++) {
        EVCSStockButton *csBtn = [self viewWithTag:i+1000];
        csBtn.stockBaseModel  = stockDataArray[i];
    }
}
@end
