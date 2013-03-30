//
//  TracksTV.m
//  GameSounds
//
//  Created by Deliany Delirium on 26.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVAsset.h>

#import "TracksTableView.h"
#import "GameSoundsManager.h"
#import "TrackTableCellView.h"
#import "Tag.h"
#import "Track.h"
#import "NSButton+AlternateImage.h"

@interface TracksTableView ()
@property (weak) IBOutlet NSArrayController *tagsArrayController;
@property (weak) IBOutlet TracksTableView *tracksTableView;
@property (weak) IBOutlet NSTextField *tracksCountLabel;
@property (weak) IBOutlet NSTextField *trackNameLabel;
@property (weak) IBOutlet NSArrayController *tracksArrayController;

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) NSTimer *timer;

@property (weak) IBOutlet NSSlider *seekSlider;
@property (weak) IBOutlet NSTextField *currentTimeLabel;
@property (weak) IBOutlet NSSlider *volumeSlider;

@property (weak) NSButton *lastClickedPlayButton;
@property (nonatomic) BOOL isPlaying;
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
    
    self.filteredTracks = self.gameSoundManager.tracks;
    self.tracksCountLabel.stringValue = [NSString stringWithFormat:@"(%ld tracks)",[self.filteredTracks count]];
    
    
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
            self.filteredTracks = [self.gameSoundManager.tracks filteredArrayUsingPredicate:pred];
        }
        else
        {
            self.filteredTracks = self.gameSoundManager.tracks;
        }
        [self.tracksTableView reloadData];
        [self.tracksCountLabel setStringValue:[NSString stringWithFormat:@"(%ld tracks)",[self.filteredTracks count]]];
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.filteredTracks count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    TrackTableCellView *cell = [tableView makeViewWithIdentifier:@"TrackCell" owner:self];
    
    Track *track = self.filteredTracks[row];
    cell.titleTextField.stringValue = track.name;
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
    [self updatePlayingStatusButton:sender];
    
    NSInteger index = sender.tag;
    
    Track *track = self.filteredTracks[index];
    [self.trackNameLabel setStringValue:track.name];
    
    if (self.isPlaying == NO) {
        [self.player pause];
    }
    
    if (self.isPlaying == YES) {
        NSURL *trackURL = [NSURL URLWithString:track.url];
        
        if ([[self urlOfCurrentlyPlayingInPlayer:self.player] isEqual:trackURL]) {
            [self.player play];
        }
        else {
            [self startTimerAndPlayer:trackURL];
        }
    }
}

-(NSURL *)urlOfCurrentlyPlayingInPlayer:(AVPlayer *)player{
    // get current asset
    AVAsset *currentPlayerAsset = player.currentItem.asset;
    // make sure the current asset is an AVURLAsset
    if (![currentPlayerAsset isKindOfClass:AVURLAsset.class]) return nil;
    // return the NSURL
    return [(AVURLAsset *)currentPlayerAsset URL];
}

- (void)updatePlayingStatusButton:(NSButton*)button
{
    self.isPlaying = !self.isPlaying;
    
    if (self.lastClickedPlayButton != button) {
        [self.lastClickedPlayButton setPlayingImage:NO];
        self.lastClickedPlayButton = button;
        self.isPlaying = YES;
    }

    [self.lastClickedPlayButton setPlayingImage:self.isPlaying];
}

- (void)startTimerAndPlayer:(NSURL*)url
{
    NSError *error;
    self.player = [AVPlayer playerWithURL:url];
    
    if (self.player == nil) {
        NSLog(@"%@",[error description]);
    }
    else
    {
        [self.player play];
        [self.player setVolume:[self.volumeSlider floatValue]];
        [self updateMaxSeekSliderWithDuration:self.player.currentItem.asset.duration];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(timerFired:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)stopTimerAndPlayer
{
    [self.timer invalidate];
    self.timer = nil;
    [self.player pause];
    self.player = nil;
}

- (void)timerFired:(NSTimer*)timer
{
    NSTimeInterval currentTime = CMTimeGetSeconds([self.player currentTime]);
    
    NSInteger minutes = floor(currentTime/60);
    NSInteger seconds = trunc(currentTime - minutes * 60);
    
    // update your UI with currentTime;
    [self.currentTimeLabel setStringValue:[NSString stringWithFormat:@"%ld:%02ld", minutes, seconds]];
    [self.seekSlider setDoubleValue:currentTime];
}

- (void)updateMaxSeekSliderWithDuration:(CMTime)duration
{
    [self.seekSlider setMaxValue:CMTimeGetSeconds(duration)];
}

- (IBAction)timelineChanged:(NSSlider *)sender
{
    [self.player seekToTime:CMTimeMakeWithSeconds([sender integerValue], 1)];
}

- (IBAction)volumeChanged:(NSSlider *)sender
{
    [self.player setVolume:[sender floatValue]];
}

@end
