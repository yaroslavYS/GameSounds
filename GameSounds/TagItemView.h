//
//  TagItemView.h
//  GameSounds
//
//  Created by Deliany Delirium on 30.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TagItemView : NSView

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSImage *image;
@property (readonly, nonatomic) BOOL selected;

@property (strong) NSImageView *tagImageView;
@property (strong) NSTextField *tagNameLabel;

- (void)setSelected:(BOOL)selected;

@end
