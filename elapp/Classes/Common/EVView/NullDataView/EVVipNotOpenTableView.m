//
//  EVVipNotOpenTableView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/17.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVVipNotOpenTableView.h"
#import "EVNotOpenView.h"

@interface EVVipNotOpenTableView ()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation EVVipNotOpenTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor evBackgroundColor];
        
        EVNotOpenView *notOpenView = [[EVNotOpenView alloc] init];
        notOpenView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 400);
        self.tableFooterView = notOpenView;
    }
    return self;
}


#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"openCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"openCell"];
    }
    return cell;
}
@end
