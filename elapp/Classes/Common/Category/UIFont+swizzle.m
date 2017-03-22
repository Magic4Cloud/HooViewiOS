//
//  UIFont+swizzle.m
//  Test
//
//  Created by Jacqui on 2017/3/21.
//  Copyright © 2017年 Jugg. All rights reserved.
//

#import "UIFont+swizzle.h"
#import <objc/runtime.h>

@implementation UIFont (swizzle)
+ (void)load
{
    NSString *version = [UIDevice currentDevice].systemVersion;
    
    if (version.doubleValue < 9) {
        return;
    }
    NSDictionary *map =@{@0:@"1.021",
                         
                         @1:@"1.022",
                         
                         @2:@"1.022",
                         
                         @3:@"1.022",
                         
                         @4:@"1.022",
                         
                         @5:@"1.022",
                         
                         @6:@"1.022",
                         
                         @7:@"1.022",
                         
                         @8:@"1.022",
                         
                         @9:@"1.022",
                         
                         @10:@"1.022",
                         
                         @11:@"1.022",
                         
                         @12:@"1.021",
                         
                         @13:@"1.020",
                         
                         @14:@"1.020",
                         
                         @15:@"1.020",
                         
                         @16:@"1.020",
                         
                         @17:@"1.019",
                         
                         @18:@"1.019",
                         
                         @19:@"1.019",
                         
                         @20:@"1.019",
                         
                         @21:@"1.016",
                         
                         @22:@"1.013",
                         
                         @23:@"1.013",
                         
                         @24:@"1.013",
                         
                         @25:@"1.013",
                         
                         @26:@"1.013",
                         
                         @27:@"1.013",
                         
                         @28:@"1.013",
                         
                         @29:@"1.012",
                         
                         @30:@"1.011",
                         
                         @31:@"1.010",
                         
                         @32:@"1.009",
                         
                         @33:@"1.008",
                         
                         @34:@"1.008",
                         
                         @35:@"1.008",
                         
                         @36:@"1.008",
                         
                         @37:@"1.007",
                         
                         @38:@"1.007",
                         
                         @39:@"1.007",
                         
                         @40:@"1.006",
                         
                         @41:@"1.006",
                         
                         @42:@"1.006",
                         
                         @43:@"1.006",
                         
                         @44:@"1.005",
                         
                         @45:@"1.005",
                         
                         @46:@"1.005",
                         
                         @47:@"1.004"};
    
    
    
    objc_setAssociatedObject([UIFont class], @selector(swizzle_systemFontOfSize:), map,OBJC_ASSOCIATION_RETAIN);
    
    Method original =class_getClassMethod([UIFont class], @selector(systemFontOfSize:));
    
    Method modified =class_getClassMethod([UIFont class], @selector(swizzle_systemFontOfSize:));
    
    method_exchangeImplementations(original, modified);
    
    //swizzle the other convenient method such as: -boldSystemFontOfSize:...
    
}



+ (UIFont *)swizzle_systemFontOfSize:(CGFloat)fontSize

{
    
    NSDictionary *map =objc_getAssociatedObject([UIFont class], @selector(swizzle_systemFontOfSize:));
    
    CGFloat fitSize =ceil(fontSize);
    
    CGFloat proportion = ((NSString *)map[[NSNumber numberWithDouble:fitSize]]).floatValue;
    
    // font size over 47 get 1.004 of the proportion.
    
    if (proportion ==0.0) {
        
        proportion = 1.004;
        
    }
    
    // 12 as default.
    
    fontSize = fontSize?:12;
    
    fontSize = fontSize/proportion;
    
    return [[UIFont class] swizzle_systemFontOfSize:fontSize];
    
}
@end
