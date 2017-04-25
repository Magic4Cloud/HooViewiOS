//
//  EVHotListViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/6.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHotListViewCell.h"
#import "EVHotListCollectionViewCell.h"

@interface EVHotListViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *hotCollectionView;

@end


@implementation EVHotListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        [self setUpView];
    }
    return self;
}


- (void)setUpView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(220, 150);
    flowLayout.minimumLineSpacing = 20;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 14, 0, 14);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *hotCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 14,ScreenWidth, 150) collectionViewLayout:flowLayout];
    hotCollectionView.delegate = self;
    hotCollectionView.dataSource = self;
    [self addSubview:hotCollectionView];
    hotCollectionView.backgroundColor = [UIColor whiteColor];
    hotCollectionView.showsHorizontalScrollIndicator = NO;
    hotCollectionView.showsVerticalScrollIndicator = NO;
    self.hotCollectionView = hotCollectionView;
    
    [hotCollectionView registerClass:[EVHotListCollectionViewCell class] forCellWithReuseIdentifier:@"hotItemCell"];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVHotListCollectionViewCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotItemCell" forIndexPath:indexPath];
    EVWatchVideoInfo *watchVideoInfo = self.dataArray[indexPath.row];
    itemCell.watchVideoInfo = watchVideoInfo;
    return itemCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVWatchVideoInfo *watchVideoInfo = self.dataArray[indexPath.row];
    if (self.listSeletedBlock) {
        self.listSeletedBlock(watchVideoInfo);
    }
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self.hotCollectionView reloadData];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
