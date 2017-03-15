//
//  EVChatTextView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVChatTextView.h"
#import <PureLayout.h>
#import "EVFace.h"
#import "EVEmotionView.h"
#import "EVFaceGroup.h"
#import "EVFaceCell.h"
#import "EVEmojiTool.h"

#define kDefaultTextFieldHeight 44

#define kDefaultComfirmButtonWidth 65
#define kDefaultFont [UIFont systemFontOfSize:15]

#define kDefaultComfirmButtonHeight kDefaultTextFieldHeight
#define kDefaultLayerCorner 3
#define kDefauntEmojiKeyBackGroundColor [UIColor colorWithHexString:@"#1f1f1f" alpha:0.8]

#define kKeyBoardHeight 210
#define kCellMargin 15
#define kBorderMargin 20
#define kItemWH 45
// 38

#define kGroupSize 21

#define kButtonWH 35

@interface EVChatTextView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property ( nonatomic, weak ) EVEmotionView *emotionView;
@property ( nonatomic, strong ) NSArray *faceGroups;
@property ( nonatomic, weak ) UIPageControl *pageControl;
@property ( nonatomic, weak ) UILabel *placeHoldeLabel;
@property ( nonatomic, weak )  UIButton *sendButton;

@end

@implementation EVChatTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self setUpPlaceHoder];
        [self setUpFaceKeyBoard];
        [self setUpNotification];
    }
    return self;
}

- (void)dealloc
{
    [EVNotificationCenter removeObserver:self];
}

