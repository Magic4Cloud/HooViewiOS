//
//  EVMagicEmojiLayout.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVMagicEmojiLayout.h"

#define NumOfItem [self.collectionView numberOfItemsInSection:0]
#define Width self.collectionView.frame.size.width
#define Height self.collectionView.frame.size.height

@interface EVMagicEmojiLayout ()

/** 布局属性 */
@property ( nonatomic, strong ) NSMutableArray *layoutAttributes;

@end

@implementation EVMagicEmojiLayout

- (CGSize)collectionViewContentSize
{
    CGSize size;
    if (NumOfItem > 4)
    {
        // 宽度是collectionView的宽度的倍数
        size = CGSizeMake(Width * ceil(NumOfItem / 8.0), Height);
    }
    else
    {
        size = CGSizeMake(Width, Height);
    }
    return size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat cellWidth, cellHeight;
    if (NumOfItem > 4)
    {
        cellWidth = Width / 4.0;
        cellHeight = Height / 2;
    }
    else
    {
        cellWidth = Width / NumOfItem;
        cellHeight = Height;
    }
    attributes.size = CGSizeMake(cellWidth, cellHeight);
    CGFloat centerX = Width * (indexPath.item / 8) + cellWidth / 2 + cellWidth * (indexPath.item % 4);
    CGFloat centerY = cellHeight / 2 + indexPath.item / 4 % 2 * cellHeight;
    attributes.center = CGPointMake(centerX, centerY);
    
    return attributes;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    if (array.count > 0)
    {
        return array;
    }
    
    if ( self.layoutAttributes )
    {
        if ( NumOfItem > self.layoutAttributes.count )
        {
            NSArray *tempLayouts = self.layoutAttributes;
            for (NSUInteger i = tempLayouts.count; i <= NumOfItem; i++)
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:indexPath];
                [self.layoutAttributes addObject:att];
            }
        }
        if ( NumOfItem < self.layoutAttributes.count )
        {
            NSArray *tempLayouts = self.layoutAttributes;
            for (NSUInteger i = (NSInteger)tempLayouts.count - 1; i >= NumOfItem; i--)
            {
                [self.layoutAttributes removeObjectAtIndex:i];
            }
        }
        return self.layoutAttributes;
    }
    NSMutableArray *attributes = [NSMutableArray array];
    for (int i = 0; i < NumOfItem; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:indexPath];
        [attributes addObject:att];
    }
    self.layoutAttributes = attributes;
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
