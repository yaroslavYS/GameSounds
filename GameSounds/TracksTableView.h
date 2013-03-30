//
//  TracksTV.h
//  GameSounds
//
//  Created by Deliany Delirium on 26.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GameSoundsManager;

@interface TracksTableView : NSTableView <NSTableViewDataSource,NSTableViewDelegate>

@property (strong, nonatomic) GameSoundsManager *gameSoundManager;

- (IBAction)playClick:(NSButton *)sender;

@end
