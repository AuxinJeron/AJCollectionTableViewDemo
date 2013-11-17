//
//  ISTagDataSource.m
//  ISCollectionViewTest
//
//  Created by Leon on 11/17/13.
//  Copyright (c) 2013 Leon. All rights reserved.
//

#import "ISTagDataSource.h"

@interface ISTagDataSource ()

@property (nonatomic, strong) NSMutableDictionary *tags;
@property (nonatomic, strong) NSMutableArray *sections;

@end

@implementation ISTagDataSource

- (id) initWithArray:(NSArray *) array
{
    self = [super init];
    if (self)
    {
        for (NSString *tag in array)
        {
            [self addTag:tag];
        }
    }
    return self;
}

#pragma mark - Property

- (NSMutableDictionary *) tags
{
    if (_tags != nil)
    {
        return _tags;
    }
    
    _tags = [NSMutableDictionary dictionaryWithCapacity:10];
    
    return _tags;
}

- (NSMutableArray *) sections
{
    if (_sections != nil)
    {
        return _sections;
    }
    
    _sections = [NSMutableArray arrayWithCapacity:10];
    return _sections;
}

- (BOOL) isSectionExisted:(NSString *) section
{
    for (NSString *existedSection in self.sections)
    {
        if ([existedSection isEqualToString:section])
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Aciton

- (void) addTag:(NSString *) tag
{
    if (tag.length <= 0)
    {
        return;
    }
    
    NSString *key = [tag substringToIndex:1];
    if ([self isSectionExisted:key] == NO)
    {
        [self addSection:key];
    }
    
    [self addTag:tag toSection:key];
}

- (void) addTag:(NSString *) tag toSection:(NSString *) section
{
    NSMutableArray *array = [self.tags objectForKey:section];
    NSInteger index = 0;
    
    for (index = 0; index < array.count; index ++)
    {
        if ([[array objectAtIndex:index] compare:tag options:NSNumericSearch] == NSOrderedAscending)
        {
            break;
        }
    }
    
    [[self.tags objectForKey:section] insertObject:tag atIndex:index];
}

- (void) addSection:(NSString *) section
{
    NSInteger index = 0;
    for (NSInteger index = 0; index < self.sections.count; index ++)
    {
        if ([[self.sections objectAtIndex:index] compare:section options:NSNumericSearch] == NSOrderedAscending)
        {
            break;
        }
    }
    [self.sections insertObject:section atIndex:index];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    [self.tags setObject:array forKey:section];
}

@end










