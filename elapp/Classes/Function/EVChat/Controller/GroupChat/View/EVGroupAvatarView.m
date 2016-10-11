//
//  EVGroupAvatarView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVGroupAvatarView.h"

#define AvatarGap               2 //头像间距
#define Mode4AvatarWidth        (self.frame.size.width-3*AvatarGap)/2  //4模式下头像大小
#define Mode9AvatarWidth        (self.frame.size.width-4*AvatarGap)/3  //9模式下头像大小

@interface EVGroupAvatarView ()

@property (nonatomic, strong) NSMutableArray * positionFor4ModeImage;
@property (nonatomic, strong) NSMutableArray * positionFor9ModeImage;
@property (nonatomic, strong) NSArray *avatarArray;

@end

@implementation EVGroupAvatarView

- (instancetype)initWithFrame:(CGRect)frame avatarArray:(NSArray *)avatarArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.avatarArray = avatarArray;
        [self initImagePosition];
    }
    
    return self;
}

- (void)initImagePosition {
    //初始化4张图片模式和9张图片模式
    for(int i = 0; i < 9; i++){
        CGRect tempMode4Rect;
        CGRect tempMode9Rect;
        float mode4PositionX = 0;
        float mode4PositionY = 0;
        float mode9PositionX = 0;
        float mode9PositionY = 0;
        
        switch (i) {
            case 0:
                mode4PositionX = AvatarGap;
                mode4PositionY = AvatarGap;
                mode9PositionX = AvatarGap;
                mode9PositionY = AvatarGap;
                break;
            case 1:
                mode4PositionX = 2*AvatarGap+Mode4AvatarWidth;
                mode4PositionY = AvatarGap;
                mode9PositionX = 2*AvatarGap+Mode9AvatarWidth;
                mode9PositionY = AvatarGap;
                break;
            case 2:
                mode4PositionX = AvatarGap;
                mode4PositionY = 2*AvatarGap+Mode4AvatarWidth;;
                mode9PositionX = 3*AvatarGap+2*Mode4AvatarWidth;
                mode9PositionY = AvatarGap;
                break;
            case 3:
                mode4PositionX = 2*(AvatarGap+Mode4AvatarWidth);
                mode4PositionY = 2*(AvatarGap+Mode4AvatarWidth);
                mode9PositionX = AvatarGap;
                mode9PositionY = 2*AvatarGap+Mode9AvatarWidth;
                break;
            case 4:
                mode9PositionX = 2*AvatarGap+Mode9AvatarWidth;
                mode9PositionY = 2*AvatarGap+Mode9AvatarWidth;
                break;
            case 5:
                mode9PositionX = 3*AvatarGap+2*Mode9AvatarWidth;
                mode9PositionY = 2*AvatarGap+Mode9AvatarWidth;
                break;
            case 6:
                mode9PositionX = AvatarGap;
                mode9PositionY = 3*AvatarGap+2*Mode9AvatarWidth;
                break;
            case 7:
                mode9PositionX = 2*AvatarGap+Mode9AvatarWidth;
                mode9PositionY = 3*AvatarGap+2*Mode9AvatarWidth;
                break;
            case 8:
                mode9PositionX = 3*AvatarGap+2*Mode9AvatarWidth;
                mode9PositionY = 3*AvatarGap+2*Mode9AvatarWidth;
                break;
            default:
                break;
        }
        
        //添加4模式图片坐标到数组
        if (i < 4 ){
            tempMode4Rect = CGRectMake(mode4PositionX, mode4PositionY, Mode4AvatarWidth, Mode4AvatarWidth);
            [_positionFor4ModeImage addObject:[NSValue valueWithCGRect:tempMode4Rect]];
        }
        
        //添加9模式图片坐标到数组
        tempMode9Rect = CGRectMake(mode9PositionX, mode9PositionY, Mode9AvatarWidth, Mode9AvatarWidth);
        [_positionFor9ModeImage addObject:[NSValue valueWithCGRect:tempMode9Rect]];
    }
}



- (UIImage *)getAvatarImage
{
    return [self makeGroupAvatar:self.avatarArray];
}

- (UIImage *)makeGroupAvatar: (NSArray *)imageArray
{
    if ([imageArray count] == 0){
        return nil;
    }
    
    UIView *groupAvatarView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    groupAvatarView.backgroundColor = [UIColor lightGrayColor];
    
    for (int i = 0; i < [imageArray count]; i++){
        UIImageView *tempImageView;
        if ([imageArray count] < 5){
            tempImageView = [[UIImageView alloc]initWithFrame:[[_positionFor4ModeImage objectAtIndex:i]CGRectValue]];
        }
        else{
            tempImageView = [[UIImageView alloc]initWithFrame:[[_positionFor9ModeImage objectAtIndex:i]CGRectValue]];
        }
        [tempImageView cc_setImageWithURLString:self.avatarArray[i] placeholderImage:nil];
        [groupAvatarView addSubview:tempImageView];
    }
    
    //把UIView设置为image并修改图片大小
    UIImage *reImage = [self scaleToSize:[self convertViewToImage:groupAvatarView]size:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    
    return reImage;
}

-(UIImage*)convertViewToImage:(UIView*)v
{
    
    CGSize s = v.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
    
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)imageWithLogourlArray:(NSArray *)array
{
    EVGroupAvatarView *view = [[EVGroupAvatarView alloc] initWithFrame:CGRectMake(0, 0, 40, 40) avatarArray:array];
    return view.getAvatarImage;
}

@end
