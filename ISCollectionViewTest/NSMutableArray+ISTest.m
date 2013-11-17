//
//  NSMutableArray+ISTest.m
//  ISCollectionViewTest
//
//  Created by Leon on 11/17/13.
//  Copyright (c) 2013 Leon. All rights reserved.
//

#import "NSMutableArray+ISTest.h"

@implementation NSMutableArray (ISTest)

- (void) insertObjectAtIndexPath:(NSIndexPath *) indexPath
{
    NSNumber *originNumber = [self objectAtIndex:indexPath.section];
    [self removeObjectAtIndex:indexPath.section];
    [self insertObject:[NSNumber numberWithInteger:originNumber.intValue + 1] atIndex:indexPath.section];
}

- (void) removeObjectAtIndexPath:(NSIndexPath *) indexPath
{
    NSNumber *originNumber = [self objectAtIndex:indexPath.section];
    [self removeObjectAtIndex:indexPath.section];
    if (originNumber.intValue - 1 > 0)
    {
        [self insertObject:[NSNumber numberWithInteger:originNumber.intValue - 1] atIndex:indexPath.section];
    }
}

- (void) moveObjectFromIndexPath:(NSIndexPath *) fromIndexPath toIndexPath:(NSIndexPath *) toIndexPath
{
    [self insertObjectAtIndexPath:toIndexPath];
    [self removeObjectAtIndexPath:fromIndexPath];
}

@end
