//
//  EVTimeLineNewVideoLayout.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVTimeLineNewVideoLayout.h"

@interface EVTimeLineNewVideoLayout ()

@property (nonatomic,strong) NSMutableArray *secion0Attrs;
@property (nonatomic,strong) NSMutableArray *secion1Attrs;

@property (nonatomic,strong) UICollectionViewLayoutAttributes *headerAttrs;

@end

@implementation EVTimeLineNewVideoLayout

- (instancetype)init
{
    if ( self = [super init] )
    {
        _secion0Attrs = [NSMutableArray arrayWithCapacity:10];
        _secion1Attrs = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (CGSize)collectionViewContentSize
{
    CGFloat width = self.collectionView.bounds.size.width;
    CGFloat firstSectionH = [self.collectionView numberOfItemsInSection:0] * self.firstSectionItemHeight;
    CGFloat secondSectionH = 0;
//    NSInteger numOfLineInSecondSection = ([self.collectionView numberOfItemsInSection:1] / 2 + [self.collectionView numberOfItemsInSection:1] % 2);
//    if ([self.collectionView numberOfItemsInSection:0] == 0)
//    {
//        secondSectionH = numOfLineInSecondSection * (self.secondSectionItemHeight - 10);
//    }
//    else
//    {
//        secondSectionH = numOfLineInSecondSection * self.secondSectionItemHeight;
//    }
    CGFloat height = self.headHeight + firstSectionH;
    return CGSizeMake(width, height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    if (elementKind == UICollectionElementKindSectionHeader)
    {
        attributes.size = CGSizeMake(ScreenWidth, self.headHeight);
        attributes.center = CGPointMake(self.collectionView.center.x, self.headHeight / 2);
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    [self setUpLayoutAttributes:attributes inSection:indexPath.section item:indexPath.item];
    
    return attributes;
}

- (void)setUpLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes
                    inSection:(NSInteger)section
                         item:(NSInteger)item
{
    CGFloat width = 0, height = 0, centerX = 0, centerY = 0;
    
    if (section == 0)
    {
        width = [self collectionViewContentSize].width;
        centerX = width / 2;
        centerY = self.firstSectionItemHeight * (item + .5) + self.headHeight;
        height = self.firstSectionItemHeight;
    }
    else
    {
        width = [self collectionViewContentSize].width / 2;
        height = self.secondSectionItemHeight;
        if ([self.collectionView numberOfItemsInSection:0] == 0)
        {
            height -= 10;
        }
        centerX = width / 2 + width * (item % 2);
        CGFloat sectionZeroBottom = self.headHeight + [self.collectionView numberOfItemsInSection:0] * self.firstSectionItemHeight;
        centerY = sectionZeroBottom + height / 2 + height * (item / 2);
    }
    attributes.size = CGSizeMake(width, height);
    attributes.center = CGPointMake(centerX, centerY);
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    if ( array.count > 0 )
    {
        return array;
    }
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    if ( _headerAttrs == nil )
    {
        NSIndexPath *indexP = [NSIndexPath indexPathForItem:0 inSection:0];
        _headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexP];
    }
    [attributes addObject:_headerAttrs];
    
    NSInteger section0Count = [self.collectionView numberOfItemsInSection:0];
    
    NSInteger secion0AttrsCount = _secion0Attrs.count;
    
    if ( section0Count > secion0AttrsCount )
    {
        for ( NSInteger i = 0; i < secion0AttrsCount; i++ )
        {
            UICollectionViewLayoutAttributes *attrs = _secion0Attrs[i];
            [self setUpLayoutAttributes:attrs inSection:0 item:i];
        }
        
        NSInteger i = secion0AttrsCount == 0 ? 0 :  secion0AttrsCount;
        for ( ; i < section0Count; i++ )
        {
            NSIndexPath *indexpath = [NSIndexPath indexPathForItem:i inSection:0];
            
            [_secion0Attrs addObject:[self layoutAttributesForItemAtIndexPath:indexpath]];
        }
        [attributes addObjectsFromArray:_secion0Attrs];
    }
    else if ( section0Count < secion0AttrsCount )
    {
        for ( NSInteger i = 0; i < section0Count ; i++ )
        {
            UICollectionViewLayoutAttributes *attrs = _secion0Attrs[i];
            [self setUpLayoutAttributes:attrs inSection:0 item:i];
            [attributes addObject:attrs];
        }
    }
    else
    {
        for ( NSInteger i = 0; i < _secion0Attrs.count; i++ )
        {
            UICollectionViewLayoutAttributes *attrs = _secion0Attrs[i];
            [self setUpLayoutAttributes:attrs inSection:0 item:i];
        }
        [attributes addObjectsFromArray:_secion0Attrs];
    }
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
