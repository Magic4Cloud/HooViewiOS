//
//  EVMovingConvexView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVMovingConvexView.h"

@interface CCMovingConvexLine : NSObject

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@end

@implementation CCMovingConvexLine

@end

#define MC_RADIUS                       10
#define MC_CENTER_RADIUS                2
#define MC_SCROLL_CIRCLE_RADIUS         ( 2 * MC_RADIUS )

@interface EVMovingConvexView ()

@property (nonatomic, assign) NSInteger pontCount;
@property (nonatomic, assign) UIColor *styleColor;

@property (nonatomic,strong) NSArray *lines;
@property (nonatomic, assign) CGRect selectCircleRect;
@property (nonatomic, assign) BOOL updating;

@end

@implementation EVMovingConvexView

- (instancetype)initWithPointCount:(NSInteger)pointCount
{
    if ( self = [super init] )
    {
        self.pontCount = pointCount;
        self.styleColor = CCAppMainColor;
        _scrollPercent = 0.0;
    }
    return self;
}

- (void)setScrollPercent:(CGFloat)scrollPercent
{
    _scrollPercent = scrollPercent;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat centerWholeW = rect.size.width;
    CGFloat centerY = rect.size.height * 0.5;
    
    CGFloat bgCircleRadius = rect.size.height * 0.4;
    CGFloat bgScrollW = ( centerWholeW - 2 * bgCircleRadius );
    CGFloat scrollSCenterX = _scrollPercent * bgScrollW + bgCircleRadius;
    CGPoint scrollSCenter = CGPointMake(scrollSCenterX , centerY);
    
    CGFloat selectRectOriginX = scrollSCenterX - bgCircleRadius;
    CGFloat selectRectOriginY = centerY - bgCircleRadius;
    CGFloat selectRectWH = bgCircleRadius * 2;
    _selectCircleRect = CGRectMake(selectRectOriginX, selectRectOriginY, selectRectWH, selectRectWH);
    
    // 画线
    CGFloat itemLineW = ( centerWholeW - _pontCount * ( 2 * bgCircleRadius ) ) / ( _pontCount - 1 );
    
    NSMutableArray *lines = nil;
    
    if ( self.lines == nil )
    {
        lines = [NSMutableArray array];
    }
    
    for ( NSInteger i = 0; i < _pontCount - 1; i++ )
    {
        CGFloat startx = ( 2 * bgCircleRadius ) * ( i + 1 ) + itemLineW * i;
        CGFloat endx = startx + itemLineW;
        CGPoint startPoint = CGPointMake(startx, centerY - MC_CENTER_RADIUS);
        CGPoint endPoint = CGPointMake(endx, startPoint.y);
        [self drawLineWithStartPoint:startPoint endPoint:endPoint];
        
        if ( lines )
        {
            CCMovingConvexLine *line = [[CCMovingConvexLine alloc] init];
            line.startPoint = startPoint;
            line.endPoint = endPoint;
            [lines addObject:line];
        }
        
    }
    
    if ( lines )
    {
        self.lines = lines;
    }
    
    // 确定滚动圆的圆心
    CGFloat endAngle = 0.0;
    CGFloat startAngle = 0.0;
    BOOL needToDraw = NO;
    
    CGFloat circleLX = scrollSCenterX - bgCircleRadius * 0.8;
    CGFloat circleRX = scrollSCenterX + bgCircleRadius * 0.8;
    
    CGFloat diff = 1;
    
    for ( CCMovingConvexLine *line in self.lines )
    {
        if ( ( circleLX >= line.startPoint.x - diff && circleRX <= line.endPoint.x )
            || ( circleLX >= line.startPoint.x  && circleRX <= line.endPoint.x + diff ) )
        {
            needToDraw = YES;
            endAngle = M_PI;
            startAngle = 0.0;
            break;
        }
        else if ( circleLX < line.startPoint.x && circleRX > line.startPoint.x )
        {
            needToDraw = YES;
            startAngle = 0.0;
            endAngle = ( circleRX - line.startPoint.x ) / ( 2 * bgCircleRadius ) * M_PI ;
            break;
        }
        else if ( circleRX > line.endPoint.x && circleLX < line.endPoint.x )
        {
            needToDraw = YES;
            endAngle = M_PI;
            startAngle = ( circleRX - line.endPoint.x ) / ( 2 * bgCircleRadius ) * M_PI ;
            break;
        }
    }
    
    if ( needToDraw )
    {
        CGFloat radius = bgCircleRadius - 1;
        UIBezierPath *scrrollBGCircle = [UIBezierPath bezierPathWithArcCenter:scrollSCenter radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [scrrollBGCircle addLineToPoint:scrollSCenter];
        [_styleColor set];
        [scrrollBGCircle fill];
        
        if ( endAngle == M_PI && startAngle == 0 )
        {
            CGFloat startX = scrollSCenter.x - bgCircleRadius + diff;
            CGFloat startY = scrollSCenter.y - MC_CENTER_RADIUS;
            CGFloat endX = scrollSCenter.x + bgCircleRadius - diff;
            CGFloat endY = startY;
            [self drawLineWithStartPoint:CGPointMake(startX, startY) endPoint:CGPointMake(endX, endY)];
        }
    }
    
    // 小圆圆心
    CGFloat border = 0.8 * bgCircleRadius - 1;
    UIBezierPath *scrrollBGCircle = [UIBezierPath bezierPathWithArcCenter:scrollSCenter radius:0.8 * bgCircleRadius startAngle:.0f endAngle:M_PI * 2 clockwise:YES];
    [_styleColor set];
    [scrrollBGCircle fill];
    
    scrrollBGCircle = [UIBezierPath bezierPathWithArcCenter:scrollSCenter radius:border startAngle:.0f endAngle:M_PI * 2 clockwise:YES];
    [CCColor(255, 250, 250) set];
    [scrrollBGCircle fill];
    
    // 画圆心
    CGFloat itemW = bgScrollW /( _pontCount - 1);
    for ( NSInteger i = 0; i < _pontCount; i++ )
    {
        CGFloat x = bgCircleRadius + itemW * i;
        CGPoint center = CGPointMake(x, centerY);
        [self drawCirclePoint:center];
    }
}

- (void)drawCirclePoint:(CGPoint)point
{
    UIBezierPath *dotPath = [UIBezierPath bezierPathWithArcCenter:point radius:MC_CENTER_RADIUS startAngle:.0f endAngle:M_PI * 2 clockwise:YES];
    [_styleColor set];
    [dotPath fill];
}

- (void)drawLineWithStartPoint:(CGPoint)startPoint
                      endPoint:(CGPoint)endPoint
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextSetLineWidth(ctx, MC_CENTER_RADIUS);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextMoveToPoint(ctx, startPoint.x, startPoint.y + MC_CENTER_RADIUS);
    CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y + MC_CENTER_RADIUS);
    [_styleColor set];
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);
    
//    UIBezierPath *line = [UIBezierPath bezierPathWithRect:CGRectMake(startPoint.x, startPoint.y, endPoint.x - startPoint.x, MC_CENTER_RADIUS * 2)];
//    [line fill];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
//    if ( !CGRectContainsPoint(_selectCircleRect, touchPoint) || _delegate == nil )
//    {
//        return;
//    }
    _updating = YES;
    CGFloat centerX = touchPoint.x;
    CGFloat percent = centerX / self.bounds.size.width;
    [_delegate movingConvexViewDidUpdatePercent:percent];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    if ( !_updating )
//    {
//        return;
//    }
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat centerX = touchPoint.x;
    CGFloat percent = centerX / self.bounds.size.width;
    NSInteger page = 0;
    if ( percent < 0.25 )
    {
        page = 0;
    }
    else if ( percent > 0.25 && percent < 0.75 )
    {
        page = 1;
    }
    else
    {
        page = 2;
    }
    
    [_delegate movingUpdateToIndex:page];
    _updating = NO;
}

@end
