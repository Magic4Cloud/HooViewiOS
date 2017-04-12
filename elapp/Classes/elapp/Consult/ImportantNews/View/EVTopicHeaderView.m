//
//  EVTopicHeaderView.m
//  elapp
//
//  Created by 唐超 on 4/11/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVTopicHeaderView.h"
#import "EVTopicModel.h"
@implementation EVTopicHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    self.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    
    [self addSubview:self.bgImageView];
    [self.bgImageView autoSetDimensionsToSize:CGSizeMake(self.bounds.size.width, 100)];
    [self.bgImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.bgImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.bgImageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    
    UIView * coverView = [UIView new];
    coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self.bgImageView addSubview:coverView];
    [coverView autoPinEdgesToSuperviewEdges];
    
    [self addSubview:self.viewCountLabel];
    [self.viewCountLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:8];
    [self.viewCountLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.bgImageView withOffset:16];
    self.viewCountLabel.backgroundColor = [UIColor redColor];
    
    UIImageView * viewImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_news_read_r"]];
    [self addSubview:viewImageView];
    [viewImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.viewCountLabel];
    [viewImageView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.viewCountLabel];
    
    UIImageView * coverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Special_layer"]];
    [self.bgImageView addSubview:coverImageView];
    [coverImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [coverImageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [coverImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    
    UIImageView * titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_news_special"]];
    [self addSubview:titleImageView];
    [titleImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bgImageView withOffset:5];
    [titleImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:7];
    
    
    [self addSubview:self.viewTitleLabel];
    [self.viewTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:11];
    [self.viewTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bgImageView withOffset:11];
    [self.viewTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:11];
//    [self.viewTitleLabel autoSetDimension:ALDimensionHeight toSize:50];
    
    [self addSubview:self.viewContentLabel];
    [self.viewContentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.viewTitleLabel withOffset:20];
    [self.viewContentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:11];
    [self.viewContentLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:11];
    
    [self.viewContentLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:16 relation:NSLayoutRelationGreaterThanOrEqual];
   
    [self bringSubviewToFront:self.viewCountLabel];
    [self bringSubviewToFront:viewImageView];
    
}
//给UILabel设置行间距和字间距
-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 6; //设置行间距
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}

#pragma mark - ✍️ Setters & Getters
- (void)setTopicModel:(EVTopicModel *)topicModel
{
    _topicModel = topicModel;
    
    
//    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:topicModel.title];
//    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
//    attch.image = [UIImage imageNamed:@"ic_news_special"];
//    attch.bounds = CGRectMake(0, 0, 30, 30);
//    NSAttributedString * titleString = [NSAttributedString attributedStringWithAttachment:attch];
//    [attri insertAttributedString:titleString atIndex:0];
    
//    self.viewTitleLabel.attributedText = attri;
    [self.viewTitleLabel sizeToFit];
    
    self.viewTitleLabel.text = [NSString stringWithFormat:@"      %@",topicModel.title] ;
    
    NSString * viewCount = topicModel.viewCount;
    long count = viewCount.length;
    NSMutableString *string = [NSMutableString stringWithString:viewCount];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    self.viewCountLabel.text = newstring;
    
    [self setLabelSpace:self.viewContentLabel withValue:topicModel.introduce withFont:[UIFont systemFontOfSize:14]];
    [_bgImageView cc_setImageWithURLString:topicModel.cover placeholderImage:nil];
    
}
//- (void)setFrame:(CGRect)frame
//{
//    _frame = frame;
//    [self layoutIfNeeded];
//}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.layer.masksToBounds = YES;
        
    }
    return _bgImageView;
}

- (UILabel *)viewCountLabel
{
    if (!_viewCountLabel) {
        _viewCountLabel = [[UILabel alloc] init];
        _viewCountLabel.textColor = [UIColor whiteColor];
        _viewCountLabel.font = [UIFont systemFontOfSize:16];
        _viewCountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _viewCountLabel;
}

- (UILabel *)viewTitleLabel
{
    if (!_viewTitleLabel) {
        _viewTitleLabel = [[UILabel alloc] init];
        _viewTitleLabel.textColor = [UIColor colorWithHexString:@"#303030"];
        _viewTitleLabel.font = [UIFont systemFontOfSize:18];
        _viewTitleLabel.textAlignment = NSTextAlignmentLeft;
        _viewTitleLabel.numberOfLines = 2;
    }
    return _viewTitleLabel;
}

- (UILabel *)viewContentLabel
{
    if (!_viewContentLabel) {
        _viewContentLabel = [[UILabel alloc] init];
        _viewContentLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        _viewContentLabel.font = [UIFont systemFontOfSize:14];
        _viewContentLabel.textAlignment = NSTextAlignmentLeft;
        _viewContentLabel.numberOfLines = 0;
    }
    return _viewContentLabel;
}
@end
