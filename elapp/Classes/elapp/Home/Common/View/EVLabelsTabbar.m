//
//  EVLabelsTabbar.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVLabelsTabbar.h"
#import <PureLayout.h>
#import "EVLabelsTabbarCell.h"
#import "EVLabelsTabbarItem.h"

#define ITEM_COUNT                  6
#define SLIDER_HEIGHT               3

#define ID_CELL @"CCLabelsTabbarCell"

@interface EVLabelsTabbar () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,weak) UIView *slider;
@end

@implementation EVLabelsTabbar

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
    self.backgroundColor = [UIColor whiteColor];
    CGFloat itemw = ScreenWidth / ITEM_COUNT;
    CGFloat itemh = LABELTABBAR_HEIGHT;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemw, itemh);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:collectionView];
    [collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [collectionView registerClass:[EVLabelsTabbarCell class] forCellWithReuseIdentifier:ID_CELL];
    self.collectionView = collectionView;
    
    UIView *slider = [[UIView alloc] init];
    slider.userInteractionEnabled = NO;
    slider.backgroundColor = [UIColor evMainColor];
    [self addSubview:slider];
    CGRect frame = CGRectMake(0, LABELTABBAR_HEIGHT - SLIDER_HEIGHT, itemw, SLIDER_HEIGHT);
    slider.frame = frame;
    self.slider = slider;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor evGlobalSeparatorColor];
    [self addSubview:line];
    [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [line autoSetDimension:ALDimensionHeight toSize:0.5];
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVLabelsTabbarCell *cell = (EVLabelsTabbarCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ID_CELL forIndexPath:indexPath];
    EVLabelsTabbarItem *item = self.items[indexPath.item];
    cell.item = item;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVLabelsTabbarItem *item = self.items[indexPath.item];
    [self updateItemWithIndex:indexPath.item];
    [collectionView reloadData];
    if ( item && [self.delegate respondsToSelector:@selector(labelsTabbar:didSelectedItem:)] )
    {
        [self.delegate labelsTabbar:self didSelectedItem:item];
    }
}

- (void)setSliderIndex:(NSInteger)sliderIndex
{
    if ( sliderIndex != _sliderIndex )
    {
        _sliderIndex = sliderIndex;
        [self adjustSliderToIndex:sliderIndex];
    }
}

- (void)adjustSliderToIndex:(NSInteger)index
{
    CGRect frame = self.slider.frame;
    [self updateItemWithIndex:index];
    frame.origin.x = index * frame.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.frame = frame;
    }];
}

- (void)updateItemWithIndex:(NSInteger)index
{
    EVLabelsTabbarItem *item = self.items[index];
    item.selected = YES;
    for (EVLabelsTabbarItem *subItem in self.items)
    {
        if ( item != subItem  )
        {
            subItem.selected = NO;
        }
    }
    [self.collectionView reloadData];
}

- (UIColor *)randomColor
{
    return [UIColor colorWithRed:arc4random_uniform(255)/ 255.0 green:arc4random_uniform(255)/ 255.0 blue:arc4random_uniform(255)/ 255.0 alpha:1.0];
}

@end
