//
//  GameSoundsManager.m
//  GameSounds
//
//  Created by Deliany Delirium on 25.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "GameSoundsManager.h"
#import "JSONKit.h"
#import "Track.h"
#import "Tag.h"

@interface GameSoundsManager ()

@property (strong, readwrite) NSMutableArray *tracks;
@property (strong, readwrite) NSMutableArray *tags;

@end


#define kTracksFile @"Tracks.json"
#define kTagsFile @"Tags.json"

@implementation GameSoundsManager

- (id)init
{
    if (self = [super init]) {
        [self loadTags];
        [self loadTracks];
    }
    
    return self;
}

- (void)addTrack:(Track *)track
{
    [self.tracks addObject:track];
}

- (void)addTag:(Tag *)tag
{
    [self.tracks addObject:tag];
}

- (void)load
{
    [self loadTags];
    [self loadTracks];
}

- (void)save
{
    [self saveTags];
    [self saveTracks];
}

- (NSString*)tracksFilePath
{
    NSString *path = [[NSBundle mainBundle] pathForResource:kTracksFile ofType:nil];
    return path;
}

- (NSString*)tagsFilePath
{
    NSString *path = [[NSBundle mainBundle] pathForResource:kTagsFile ofType:nil];
    return path;
}

- (void)loadTracks
{
    NSError *error;
    NSString *tracksJSON = [NSString stringWithContentsOfFile:[self tracksFilePath] encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"Error while reading %@ file: %@", kTracksFile, [error localizedDescription]);
        return;
    }
    
    id objectHierarhy = [tracksJSON objectFromJSONString];
    if (error) {
        NSLog(@"Error while deserializing contents of %@ file: %@", kTracksFile, [error localizedDescription]);
        return;
    }
    
    NSMutableArray *tracks = [NSMutableArray array];
    if ([objectHierarhy isKindOfClass:[NSArray class]]) {
        NSArray *tracksArr = (NSArray*)objectHierarhy;
        for (id trackObj in tracksArr) {
            if ([trackObj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *trackDic = (NSDictionary*)trackObj;
                Track *track = [[Track alloc] initWithDictionary:trackDic];
                if (track) {
                    [tracks addObject:track];
                }
            }
        }
    }
    
    self.tracks = tracks;
}

- (void)loadTags
{
    NSError *error;
    NSString *tagsJSON = [NSString stringWithContentsOfFile:[self tagsFilePath] encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"Error while reading %@ file: %@", kTagsFile, [error localizedDescription]);
        return;
    }
    
    id objectHierarhy = [tagsJSON objectFromJSONString];
    if (error) {
        NSLog(@"Error while deserializing contents of %@ file: %@", kTagsFile, [error localizedDescription]);
        return;
    }
    
    NSMutableArray *tags = [NSMutableArray array];
    if ([objectHierarhy isKindOfClass:[NSArray class]]) {
        NSArray *tagsArr = (NSArray*)objectHierarhy;
        for (id tagObj in tagsArr) {
            if ([tagObj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *tagDic = (NSDictionary*)tagObj;
                Tag *tag = [[Tag alloc] initWithDictionary:tagDic];
                if (tag) {
                    [tags addObject:tag];
                }
            }
        }
    }
    
    self.tags = tags;
}

- (void)saveTracks
{
    NSMutableArray *arrOfTracksDic = [NSMutableArray arrayWithCapacity:[self.tracks count]];
    for (Track* track in self.tracks) {
        [arrOfTracksDic addObject:[track transformToDictionary]];
    }
        
    NSError *error;
    NSString *tracksJSON = [arrOfTracksDic JSONStringWithOptions:JKSerializeOptionPretty error:&error];
    
    if (error) {
        NSLog(@"Error while serializing tracks array: %@", [error localizedDescription]);
        return;
    }
    
    [tracksJSON writeToFile:[self tracksFilePath] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Error while writing serialized tracks array to %@ file: %@", kTracksFile, [error localizedDescription]);
        return;
    }
}

- (void)saveTags
{
    NSMutableArray *arrOfTagsDic = [NSMutableArray arrayWithCapacity:[self.tags count]];
    for (Tag* tag in self.tags) {
        [arrOfTagsDic addObject:[tag transformToDictionary]];
    }
    
    NSError *error;
    NSString *tagsJSON = [arrOfTagsDic JSONStringWithOptions:JKSerializeOptionPretty error:&error];
    
    if (error) {
        NSLog(@"Error while serializing tags array: %@", [error localizedDescription]);
        return;
    }
    
    [tagsJSON writeToFile:[self tagsFilePath] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Error while writing serialized tags array to %@ file: %@", kTagsFile, [error localizedDescription]);
        return;
    }
}

@end
