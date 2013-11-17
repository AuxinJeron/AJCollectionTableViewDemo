//
//  ISActionController.m
//  ISCollectionViewTest
//
//  Created by Leon on 11/17/13.
//  Copyright (c) 2013 Leon. All rights reserved.
//

#import "ISActionController.h"

typedef NS_ENUM(NSUInteger, ISActionType)
{
    ISActionTypeAdd = 0,
    ISActionTypeDel,
    ISActionTypeMove,
    ISActionTypeWarning
};

@interface ISActionController() <UIAlertViewDelegate>

@property (nonatomic, assign) ISActionType actionType;

@end

@implementation ISActionController

- (void) showAddItemAlertView
{
    self.actionType = ISActionTypeAdd;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Insert a new item with format [<section>:<row>]." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (void) showDelItemAlertView
{
    self.actionType = ISActionTypeDel;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Remove an item with format [<section>:<row>]." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertView show];
}

- (void) showMoveItemAlertView
{
    self.actionType = ISActionTypeMove;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Move a item with format [<section>:<row>-<section>:<row>]." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertView show];
}

- (void) showInvalidateFormatAlertView
{
    self.actionType = ISActionTypeWarning;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Do not write in a shit format, I don't know how to deal with it" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Property

- (NSIndexPath *) indexPathFromString:(NSString *) aString
{
    NSArray *compoents = [aString componentsSeparatedByString:@":"];
    if (compoents.count != 2)
    {
        //[self showInvalidateFormatAlertView];
        return nil;
    }
    
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
    
    NSNumber *sectionNumber = [numberFormat numberFromString:[compoents objectAtIndex:0]];
    if (sectionNumber == nil)
    {
        //[self showInvalidateFormatAlertView];
        return nil;
    }
    NSNumber *rowNumber = [numberFormat numberFromString:[compoents objectAtIndex:1]];
    if (rowNumber == nil)
    {
        //[self showInvalidateFormatAlertView];
        return nil;
    }
    
    NSInteger section = [[compoents objectAtIndex:0] integerValue];
    NSInteger row = [[compoents objectAtIndex:1] integerValue];
    
    return [NSIndexPath indexPathForItem:row inSection:section];
}

#pragma mark - UIAlertViewDelegate

- (void) alertView:(UIAlertView *) alertView didDismissWithButtonIndex:(NSInteger) buttonIndex
{
    if (buttonIndex == 0)
    {
        return;
    }
    
    switch (self.actionType) {
        case ISActionTypeAdd:
        {
            NSString *stringFormat = [[alertView textFieldAtIndex:0] text];
            NSIndexPath *indexPath = [self indexPathFromString:stringFormat];
            if (indexPath != nil)
            {
                if ([self.delegate respondsToSelector:@selector(actionController:insertItemAtIndexPath:)])
                {
                    [self.delegate actionController:self insertItemAtIndexPath:indexPath];
                }
            }
            else
            {
                [self showInvalidateFormatAlertView];
            }
        }
            break;
        case ISActionTypeDel:
        {
            NSString *stringFormat = [[alertView textFieldAtIndex:0] text];
            NSIndexPath *indexPath = [self indexPathFromString:stringFormat];
            if (indexPath != nil)
            {
                if ([self.delegate respondsToSelector:@selector(actionController:removeItemAtIndexPath:)])
                {
                    [self.delegate actionController:self removeItemAtIndexPath:indexPath];
                }
            }
            else
            {
                [self showInvalidateFormatAlertView];
            }
        }
            break;
        case ISActionTypeMove:
        {
            NSString *stringFormat = [[alertView textFieldAtIndex:0] text];
            NSArray *components = [stringFormat componentsSeparatedByString:@"-"];
            if (components.count == 2)
            {
                NSIndexPath *fromIndexPath = [self indexPathFromString:[components objectAtIndex:0]];
                NSIndexPath *toIndexPath = [self indexPathFromString:[components objectAtIndex:1]];
                if (fromIndexPath != nil && toIndexPath != nil)
                {
                    if ([self.delegate respondsToSelector:@selector(actionController:moveItemFromIndexPath:toIndexPath:)])
                    {
                        [self.delegate actionController:self moveItemFromIndexPath:fromIndexPath toIndexPath:toIndexPath];
                    }
                }
                else
                {
                    [self showInvalidateFormatAlertView];
                }
            }
            else
            {
                [self showInvalidateFormatAlertView];
            }
        }
            break;
        default:
            break;
    }
    
}

@end
