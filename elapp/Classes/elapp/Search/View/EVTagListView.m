//
//  EVTagListView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVTagListView.h"
#import "EVUserTagsModel.h"

@interface EVTagListView ()
//{
//     NSArray *disposeAry;
//}
@property (nonatomic,assign) BOOL isFirst;//第一加载


@end

@implementation EVTagListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = YES;
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        _isFirst = YES;
        _tagSpace = 20.;
        _tagHeight = 30.0;
        _borderColor = [UIColor evTextColorH2];
        _borderWidth = 0.5f;
        _masksToBounds = YES;
        _cornerRadius = 2.0;
        _titleSize = 16;
        _tagOriginX = 15;
        _tagOriginY = 18;
        _tagHorizontalSpace = 10;
        _tagVerticalSpace = 12;
        _titleColor = [UIColor evTextColorH2];
        _normalBackgroundImage = [self imageWithColor:[UIColor whiteColor] size:CGSizeMake(1.0, 1.0)];
        _highlightedBackgroundImage = [self imageWithColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0] size:CGSizeMake(1.0, 1.0)];
    }
    return self;
}

//设置标签数据和代理
- (void)reloadData {
//    _tagDelegate = delegate;
    //先移除之前的View
    if (self.subviews.count > 0) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
   NSArray *disposeAry = [self disposeTags:_tagAry];

    if (disposeAry.count < 2) {
        return;
    }
    NSArray *tagArray = disposeAry[0];
    NSArray *modelAry = disposeAry[1];
    //遍历标签数组,将标签显示在界面上,并给每个标签打上tag加以区分

    for (NSInteger i = 0 ; i < tagArray.count; i++) {
        NSArray *iTags = tagArray[i];
        NSMutableArray *xAry = modelAry[i];
        for (NSInteger j = 0; j < iTags.count; j++) {
            NSDictionary *tagDic = iTags[j];
            EVUserTagsModel *userTagsModel = [xAry objectAtIndex:j];

            NSString *tagTitle = userTagsModel.tagname;
            float originX = [tagDic[@"originX"] floatValue];
            float buttonWith = [tagDic[@"buttonWith"] floatValue];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(originX, _tagOriginY+i*(_tagHeight+_tagVerticalSpace), buttonWith, _tagHeight);
            button.layer.borderColor = _borderColor.CGColor;
            button.layer.borderWidth = _borderWidth;
            button.layer.masksToBounds = _masksToBounds;
            button.layer.cornerRadius = _cornerRadius;
            button.titleLabel.font = [UIFont systemFontOfSize:_titleSize];
            [button setTitle:tagTitle forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
            [button setTitleColor:_titleColor forState:UIControlStateNormal];
            button.tag = userTagsModel.tagid + 8000;
            if (userTagsModel.tagSelect == YES) {
                button.selected = YES;
                [button setBackgroundColor:[UIColor hvPurpleColor]];
                [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            }else {
                [button setBackgroundColor:[UIColor whiteColor]];
                [button setTitleColor:[UIColor evTextColorH2] forState:(UIControlStateNormal)];
            }
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:button];
        }

    }

    
    if (tagArray.count > 0) {
        if (_type == 0) {
            //多行
            float contentSizeHeight = _tagOriginY+tagArray.count*(_tagHeight+_tagVerticalSpace)+6;
            self.contentSize = CGSizeMake(self.frame.size.width,contentSizeHeight);
             self.frame = CGRectMake(CGRectGetMinX([self frame]), CGRectGetMinY([self frame]), CGRectGetWidth([self frame]), [self getDisposeTagsViewHeight:tagArray]);
        } else if (_type == 1) {
            //单行
            NSArray *a = tagArray[0];
            NSDictionary *tagDic = a[a.count-1];
            float originX = [tagDic[@"originX"] floatValue];
            float buttonWith = [tagDic[@"buttonWith"] floatValue];
            self.contentSize = CGSizeMake(originX+buttonWith+_tagOriginX,self.frame.size.height);
        }
    }
    
    //多行
    if (self.frame.size.height <= 0) {
        self.frame = CGRectMake(CGRectGetMinX([self frame]), CGRectGetMinY([self frame]), CGRectGetWidth([self frame]), [self getDisposeTagsViewHeight:tagArray]);
    } else {
        if (_type == 0) {
            if (self.frame.size.height > self.contentSize.height) {
                self.frame = CGRectMake(CGRectGetMinX([self frame]), CGRectGetMinY([self frame]), CGRectGetWidth([self frame]), self.contentSize.height);
            }
        }
    }
}

//将标签数组根据type以及其他参数进行分组装入数组
- (NSArray *)disposeTags:(NSArray *)ary {
    NSMutableArray *tags = [NSMutableArray new];//纵向数组
    NSMutableArray *subTags = [NSMutableArray new];//横向数
    NSMutableArray *modelTags = [NSMutableArray new];//纵向数组
    NSMutableArray *modelSubTags = [NSMutableArray new];//横向数
    NSMutableArray *allAry = [NSMutableArray new];
    float originX = _tagOriginX;
    for (EVUserTagsModel *model in ary) {
        NSString *tagTitle = [NSString stringWithFormat:@"%@",model.tagname];
        NSUInteger index = [ary indexOfObject:model];
        //计算每个tag的宽度
        CGSize contentSize = [tagTitle fdd_sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(ScreenWidth-50, MAXFLOAT)];
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        dict[@"tagTitle"] = tagTitle;//标签标题
        dict[@"buttonWith"] = [NSString stringWithFormat:@"%f",contentSize.width+20];//标签的宽度
        
        if (index == 0) {
            dict[@"originX"] = [NSString stringWithFormat:@"%f",originX];//标签的X坐标
            [subTags addObject:dict];
            [modelSubTags addObject:model];
        } else {
            if (_type == 0) {
                //多行
                if (originX + contentSize.width > self.frame.size.width-_tagOriginX*2) {
                    //当前标签的X坐标+当前标签的长度>屏幕的横向总长度则换行
                    [tags addObject:subTags];
                    [modelTags addObject:modelSubTags];
                    //换行标签的起点坐标初始化
                    originX = _tagOriginX;
                    dict[@"originX"] = [NSString stringWithFormat:@"%f",originX];//标签的X坐标
                    subTags = [NSMutableArray new];
                    modelSubTags = [NSMutableArray new];
                    [subTags addObject:dict];
                    [modelSubTags addObject:model];
                } else {
                    //如果没有超过屏幕则继续加在前一个数组里
                    dict[@"originX"] = [NSString stringWithFormat:@"%f",originX];//标签的X坐标
                    [subTags addObject:dict];
                    [modelSubTags addObject:model];
                }
            } else {
                //一行
                dict[@"originX"] = [NSString stringWithFormat:@"%f",originX];//标签的X坐标
                [subTags addObject:dict];
                [modelSubTags addObject:model];
            }
        }
        
        if (index +1 == ary.count) {
            //最后一个标签加完将横向数组加到纵向数组中
            [tags addObject:subTags];
            [modelTags addObject:modelSubTags];
            if (ary.count > 0) {
                [allAry addObject:tags];
                [allAry addObject:modelTags];
            }
            return allAry;
        }
        
        //标签的X坐标每次都是前一个标签的宽度+标签左右空隙+标签距下个标签的距离
        originX += contentSize.width+_tagHorizontalSpace+_tagSpace;
    }
    [tags addObject:subTags];
    [modelTags addObject:modelSubTags];
    if (ary.count > 0) {
        [allAry addObject:tags];
        [allAry addObject:modelTags];
    }
    return allAry;
}

//获取处理后的tagsView的高度根据标签的数组
- (float)getDisposeTagsViewHeight:(NSArray *)ary {
    
    float height = 0;
    if (ary.count > 0) {
        if (_type == 0) {
            height = _tagOriginY+ary.count*(_tagHeight+_tagVerticalSpace)+6;
        } else if (_type == 1) {
            height = _tagOriginY+_tagHeight+_tagVerticalSpace;
        }
    }
    return height;
}

- (void)buttonAction:(UIButton *)sender {

    
    if (self.selectTagAry.count >= 3 && sender.selected == NO) {
        [EVProgressHUD showMessage:@"最多选3个"];
        return;
    }
    sender.selected = !sender.selected;
    
    
    if (sender.selected == YES) {
        for (NSInteger i = 0; i < _tagAry.count; i++) {
            EVUserTagsModel *userTagsModel = _tagAry[i];
            if (userTagsModel.tagid == (sender.tag - 8000)) {
                [self.selectTagAry addObject:userTagsModel];
            }
        }
        
        [sender setBackgroundColor:[UIColor hvPurpleColor]];
        [sender setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    }else {
        for (NSInteger i = 0; i < self.selectTagAry.count; i++) {
            EVUserTagsModel *userTagsModel = self.selectTagAry[i];
            if (userTagsModel.tagid == (sender.tag - 8000)) {
                [self.selectTagAry removeObject:userTagsModel];
                continue;
            }
        }
        
        [sender setBackgroundColor:[UIColor whiteColor]];
        [sender setTitleColor:[UIColor evTextColorH2] forState:(UIControlStateNormal)];
    }
    if (_tagDelegate && [_tagDelegate respondsToSelector:@selector(tagsViewButtonAction:button:)]) {
        [_tagDelegate tagsViewButtonAction:self button:sender];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_isFirst) {
        _isFirst = NO;
        [self reloadData];
    }
}


//颜色生成图片方法
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,
                                   
                                   color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSMutableArray *)selectTagAry
{
    if (!_selectTagAry) {
        _selectTagAry = [NSMutableArray array];
    }
    return _selectTagAry;
}

@end

#pragma mark - 扩展方法

@implementation NSString (CCExtention)

- (CGSize)fdd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    CGSize resultSize;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        NSStringDrawingContext *context;
        [invocation setArgument:&size atIndex:2];
        [invocation setArgument:&options atIndex:3];
        [invocation setArgument:&attributes atIndex:4];
        [invocation setArgument:&context atIndex:5];
        [invocation invoke];
        CGRect rect;
        [invocation getReturnValue:&rect];
        resultSize = rect.size;
    } else {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(sizeWithFont:constrainedToSize:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(sizeWithFont:constrainedToSize:)];
        [invocation setArgument:&font atIndex:2];
        [invocation setArgument:&size atIndex:3];
        [invocation invoke];
        [invocation getReturnValue:&resultSize];
    }
    return resultSize;
}

@end

