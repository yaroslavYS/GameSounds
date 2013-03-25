//
//  Track.h
//  GameSounds
//
//  Created by Deliany Delirium on 24.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject

@property (strong, nonatomic) NSString *fileName;
@property (nonatomic) long long fileSize;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSArray *tags;
@property (nonatomic) NSTimeInterval duration;

- (id)initWithFileName:(NSString*)fileName fileSize:(long long)fileSize url:(NSString*)url tags:(NSArray*)tags duration:(NSTimeInterval)duration;
- (id)initWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary *)transformToDictionary;

@end
