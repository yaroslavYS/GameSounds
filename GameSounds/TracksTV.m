//
//  TracksTV.m
//  GameSounds
//
//  Created by Deliany Delirium on 26.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "TracksTV.h"
#import "GameSoundsManager.h"
#import "TrackTCV.h"
#import "Tag.h"
#import "Track.h"

@interface TracksTV ()
@property (strong, nonatomic) GameSoundsManager *gameSoundManager;
@end



@implementation TracksTV

- (GameSoundsManager*)gameSoundManager
{
    if (!_gameSoundManager) {
        _gameSoundManager = [[GameSoundsManager alloc] init];
    }
    
    return _gameSoundManager;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.gameSoundManager.tracks count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    TrackTCV *cell = [tableView makeViewWithIdentifier:@"TrackCell" owner:self];
    
    Track *track = self.gameSoundManager.tracks[row];
    cell.titleTextField.stringValue = [track.fileName stringByDeletingPathExtension];
    cell.subTitleTextField.stringValue = [self stringFromFileSize:track.fileSize];
    return cell;
}

- (NSString *)stringFromFileSize:(long long)theSize
{
	float floatSize = theSize;
	if (theSize<1023)
		return([NSString stringWithFormat:@"%lli bytes",theSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f KB",floatSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f MB",floatSize]);
	floatSize = floatSize / 1024;
    
	// Add as many as you like
    
	return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
}

@end
