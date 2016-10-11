//
//  EVSearchTextField.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVSearchTextField.h"
#import "EVLimitFiendCell.h"

#define MARGIN_RIGHT 30

#define ITEM_W ( 0.6 * 53 )

@interface CCSearchFriendCell : UICollectionViewCell

@property (nonatomic,weak) UIImageView *logoImageView;
@property (nonatomic, assign) BOOL clipLogo;

@property (nonatomic,strong)  EVFriendItem *item;

@end

@implementation CCSearchFriendCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    UIImageView *logoImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:logoImageView];
    self.logoImageView = logoImageView;
}

- (void)setItem:(EVFriendItem *)item
{
    _item = item;
    [self.logoImageView cc_setRoundImageWithDefaultPlaceHoderURLString:item.logourl];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.logoImageView.frame = self.contentView.bounds;
    
    if ( self.bounds.size.width && !self.clipLogo )
    {
        self.clipLogo = YES;
        self.logoImageView.layer.cornerRadius = 0.5 * self.logoImageView.bounds.size.width;
        self.logoImageView.clipsToBounds = YES;
    }
}

@end

@interface EVSearchTextField () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,weak) UIView *cursor;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,weak) UICollectionViewFlowLayout *layout;

@property (nonatomic,strong) NSMutableArray *friends;

@end

@implementation EVSearchTextField

- (void)dealloc
{
    [CCNotificationCenter removeObserver:self];
}

- (NSMutableArray *)friends
{
    if ( _friends == nil )
    {
        _friends = [NSMutableArray array];
    }
    return _friends;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    UIView *cursor = [[UIView alloc] init];
    cursor.backgroundColor = [UIColor blackColor];
    [self addSubview:cursor];
    self.cursor = cursor;
    cursor.hidden = YES;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWH = ITEM_W;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.leftView = collectionView;
    self.leftViewMode = UITextFieldViewModeAlways;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[CCSearchFriendCell class] forCellWithReuseIdentifier:@"CCSearchFriendCell"];
    collectionView.showsHorizontalScrollIndicator = NO;
    
    self.collectionView = collectionView;
    self.layout = layout;
}

- (void)setBeginEdit:(BOOL)beginEdit
{
    _beginEdit = beginEdit;
    
    if ( beginEdit )
    {
        if ( self.timer == nil )
        {
            self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(cursorChange) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }
    else
    {
        [self.timer invalidate];
        self.timer = nil;
        self.cursor.hidden = YES;
    }
}

- (void)cursorChange
{
    self.cursor.hidden = !self.cursor.hidden;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect collectionViewFrame = [self leftViewRectForBounds:self.bounds];
    CGSize size = CGSizeZero;
    
    if ( self.text.length != 0 )
    {
        size = [self.text sizeWithAttributes: @{NSFontAttributeName: self.font}];
    }
    
    CGFloat cursorHeight = 0.4 * self.bounds.size.height;
    
    self.cursor.frame = CGRectMake(size.width + collectionViewFrame.size.width, 0.5 * (self.bounds.size.height - cursorHeight), 1.5, cursorHeight);
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect collectionViewFrame = CGRectZero;
    if ( self.friends.count > 0 )
    {
        NSInteger count = self.friends.count;

        CGSize size = CGSizeMake(count * self.layout.itemSize.width + self.layout.minimumInteritemSpacing * (count + 1), ITEM_W);
        CGFloat maxW =  0.6 * ScreenWidth;
        if ( (size.width - MARGIN_RIGHT) > maxW )
        {
            collectionViewFrame = CGRectMake(0, 0, maxW, bounds.size.height);
        }
        else
        {
            collectionViewFrame = CGRectMake(0, 0, size.width, bounds.size.height);
        }
    }
    
    if ( [self.searchDelegate respondsToSelector:@selector(searchTextFieldDidChangeLeftView:)] )
    {
        [self.searchDelegate searchTextFieldDidChangeLeftView:collectionViewFrame];
    }
    
    return collectionViewFrame;
}

- (void)insertFriendItem:(EVFriendItem *)item
{
    if ( ![self.friends containsObject:item] )
    {
        [self.friends addObject:item];
        [self.collectionView reloadData];
        self.collectionView.frame = [self leftViewRectForBounds:self.bounds];
    }
}

- (void)deleteFriendItem:(EVFriendItem *)item
{
    [self.friends removeObject:item];
    [self.collectionView reloadData];
     self.collectionView.frame = [self leftViewRectForBounds:self.bounds];
}

- (BOOL)deleteLastItem
{
    EVFriendItem *item = [self.friends lastObject];
    if ( item )
    {
        item.selected = NO;
        [self.friends removeLastObject];
        self.collectionView.frame = [self leftViewRectForBounds:self.bounds];
        [self.collectionView reloadData];
        return YES;
    }
    return NO;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    EVFriendItem *item = self.friends[indexPath.item];
    item.selected = NO;
    [self deleteFriendItem:item];
    if ( [self.searchDelegate respondsToSelector:@selector(searchTextFieldDidCancelItem:)] )
    {
        [self.searchDelegate searchTextFieldDidCancelItem:item];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.friends.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CCSearchFriendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCSearchFriendCell" forIndexPath:indexPath];
    EVFriendItem *item = self.friends[indexPath.item];
    item.indexPathInSearch = indexPath;
    cell.item = item;
    return cell;
}

@end
