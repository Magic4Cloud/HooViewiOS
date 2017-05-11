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
    
    _webView = [[UIWebView alloc] init];
    _webView.scrollView.scrollEnabled = NO;
    [self.contentView addSubview:_webView];
    [_webView autoPinEdgesToSuperviewEdges];
}

- (void)setHtmlString:(NSString *)htmlString
{
    if (_htmlString || !htmlString) {
        return;
    }
    
    _htmlString = htmlString;
    
    htmlString = [self autoWebAutoImageSize:htmlString];
    
    [_webView loadHTMLString:htmlString baseURL:nil];
}

- (NSString *)autoWebAutoImageSize:(NSString *)html
{
    
    NSString * regExpStr = @"<img\\s+.*?\\s+(style\\s*=\\s*.+?\")";
    NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:regExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *matches=[regex matchesInString:html
                                    options:0
                                      range:NSMakeRange(0, [html length])];
    
    
    NSMutableArray * mutArray = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        NSString* group1 = [html substringWithRange:[match rangeAtIndex:1]];
        [mutArray addObject: group1];
    }
    
    NSUInteger len = [mutArray count];
    for (int i = 0; i < len; ++ i) {
        html = [html stringByReplacingOccurrencesOfString:mutArray[i] withString: @"style=\"width:100%; height:auto;\""];
    }
    
    return html;
}



@end
