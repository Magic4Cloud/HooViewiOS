//
//  EVHVGiftAniView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/11.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVGiftAniView.h"
#import "EVHVGiftAniViewCell.h"
#import "EVStartResourceTool.h"

@interface EVHVGiftAniView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *giftTableView;

@property (nonatomic, strong) NSMutableArray *colorArray;

@property (nonatomic, strong) NSMutableArray *newColorArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSArray *presentArr;

@property (nonatomic) NSTimer *timer;

@property (nonatomic, assign) long long timeLong;

@property (nonatomic, assign) BOOL isDeleteObject;

@end


@implementation EVHVGiftAniView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpView];
        self.timeLong = 0;
        _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(function:) userInfo:nil repeats:YES];
    }
    return self;
}


- (void)function:(NSTimer *)time
{
    self.isDeleteObject = NO;
    if (self.dataArray.count > 0) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray];
        for (EVStartGoodModel *model in array) {
            if ((self.timeLong - model.timeLong) > 4) {
                [self.dataArray removeObject:model];
                self.isDeleteObject = YES;
            }
        }
        if (self.isDeleteObject == YES) {
            [self.giftTableView reloadData];
        }
    }
    self.timeLong ++;
}
- (void)addUpView
{
    self.colorArray = [NSMutableArray arrayWithObjects:@"#66b5ff",@"9b66ff",@"ff6666",@"43ad44", nil];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(80, 40);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView   *giftTableView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    giftTableView.delegate = self;
    giftTableView.dataSource =self;
    giftTableView.scrollsToTop = YES;
    giftTableView.transform = CGAffineTransformMakeRotation(M_PI);
    [self addSubview:giftTableView];
    giftTableView.backgroundColor = [UIColor clearColor];
    self.giftTableView = giftTableView;
    giftTableView.showsVerticalScrollIndicator = NO;
    giftTableView.showsHorizontalScrollIndicator = NO;
    [giftTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [giftTableView registerClass:[EVHVGiftAniViewCell class] forCellWithReuseIdentifier:@"giftCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVHVGiftAniViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"giftCell" forIndexPath:indexPath];
    
    cell.startGoodModel = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)addStartGoodModel:(EVStartGoodModel *)model
{
    self.isDeleteObject = NO;
    EVStartGoodModel *startGoodModel = model;
    startGoodModel.timeLong = self.timeLong;
    startGoodModel.colorStr = self.colorArray[0];
    if (self.colorArray.count > 0) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.colorArray];
        [self.colorArray removeObject:self.colorArray[0]];
        [self.colorArray addObject:array[0]];
    }
    [self.dataArray insertObject:startGoodModel atIndex:0];
    [self.giftTableView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    EVHVGiftAniViewCell *giftCell = (EVHVGiftAniViewCell *)[self.giftTableView cellForItemAtIndexPath:indexPath];
    if (self.isDeleteObject == YES) {
        return;
    }
    cell.transform = CGAffineTransformMakeTranslation(0, -40);
    [UIView animateWithDuration:0.7 animations:^{
            cell.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
            
    }];
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSArray *)presentArr
{
    if (!_presentArr)
    {
        NSArray *presents = [[EVStartResourceTool shareInstance] presentsWithType:EVPresentTypePresent];
        NSArray *emojis = [[EVStartResourceTool shareInstance] presentsWithType:EVPresentTypeEmoji];
        NSMutableArray *presentArr = [NSMutableArray arrayWithArray:presents];
        [presentArr addObjectsFromArray:emojis];
        _presentArr = presentArr;
    }
    return _presentArr;
}

- (NSMutableArray *)newColorArray
{
    if (!_newColorArray) {
        _newColorArray = [NSMutableArray array];
        
    }
    return _newColorArray;
}
- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}
//- (NSMutableSet *)colorSet
//{
//    if (!_colorSet) {
//        _colorSet = [[NSMutableSet alloc] initWithObjects:@"66b5ff",@"9b66ff",@"ff6666",@"43ad44", nil];
//    }
//    return _colorSet;
//}

@end
