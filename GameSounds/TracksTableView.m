//
//  TracksTV.m
//  GameSounds
//
//  Created by Deliany Delirium on 26.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "TracksTableView.h"
#import "GameSoundsManager.h"
#import "TrackTableCellView.h"
#import "Tag.h"
#import "Track.h"
#import "NSButton+AlternateImage.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVAsset.h>

@interface TracksTableView ()
@property (strong) NSArray *tracks;
@property (weak) IBOutlet NSArrayController *tagsArrayController;
@property (weak) IBOutlet TracksTableView *tracksTable;
@property (weak) IBOutlet NSTextField *tracksCountLabel;
@property (weak) IBOutlet NSTextField *trackNameLabel;


@property (strong) IBOutlet NSButton *playButton;
@property (strong) NSTimer *timer;
@property (nonatomic, strong) AVPlayer *player;
@property (weak) IBOutlet NSSlider *timelineSlider;
@property (weak) IBOutlet NSTextField *timeLabel;
@property (weak) NSButton *lastClickedPlayButton;
@property (nonatomic, getter = isPlaying) BOOL playing;
@end



@implementation TracksTableView

- (GameSoundsManager*)gameSoundManager
{
    if (!_gameSoundManager) {
        _gameSoundManager = [[GameSoundsManager alloc] init];
    }
    
    return _gameSoundManager;
}


- (void)awakeFromNib
{
    [self.tagsArrayController addObserver:self forKeyPath:@"selectionIndexes" options:NSKeyValueObservingOptionNew context:nil];
    
    self.tracks = self.gameSoundManager.tracks;
    self.tracksCountLabel.stringValue = [NSString stringWithFormat:@"(%ld tracks)",[self.tracks count]];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playerItemDidReachEnd:)
     name:AVPlayerItemDidPlayToEndTimeNotification
     object:self.player];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [self.player seekToTime:kCMTimeZero];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualTo:@"selectionIndexes"])
    {
        if([[self.tagsArrayController selectedObjects] count] > 0)
        {
            NSArray *tags = [self.tagsArrayController selectedObjects];
            NSMutableArray *preds = [NSMutableArray arrayWithCapacity:[tags count]];
            for (Tag *tag in tags) {
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"tags.name CONTAINS (%@)", tag.name];
                [preds addObject:pred];
            }
            NSPredicate *pred = [NSCompoundPredicate orPredicateWithSubpredicates:preds];
            self.tracks = [self.gameSoundManager.tracks filteredArrayUsingPredicate:pred];
        }
        else
        {
            self.tracks = self.gameSoundManager.tracks;
        }
        [self.tracksTable reloadData];
        [self.tracksCountLabel setStringValue:[NSString stringWithFormat:@"(%ld tracks)",[self.tracks count]]];
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.tracks count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    TrackTableCellView *cell = [tableView makeViewWithIdentifier:@"TrackCell" owner:self];
    
    Track *track = self.tracks[row];
    cell.titleTextField.stringValue = [track.fileName stringByDeletingPathExtension];
    cell.playButton.tag = cell.downloadButton.tag = row;

    cell.subTitleTextField.stringValue = [track.tags componentsJoinedByString:@", "];;
    cell.sizeTextField.stringValue = [self stringFromFileSize:track.fileSize];
    
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

- (IBAction)playClick:(NSButton *)sender
{
    BOOL otherTrackSelected = NO;
    [self.playButton useAlternateImage];
    if (self.playButton != sender) {
        if (self.lastClickedPlayButton != sender) {
            [self.lastClickedPlayButton useAlternateImage];
            otherTrackSelected = YES;
        }
        self.lastClickedPlayButton = sender;
        [sender useAlternateImage];
    }
    
    NSInteger index = sender.tag;
    
    Track *track = self.tracks[index];
    [self.trackNameLabel setStringValue:[track.fileName stringByDeletingPathExtension]];
    
    if (self.isPlaying == YES) {
        [self.player pause];
        self.playing = NO;
    }
    
    if (self.isPlaying == NO) {
        if (otherTrackSelected) {
            NSError *error;
            NSURL *trackURL = [NSURL URLWithString:track.url];
            self.player = [[AVPlayer alloc] initWithURL:trackURL];
            
            if (self.player == nil)
                NSLog(@"%@",[error description]);
            else
            {
                [self.player play];
                CMTime duration = self.player.currentItem.asset.duration;
                self.timelineSlider.maxValue = CMTimeGetSeconds(duration);
            }
        }
        else {
            [self.player play];
        }
        
        
        self.playing = YES;
    }
}
@end
