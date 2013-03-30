//
//  GameSoundsManager.h
//  GameSounds
//
//  Created by Deliany Delirium on 25.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Track;
@class Tag;

@interface GameSoundsManager : NSObject

@property (strong, readonly) NSMutableArray *tracks;
@property (strong, readonly) NSMutableArray *tags;

- (void)addTrack:(Track*)track;
- (void)addTag:(Tag*)tag;
- (void)load;
- (void)save;

@end
