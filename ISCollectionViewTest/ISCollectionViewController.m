//
//  ISCollectionViewController.m
//  ISCollectionViewTest
//
//  Created by Leon on 11/17/13.
//  Copyright (c) 2013 Leon. All rights reserved.
//

#import "ISCollectionViewController.h"
#import "NSMutableArray+ISTest.h"
#import "ISActionController.h"

@interface ISCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ISActionControllerDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ISActionController *actionController;
// actionInvocation is used to keep the action(insert, remove, move) retrieved from acionController, and can be invoked by user later
@property (nonatomic, strong) NSInvocation *actionInvocation;

@end

@implementation ISCollectionViewController

- (id) initWithNibName:(NSString *) nibNameOrNil bundle:(NSBundle *) nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.dataSource = [NSMutableArray arrayWithArray:@[@(1), @(2), @(8), @(5)]];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    self.actionController = [[ISActionController alloc] init];
    self.actionController.delegate = self;
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) collectionView:(UICollectionView *) collectionView numberOfItemsInSection:(NSInteger) section
{
    return [[self.dataSource objectAtIndex:section] intValue];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *) collectionView cellForItemAtIndexPath:(NSIndexPath *) indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.text = [NSString stringWithFormat:@"%d", indexPath.row];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    
    [cell.contentView addSubview:label];
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *) collectionView
{
    return self.dataSource.count;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *) collectionView viewForSupplementaryElementOfKind:(NSString *) kind atIndexPath:(NSIndexPath *) indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 40)];
    label.text = [NSString stringWithFormat:@"Section: %d", indexPath.section];
    label.font = [UIFont systemFontOfSize:15];
    
    [view addSubview:label];
    
    return view;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets) collectionView:(UICollectionView *) collectionView layout:(UICollectionViewLayout *) collectionViewLayout insetForSectionAtIndex:(NSInteger) section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGSize) collectionView:(UICollectionView *) collectionView layout:(UICollectionViewLayout *) collectionViewLayout referenceSizeForHeaderInSection:(NSInteger) section
{
    return CGSizeMake(320, 40);
}

- (CGSize) collectionView:(UICollectionView *) collectionView layout:(UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *) indexPath
{
    return CGSizeMake(50, 50);
}

- (CGFloat) collectionView:(UICollectionView *) collectionView layout:(UICollectionViewLayout *) collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger) section
{
    return 5;
}

#pragma mark - Action

- (IBAction) addItem:(id) sender
{
    [self.actionController showAddItemAlertView];
}

- (IBAction) delItem:(id) sender
{
    [self.actionController showDelItemAlertView];
}

- (IBAction) moveItem:(id) sender
{
    [self.actionController showMoveItemAlertView];
}

- (IBAction) beginAnimation:(id) sender
{
    [self.actionInvocation invoke];
    self.actionInvocation = nil;
}

- (void) insertItemAtIndexPath:(NSIndexPath *) indexPath
{
    NSLog(@"Insert item at section: %d row: %d", indexPath.section, indexPath.row);
    
    [self.dataSource insertObjectAtIndexPath:indexPath];
    
    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
}

- (void) removeItemAtIndexPath:(NSIndexPath *) indexPath
{
    NSLog(@"Remove item at section: %d row: %d", indexPath.section, indexPath.row);
    
    [self.dataSource removeObjectAtIndexPath:indexPath];
    
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (void) moveItemFromIndexPath:(NSIndexPath *) fromIndexPath toIndexPath:(NSIndexPath *) toIndexPath
{
    NSLog(@"Move item from section: %d row: %d to section: %d row: %d", fromIndexPath.section, fromIndexPath.row, toIndexPath.section, toIndexPath.row);
}

#pragma mark - ISActionControllerDelegate

- (void) actionController:(ISActionController *) controller insertItemAtIndexPath:(NSIndexPath *) indexPath
{
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:@selector(insertItemAtIndexPath:)];
    self.actionInvocation = [NSInvocation invocationWithMethodSignature:sig];
    [self.actionInvocation setTarget:self];
    [self.actionInvocation setSelector:@selector(insertItemAtIndexPath:)];
    [self.actionInvocation setArgument:&indexPath atIndex:2];
    [self.actionInvocation retainArguments];
}

- (void) actionController:(ISActionController *) controller removeItemAtIndexPath:(NSIndexPath *) indexPath
{
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:@selector(removeItemAtIndexPath:)];
    self.actionInvocation = [NSInvocation invocationWithMethodSignature:sig];
    [self.actionInvocation setTarget:self];
    [self.actionInvocation setSelector:@selector(removeItemAtIndexPath:)];
    [self.actionInvocation setArgument:&indexPath atIndex:2];
    [self.actionInvocation retainArguments];
}

- (void) actionController:(ISActionController *) controller moveItemFromIndexPath:(NSIndexPath *) fromIndexPath toIndexPath:(NSIndexPath *) toIndexPath
{
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:@selector(moveItemFromIndexPath:toIndexPath:)];
    self.actionInvocation = [NSInvocation invocationWithMethodSignature:sig];
    [self.actionInvocation setTarget:self];
    [self.actionInvocation setSelector:@selector(moveItemFromIndexPath:toIndexPath:)];
    [self.actionInvocation setArgument:&fromIndexPath atIndex:2];
    [self.actionInvocation setArgument:&toIndexPath atIndex:3];
    [self.actionInvocation retainArguments];
}

@end

   
   
   
   

