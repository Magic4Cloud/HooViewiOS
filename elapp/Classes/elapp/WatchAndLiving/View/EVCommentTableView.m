//
//  EVCommentTableView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVCommentTableView.h"
#import "EVCommentCell.h"

#define kPoolMaxsize 50

@interface EVCommentTableView ()

@property (nonatomic,strong) NSMutableArray *cellPool;
@property ( nonatomic, weak ) CAGradientLayer *gradient;

@end

@implementation EVCommentTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if ( self = [super initWithFrame:frame style:style] )
    {
//        [self addGradientLayer];
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ( [change[@"new"] CGPointValue].y > 0 )
    {
        if ( self.layer.mask != nil )
        {
            self.layer.mask = nil;
        }
    }
    else
    {
        // 防止多次操作layer
        if ( self.layer.mask == nil )
        {
            self.layer.mask = self.gradient;
        }
    }
}

- (void)addGradientLayer
{
    // 透明度渐变
//    self.layer.mask = self.gradient;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"contentOffset"];
//    EVLog(@"CCCommentTableView dealloc");
}

- (NSMutableArray *)cellPool
{
    if ( _cellPool == nil )
    {
        _cellPool = [NSMutableArray array];
    }
    return _cellPool;
}

- (void)pushCellToPool:(UITableViewCell *)cell
{
    if ( self.cellPool.count > kPoolMaxsize )
    {
        return;
    }
    [self.cellPool addObject:cell];
}

- (UITableViewCell *)popCellFromPoolWithID:(NSString *)cellID
{
    // 根据id找到可以用来复用的cell
    UITableViewCell *popCell = nil;
    
    for (int i = 0; i < self.cellPool.count; i++)
    {        
        if ( [cellID isEqualToString:((UITableViewCell *)self.cellPool[i]).reuseIdentifier] )
        {
            popCell = self.cellPool[i];
            break;
        }
    }
    
    if ( popCell == nil )
    {
        popCell = [[EVCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    else
    {
        [self.cellPool removeObject:popCell];
    }
//    popCell.backgroundColor = RandomColor;
    return popCell;
}

//- (CAGradientLayer *)gradient
//{
//    if ( !_gradient )
//    {
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = CGRectMake(0, 0, ScreenWidth - 60, kDefaultTableHeight);
//        gradient.colors = @[(id)[UIColor blackColor].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor clearColor].CGColor];
//        gradient.locations = @[@0, @0.8, @1];
//        _gradient = gradient;
//    }
//    return _gradient;
//}

@end
