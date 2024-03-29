//
//  Mylayout.m
//  elapp
//
//  Created by 周恒 on 2017/4/11.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "WaterFlowLayout.h"

@interface WaterFlowLayout()
{
    CGFloat maxHeight;
}
/** 布局属性数组*/
@property (nonatomic,strong) NSMutableArray *attrsArray;

/** 存放所有列的当前高度*/
@property (nonatomic,strong) NSMutableArray *columnHeight;

@end

/**  列数*/
static const CGFloat columCount = 2;
/**  每一列间距*/
static const CGFloat columMargin = 36;
/**  每一列间距*/
static const CGFloat rowMargin = 36;
/**  边缘间距*/
static const UIEdgeInsets defaultEdgeInsets = {12,12,12,12};

@implementation WaterFlowLayout


/**  初始化*/
- (void)prepareLayout
{
    [super prepareLayout];
    NSLog(@"prepareLayout");
    //如果刷新布局就会重新调用prepareLayout这个方法,所以要先把高度数组清空
    [self.columnHeight removeAllObjects];
    for (int i = 0; i < self.columCount; i++)
    {
        [self.columnHeight addObject:@(self.defaultEdgeInsets.top)];
    }
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    [self.attrsArray removeAllObjects];
    
    for (NSInteger i = 0; i < count; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        //获取indexPath 对应cell 的布局属性
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attr];
    }
}


/**
 *  返回indexPath 位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"layoutAttributesForItemAtIndexPath indexPath%@",indexPath);
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //使用for循环,找出高度最短的那一列
    //最短高度的列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeight[0] doubleValue];
    
    for (NSInteger i = 1; i < self.columCount; i++)
    {
        CGFloat columnHeight  =[self.columnHeight[i] doubleValue];
        if (minColumnHeight > columnHeight)
        {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat w = (self.collectionView.frame.size.width - self.defaultEdgeInsets.left - self.defaultEdgeInsets.right - (self.columCount - 1) * self.columMargin )/self.columCount;
    
    //(使用代理在外部决定cell 的高度,下面会介绍)
    CGFloat h = [self.delegate waterFlowLayout:self heightForRowAtIndex:indexPath.item itemWidth:w];
    
    CGFloat x = self.defaultEdgeInsets.left + destColumn*(w + self.columMargin);
    CGFloat y = minColumnHeight ;
    
    if (y != self.defaultEdgeInsets.top) {
        
        y += self.rowMargin;
    }
    
    attr.frame = CGRectMake(x,y,w,h);
    
    self.columnHeight[destColumn] =  @(y+ h);
    
    maxHeight = [self.columnHeight[0] doubleValue];
    [self.columnHeight enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat value  = [obj floatValue];
        if (maxHeight < value) {
            maxHeight = value;
        }
    }];

    return attr;
}


/**
 *  决定cell 的排布
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"layoutAttributesForElementsInRect ");
    return self.attrsArray;
}


- (CGSize)collectionViewContentSize
{
    NSLog(@"collectionViewContentSize");
        return CGSizeMake(0, maxHeight+self.defaultEdgeInsets.bottom);
}

#pragma  mark ---  delgate
- (NSInteger)columCount{
    
    if ([self.delegate respondsToSelector:@selector(cloumnCountInWaterFlowLayout:)]) {
        return  [self.delegate cloumnCountInWaterFlowLayout:self];
    }
    else{
        return columCount;
    }
}

- (CGFloat)columMargin{
    
    if ([self.delegate respondsToSelector:@selector(columMarginInWaterFlowLayout:)]) {
        return  [self.delegate columMarginInWaterFlowLayout:self];
    }
    else{
        return columMargin;
    }
}

- (CGFloat)rowMargin{
    
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterFlowLayout:)]) {
        return  [self.delegate rowMarginInWaterFlowLayout:self];
    }
    else{
        return rowMargin;
    }
}

- (UIEdgeInsets)defaultEdgeInsets{
    if ([self.delegate respondsToSelector:@selector(edgeInsetInWaterFlowLayout:)]) {
        return  [self.delegate edgeInsetInWaterFlowLayout:self];
    }
    else{
        return defaultEdgeInsets;
    }
}



#pragma mark --   getter
- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (NSMutableArray *)columnHeight
{
    if (!_columnHeight) {
        
        _columnHeight = [NSMutableArray array];
    }
    return _columnHeight;
}

@end
