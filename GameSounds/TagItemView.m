//
//  TagItemView.m
//  GameSounds
//
//  Created by Deliany Delirium on 30.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "TagItemView.h"

@interface TagItemView ()
@property (readwrite) BOOL selected;
@end



@implementation TagItemView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    NSRect frame = self.frame;
    CGFloat height = frame.size.height;
    CGFloat width = frame.size.width;
    self.tagNameLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, width, 35)];
    
    [self.tagNameLabel setAlignment:NSCenterTextAlignment];
    [self.tagNameLabel setFont:[NSFont boldSystemFontOfSize:13]];
    [self.tagNameLabel setEditable:NO];
    [self.tagNameLabel setBordered:NO];
    [self.tagNameLabel setDrawsBackground:NO];
    
    [self addSubview:self.tagNameLabel];
    
    
    self.tagImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, height/2, width, 35)];
    self.tagImageView.image = [NSImage imageNamed:@"icon.png"];
    [self addSubview:self.tagImageView];
    
    
    return self;
}

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
