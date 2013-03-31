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
