//
//  EVTextField.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

//

#import "EVTextField.h"

@implementation EVTextField

- (void)deleteBackward
{
    NSString *beforeDeleteStr = [self.text mutableCopy];
    [super deleteBackward];
    NSString *afterDeleteStr = [self.text mutableCopy];
    
    if ( _customeDelegate && [_customeDelegate respondsToSelector:@selector(backspacePressedBeforeDeleting:afterDeleting:)] )
    {
        [_customeDelegate backspacePressedBeforeDeleting:beforeDeleteStr afterDeleting:afterDeleteStr];
    }
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController)
    {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
