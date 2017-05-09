//
//  EVNewsConrentCell.m
//  elapp
//
//  Created by 唐超 on 5/9/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVNewsContentCell.h"

@implementation EVNewsContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    _cellWebView = [[WKWebView alloc] init];
    _cellWebView.navigationDelegate = self;
    [self.contentView addSubview:_cellWebView];
    [_cellWebView autoPinEdgesToSuperviewEdges];
}
@end
