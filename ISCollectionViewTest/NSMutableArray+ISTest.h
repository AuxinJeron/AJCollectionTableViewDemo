//
//  NSMutableArray+ISTest.h
//  ISCollectionViewTest
//
//  Created by Leon on 11/17/13.
//  Copyright (c) 2013 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (ISTest)

- (void) insertObjectAtIndexPath:(NSIndexPath *) indexPath;
- (void) removeObjectAtIndexPath:(NSIndexPath *) indexPath;
- (void) moveObjectFromIndexPath:(NSIndexPath *) fromIndexPath toIndexPath:(NSIndexPath *) toIndexPath;

@end
