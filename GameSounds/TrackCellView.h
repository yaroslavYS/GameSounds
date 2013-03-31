//
//  TrackTCV.h
//  GameSounds
//
//  Created by Deliany Delirium on 25.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TrackCellView : NSTableCellView

@property (weak) IBOutlet NSTextField *titleTextField;
@property (weak) IBOutlet NSTextField *subTitleTextField;
@property (weak) IBOutlet NSButton *downloadButton;
@property (weak) IBOutlet NSTextField *sizeTextField;
@property (weak) IBOutlet NSButton *playButton;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

- (void)hideDownloadButton;
- (void)showDownloadButton;

@end
