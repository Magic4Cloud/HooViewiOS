//
//  EVSearchTextField.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
@class EVFriendItem;

@protocol EVSearchTextFieldDelegate <NSObject>

@optional
- (void)searchTextFieldDidChangeLeftView:(CGRect)frame;
- (void)searchTextFieldDidCancelItem:(EVFriendItem *)item;

@end

@interface EVSearchTextField : UITextField

@property (nonatomic, assign) BOOL beginEdit;

@property (nonatomic,weak) id<EVSearchTextFieldDelegate> searchDelegate;

- (void)insertFriendItem:(EVFriendItem *)item;
- (void)deleteFriendItem:(EVFriendItem *)item;

- (BOOL)deleteLastItem;


@end
