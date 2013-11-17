//
//  ISTableViewController.m
//  ISCollectionViewTest
//
//  Created by Leon on 11/17/13.
//  Copyright (c) 2013 Leon. All rights reserved.
//

#import "ISTableViewController.h"
#import "NSMutableArray+ISTest.h"
#import "ISActionController.h"

@interface ISTableViewController () <UITableViewDataSource, UITableViewDelegate, ISActionControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong)  ISActionController *actionController;
// actionInvocation is used to keep the action(insert, remove, move) retrieved from acionController, and can be invoked by user later
@property (nonatomic, strong) NSInvocation *actionInvocation;

@end

@implementation ISTableViewController

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
    self.dataSource = [NSMutableArray arrayWithArray:@[@(1), @(2), @(3)]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"Header"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.actionController = [[ISActionController alloc] init];
    self.actionController.delegate = self;
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section
{
    return [[self.dataSource objectAtIndex:section] intValue];
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"Row: %d", indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
    return self.dataSource.count;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger) section
{
    return [NSString stringWithFormat:@"Section: %d", section];
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *) tableView heightForHeaderInSection:(NSInteger) section
{
    return 40.0f;
}

- (UIView *) tableView:(UITableView *) tableView viewForHeaderInSection:(NSInteger) section
{
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    return view;
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
}

- (void) removeItemAtIndexPath:(NSIndexPath *) indexPath
{
    NSLog(@"Remove item at section: %d row: %d", indexPath.section, indexPath.row);
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






