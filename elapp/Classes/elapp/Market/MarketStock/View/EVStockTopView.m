//
//  EVStockTopView.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/20.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVStockTopView.h"
#import "EVStockCollectionViewCell.h"



@interface EVStockTopView ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) UIScrollView *backScrollView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, assign) NSInteger divInteger;
@property (nonatomic, weak) UICollectionView *stockCollectionView;
//@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation EVStockTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    UIView *contentView =  [[UIView alloc] init];
    contentView.frame = CGRectMake(0, 0, ScreenWidth, 106);
    [self addSubview:contentView];
//    contentView.backgroundColor = [UIColor yellowColor];
    

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(ScreenWidth/3,106);
    flowLayout.sectionInset  = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.minimumInteritemSpacing = 0.f;
    UICollectionView *stockCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 106) collectionViewLayout:flowLayout];
    [contentView addSubview:stockCollectionView];
    stockCollectionView.delegate = self;
    stockCollectionView.dataSource = self;
    stockCollectionView.pagingEnabled = YES;
    stockCollectionView.bounces = NO;
    stockCollectionView.backgroundColor = [UIColor whiteColor];
    stockCollectionView.showsHorizontalScrollIndicator = NO;
    [stockCollectionView registerClass:[EVStockCollectionViewCell class] forCellWithReuseIdentifier:@"stockCell"];
    self.stockCollectionView = stockCollectionView;
    
    
//    UIPageControl *pageControl = [[UIPageControl alloc] init];
//    pageControl.frame = CGRectMake(0, 85, ScreenWidth, 15);
//    pageControl.backgroundColor = [UIColor clearColor];
//    pageControl.currentPage = 0;
//    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
//    pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
//    [contentView addSubview:pageControl];
//    self.pageControl = pageControl;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 106, ScreenWidth, 8)];
    lineView.backgroundColor = [UIColor evBackgroundColor];
    [self addSubview:lineView];
    
}

#pragma  - collectionview delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVStockCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"stockCell" forIndexPath:indexPath];
  
//    [self updateCellItemsForCell:cell indexPath:indexPath];
    cell.stockBaseModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)updateCellItemsForCell:(EVStockCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count % 3 == 0) {
        [cell updateCellItems:3];
    }else {
        if (self.divInteger == indexPath.row) {
            [cell updateCellItems:self.dataArray.count % 3];
        }else {
            [cell updateCellItems:3];
        }
    }
    if (indexPath.row <= self.divInteger) {
        if (self.divInteger == indexPath.row) {
            cell.dataArray = [self.dataArray subarrayWithRange:NSMakeRange(indexPath.row * 3,self.dataArray.count % 3)].mutableCopy;
        }else {
            cell.dataArray = [self.dataArray subarrayWithRange:NSMakeRange(indexPath.row * 3, 3)].mutableCopy;
        }
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 1、计算滚动到哪一页
    //NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
//    self.pageControl.currentPage = index;
}

- (void)updateStockData:(NSMutableArray *)data
{
    self.dataArray = [NSMutableArray arrayWithArray:data];
    //NSMutableArray *temArray = [NSMutableArray arrayWithArray:data];
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        self.divInteger = self.dataArray.count / 3;
        self.cellCount = self.dataArray.count % 3 == 0 ?  self.divInteger  :  self.divInteger  + 1;
    }
    [self.stockCollectionView reloadData];
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVStockBaseModel *stockModel = self.dataArray[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemBaseModel:)]) {
        [self.delegate didSelectItemBaseModel:stockModel];
    }
}

@end
