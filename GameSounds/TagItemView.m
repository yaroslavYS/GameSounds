//
//  TagItemView.m
//  GameSounds
//
//  Created by Deliany Delirium on 30.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "TagItemView.h"

@interface TagItemView ()
@property (nonatomic) BOOL selected;
@end



@implementation TagItemView

- (void)drawRect:(NSRect)dirtyRect
{
    if (self.selected) {
        [[NSColor selectedControlColor] set];
        NSRectFill(dirtyRect);
    }
}

- (void)setName:(NSString *)name
{    
    _name = name;
    
    [self.tagNameLabel setStringValue:name];
}

- (void)setImage:(NSImage *)image
{
    _image = image;
    
    [self.tagImageView setImage:image];
}

- (void)setSelected:(BOOL)selected
{
    if (_selected == selected) {
        return;
    }
    
    _selected = selected;
    [self setNeedsDisplay:YES];
}

@end
