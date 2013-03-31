//
//  AppDelegate.m
//  GameSounds
//
//  Created by Deliany Delirium on 24.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVAsset.h>

#import "AppDelegate.h"
#import "GameSoundsManager.h"
#import "Track.h"
#import "Tag.h"
#import "NSButton+AlternateImage.h"
#import "TrackCellView.h"
#import "FileDownloaderHelper.h"

@interface AppDelegate () <NSTableViewDelegate>
@property (nonatomic, strong) GameSoundsManager *gameSoundsManager;

@property (weak) IBOutlet NSArrayController *tagsArrayController;
@property (weak) IBOutlet NSTextField *trackNameLabel;
@property (weak) IBOutlet NSArrayController *tracksArrayController;

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) NSTimer *timer;
@property (weak) IBOutlet NSTableView *tracksTableView;

@property (weak) IBOutlet NSSlider *seekSlider;
@property (weak) IBOutlet NSTextField *currentTimeLabel;
@property (weak) IBOutlet NSSlider *volumeSlider;

@property (weak) NSButton *lastClickedPlayButton;
@property (weak) TrackCellView *lastSelectedCell;
@property (nonatomic) BOOL isPlaying;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    [self.tagsArrayController addObserver:self forKeyPath:@"selectionIndexes" options:NSKeyValueObservingOptionNew context:nil];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playerItemDidReachEnd:)
     name:AVPlayerItemDidPlayToEndTimeNotification
     object:self.player];
}

- (GameSoundsManager*)gameSoundsManager
{
    if (!_gameSoundsManager) {
        _gameSoundsManager = [[GameSoundsManager alloc] init];
    }
    
    return _gameSoundsManager;
}

- (NSArray *)tracks
{
    if (!_tracks) {
        _tracks = self.gameSoundsManager.tracks;
    }
    return _tracks;
}

- (NSArray *)tags
{
    if (!_tags) {
        _tags = self.gameSoundsManager.tags;
    }
    return _tags;
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
            [self.tracksArrayController setFilterPredicate:pred];
        }
        else
        {
            [self.tracksArrayController setFilterPredicate:nil];
        }
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    [self.lastSelectedCell hideDownloadButton];
    
    NSTableView *table = [notification object];
    NSInteger selected = [table selectedRow];
    
    // Get row at specified index
    TrackCellView *selectedCell = [table viewAtColumn:0 row:selected makeIfNecessary:YES];
    [selectedCell showDownloadButton];
    
    self.lastSelectedCell = selectedCell;
}


- (IBAction)playClick:(NSButton *)sender
{
    NSInteger index = [self.tracksTableView rowForView:sender];
    
    [self updatePlayingStatusButton:sender];
    
    Track *track = [self.tracksArrayController arrangedObjects][index];
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

- (IBAction)seekChanged:(NSSlider *)sender
{
    [self.player seekToTime:CMTimeMakeWithSeconds([sender integerValue], 1)];
}

- (IBAction)volumeChanged:(NSSlider *)sender
{
    [self.player setVolume:[sender floatValue]];
}


- (IBAction)downloadClick:(NSButton *)sender
{
    NSInteger index = [self.tracksTableView rowForView:sender];
    
    Track *track = [self.tracksArrayController arrangedObjects][index];
    TrackCellView *selectedCell = [self.tracksTableView viewAtColumn:0 row:index makeIfNecessary:YES];
    [selectedCell hideDownloadButton];
    
    
    FileDownloaderHelper *fileDownloader = [[FileDownloaderHelper alloc] init];
    [fileDownloader startDownloadingURL:track.url progressIndicator:selectedCell.progressIndicator];
}


@end
