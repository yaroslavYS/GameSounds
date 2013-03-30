//
//  TagCollectionView.m
//  GameSounds
//
//  Created by Deliany Delirium on 30.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "TagCollectionView.h"
#import "TagItemView.h"

@interface TagCollectionView ()
@property (strong) NSIndexSet *currentSelection;
@end

@implementation TagCollectionView

- (NSCollectionViewItem *)newItemForRepresentedObject:(id)object
{
    // Let the parent class create the item
    NSCollectionViewItem *item = [super newItemForRepresentedObject:object];
    // Now we need the view so we can create bindings between it and the object.
    
    
    NSView *view = [item view];
    
    
    [view bind:@"name" toObject:object withKeyPath:@"name" options:nil];
    [view bind:@"image" toObject:[NSImage imageNamed:@"icon.png"] withKeyPath:@"self" options:nil];
    
    
    return item;
}

- (void)setSelectionIndexes:(NSIndexSet *)indexes
{
    [super setSelectionIndexes:indexes];
    
    [self.currentSelection enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        if (idx < [[self content] count]) {
            NSCollectionViewItem *item = [self itemAtIndex:idx];
            TagItemView *view = (TagItemView *)[item view];
            [view setSelected:NO];
        }      
    }];
    
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSCollectionViewItem *item = [self itemAtIndex:idx];
        TagItemView *view = (TagItemView *)[item view];
        [view setSelected:YES];
    }];
    
    
    self.currentSelection = indexes;
}

@end
