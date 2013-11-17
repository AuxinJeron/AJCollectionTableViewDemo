//
//  ISViewController.m
//  ISCollectionViewTest
//
//  Created by Leon on 11/13/13.
//  Copyright (c) 2013 Leon. All rights reserved.
//

#import "ISViewController.h"

@interface ISViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger indexCount;
@property (nonatomic, assign) NSInteger sectionCount;

@end

@implementation ISViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"supplementView"];
    
    self.indexCount = 10;
    self.sectionCount = 1;
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction) addIndex:(id) sender
{
    self.indexCount ++;
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:4 inSection:0]]];
        //[self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:5 inSection:1]]];
    } completion:^(BOOL finished) {
        
    }];;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) collectionView:(UICollectionView *) collectionView numberOfItemsInSection:(NSInteger) section
{
    return self.indexCount;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *) collectionView cellForItemAtIndexPath:(NSIndexPath *) indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor redColor];
    return cell;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *) collectionView
{
    return self.sectionCount;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *) collectionView viewForSupplementaryElementOfKind:(NSString *) kind atIndexPath:(NSIndexPath *) indexPath
{
    UICollectionReusableView *supplementary = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"supplementView" forIndexPath:indexPath];
    supplementary.backgroundColor = [UIColor blueColor];
    return supplementary;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize) collectionView:(UICollectionView *) collectionView layout:(UICollectionViewLayout *) collectionViewLayout referenceSizeForHeaderInSection:(NSInteger) section
{
    return CGSizeMake(320, 40);
}

- (CGFloat) collectionView:(UICollectionView *) collectionView layout:(UICollectionViewLayout *) collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger) section
{
    return 5;
}

- (CGSize) collectionView:(UICollectionView *) collectionView layout:(UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *) indexPath
{
    return CGSizeMake(50, 50);
}

@end
















