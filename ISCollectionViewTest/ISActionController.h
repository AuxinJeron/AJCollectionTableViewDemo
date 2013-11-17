//
//  ISActionController.h
//  ISCollectionViewTest
//
//  Created by Leon on 11/17/13.
//  Copyright (c) 2013 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISActionControllerDelegate;

@interface ISActionController : NSObject

@property (nonatomic, weak) id<ISActionControllerDelegate> delegate;

- (void) showAddItemAlertView;
- (void) showDelItemAlertView;
- (void) showMoveItemAlertView;

@end

@protocol ISActionControllerDelegate <NSObject>

@optional

- (void) actionController:(ISActionController *) controller insertItemAtIndexPath:(NSIndexPath *) indexPath;
- (void) actionController:(ISActionController *) controller removeItemAtIndexPath:(NSIndexPath *) indexPath;
- (void) actionController:(ISActionController *) controller moveItemFromIndexPath:(NSIndexPath *) fromIndexPath toIndexPath:(NSIndexPath *) toIndexPath;

@end