- (void)setUpNotification
{
    [EVNotificationCenter addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textChanged
{
    if ( self.isFirstResponder )
    {
        self.placeHoldeLabel.hidden = self.attributedText.length != 0;
        if (self.text.length > 0 || self.attributedText.length > 0)
        {
            self.sendButton.enabled = YES;
            self.sendButton.layer.borderColor = [UIColor clearColor].CGColor;
            self.sendButton.backgroundColor = [UIColor evMainColor];
        }
        else
        {
            self.sendButton.backgroundColor = [UIColor clearColor];
            self.sendButton.enabled = NO;
            self.sendButton.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        }
        
        if ( [self.chatTextViewDelegate respondsToSelector:@selector(chatTextViewTextDidChange:)] )
        {
            [self.chatTextViewDelegate chatTextViewTextDidChange:self];
        }
    }
}

- (void)setUpPlaceHoder
{
    UILabel *placeHoldeLabel = [[UILabel alloc] init];
    placeHoldeLabel.backgroundColor = [UIColor clearColor];
    placeHoldeLabel.textColor = [UIColor evTextColorH3];
    placeHoldeLabel.userInteractionEnabled = NO;
    placeHoldeLabel.backgroundColor = [UIColor clearColor];
    placeHoldeLabel.clipsToBounds = YES;
    placeHoldeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:placeHoldeLabel];
    [placeHoldeLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(7, 5, 0, 0) excludingEdge:ALEdgeRight];
    _placeHoldeLabel = placeHoldeLabel;
    self.backgroundColor = [UIColor evBackgroundColor];
    self.clipsToBounds = YES;

}

- (void)setPlaceHoderTextColor:(UIColor *)placeHoderTextColor
{
    self.placeHoldeLabel.textColor = placeHoderTextColor;
}

- (void)setPlaceHoder:(NSString *)placeHoder
{
    self.placeHoldeLabel.text = placeHoder;
}

- (void)setFont:(UIFont *)font
{
    self.placeHoldeLabel.font = font;
    [super setFont:font];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    [self.placeHoldeLabel setTextAlignment:textAlignment];
}

- (void)setUpFaceKeyBoard
{
    CGFloat contentViewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat contentViewH = kKeyBoardHeight;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentViewW, contentViewH)];
    contentView.backgroundColor = kDefauntEmojiKeyBackGroundColor;
    self.contentView = contentView;
    
    CGFloat emotionH = kKeyBoardHeight * 0.8;
    CGFloat emotionW = contentViewW;
    
    NSInteger row = 3;
    NSInteger column = 7;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat upDownMargin = 0;
    CGFloat sideMargin = 10;
    CGFloat itemW = (emotionW - 2 *  sideMargin) / column;
    CGFloat itemH = (emotionH - 2 * upDownMargin) / row;
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(upDownMargin, sideMargin, upDownMargin, sideMargin);
    
    EVEmotionView *emotionView = [[EVEmotionView alloc] initWithFrame:CGRectMake(0, 0, emotionW, emotionH) collectionViewLayout:layout];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    emotionView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:emotionView];
    emotionView.pagingEnabled = YES;
    emotionView.showsHorizontalScrollIndicator = NO;
    emotionView.dataSource = self;
    emotionView.delegate = self;
    [emotionView registerClass:[EVFaceCell class] forCellWithReuseIdentifier:@"cell"];
    [contentView addSubview:emotionView];
    self.emotionView = emotionView;
    
    CGFloat pageControlW = contentViewW;
    CGFloat pageControlH = contentViewH - emotionH;
    CGFloat pageControlX = 0;
    CGFloat pageControlY = contentViewH - pageControlH;
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH)];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#bbbbbb"];
    [contentView addSubview:pageControl];
    pageControl.userInteractionEnabled = NO;
    self.pageControl = pageControl;
    
    UIButton *sendButton = [[UIButton alloc] init];
    [sendButton setTitle:kSend forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateDisabled];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:12];
    sendButton.layer.borderWidth = 0.5f;
    [contentView addSubview:sendButton];
    sendButton.hidden = YES;
    self.sendButton = sendButton;
    [sendButton addTarget:self action:@selector(sendButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    self.sendButton.backgroundColor = [UIColor clearColor];
    self.sendButton.enabled = NO;
    self.sendButton.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    CGFloat sendButtonHeight = 25.f;
    [sendButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [sendButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [sendButton autoSetDimension:ALDimensionHeight toSize:sendButtonHeight];
    [sendButton autoSetDimension:ALDimensionWidth toSize:60];
    sendButton.layer.cornerRadius = sendButtonHeight * 0.5f;
    sendButton.layer.masksToBounds = YES;
    
    [self setupGroups];
}

- (void)sendButtonDidClicked
{
    if ( [self.chatTextViewDelegate respondsToSelector:@selector(chatTextViewSendButtonDidClicked:)] )
    {
        [self.chatTextViewDelegate chatTextViewSendButtonDidClicked:self];
    }
}

- (void)setPlaceHolderHidden:(BOOL)placeHolderHidden
{
    self.placeHoldeLabel.hidden = placeHolderHidden;
}

- (void)setShowSendButton:(BOOL)showSendButton
{
    _showSendButton = showSendButton;
    self.sendButton.hidden = !showSendButton;
}

- (void)setupGroups
{
    NSArray *facesArray = [EVEmojiTool emojiArray];
    NSInteger groupCount = (facesArray.count + (kGroupSize - 1) - 1) / (kGroupSize - 1);
    NSMutableArray *faceGroups = [NSMutableArray arrayWithCapacity:groupCount];
    
    NSMutableArray *faces = nil;
    for (NSInteger i = 0; i < facesArray.count; i++)
    {
        if ( i % (kGroupSize - 1) == 0 )
        {
            if ( i != 0 )
            {
                [faces addObject:[EVFace deletFace]];
                [faceGroups addObject:[EVFaceGroup faceGroupWithFaces:faces]];
            }
            faces = [NSMutableArray arrayWithCapacity:(kGroupSize - 1)];
        }
        [faces addObject:facesArray[i]];
    }
    
    self.faceGroups = [faceGroups copy];
    [self.emotionView reloadData];
    self.pageControl.numberOfPages = faceGroups.count;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.faceGroups.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    EVFaceGroup *group = self.faceGroups[section];
    return group.faces.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    EVFaceCell *cell = (EVFaceCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    EVFaceGroup *group = self.faceGroups[indexPath.section];
    EVFace *face = group.faces[indexPath.item];
    cell.face = face;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVFaceGroup *group = self.faceGroups[indexPath.section];
    EVFace *face = group.faces[indexPath.item];
    [self inputFace:face];
    [EVNotificationCenter postNotificationName:UITextViewTextDidChangeNotification object:self userInfo:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = page;
}

- (void)setText:(NSString *)text
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = NSMakeRange(0, attrString.length);
    [attrString addAttribute:NSFontAttributeName value:self.font range:range];
    self.attributedText = attrString;
    [self textChanged];
}

@end
