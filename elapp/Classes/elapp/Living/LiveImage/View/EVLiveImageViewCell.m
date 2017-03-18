//
//  EVLiveImageViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/13.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVLiveImageViewCell.h"
#import "EVHotImageCollectionViewCell.h"

@interface EVLiveImageViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *hotCollectionView;

@end

@implementation EVLiveImageViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(106, 125);
    flowLayout.minimumLineSpacing = 4;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *hotCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, 125) collectionViewLayout:flowLayout];
    hotCollectionView.delegate = self;
    hotCollectionView.dataSource = self;
    [self addSubview:hotCollectionView];
    hotCollectionView.backgroundColor = [UIColor whiteColor];
    hotCollectionView.showsHorizontalScrollIndicator = NO;
    hotCollectionView.showsVerticalScrollIndicator = NO;
    self.hotCollectionView = hotCollectionView;
    
    [hotCollectionView registerClass:[EVHotImageCollectionViewCell class] forCellWithReuseIdentifier:@"hotItemCell"];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataLiveArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVHotImageCollectionViewCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotItemCell" forIndexPath:indexPath];
    EVWatchVideoInfo *watchVideoInfo = self.dataLiveArray[indexPath.row];
    itemCell.liveVideoInfo = watchVideoInfo;
    itemCell.watchVideoInfo = self.dataArray[indexPath.row];
    itemCell.backgroundColor = [UIColor clearColor];
    return itemCell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVWatchVideoInfo *watchVideoInfo = self.dataArray[indexPath.row];
    EVWatchVideoInfo *liveVideoInfo = self.dataLiveArray[indexPath.row];
    if (self.listSeletedBlock) {
        self.listSeletedBlock(watchVideoInfo,liveVideoInfo);
    }
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self.hotCollectionView reloadData];
}

- (void)setDataLiveArray:(NSMutableArray *)dataLiveArray
{
    _dataLiveArray = dataLiveArray;
    [self.hotCollectionView reloadData];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
