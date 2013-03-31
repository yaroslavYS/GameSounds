//
//  TagItemView.h
//  GameSounds
//
//  Created by Deliany Delirium on 30.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TagItemView : NSView

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSImage *image;

@property (weak) IBOutlet NSImageView *tagImageView;
@property (weak) IBOutlet NSTextField *tagNameLabel;

- (void)setSelected:(BOOL)selected;

@end
