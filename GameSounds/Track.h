//
//  Track.h
//  GameSounds
//
//  Created by Deliany Delirium on 24.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject

@property (nonatomic, strong) NSString *name;
@property long long fileSize;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSArray *tags;
@property NSTimeInterval duration;
@property (nonatomic, strong, readonly) NSString *tagsAsString;
@property (nonatomic, strong, readonly) NSString *beautifiedSize;

- (id)initWithName:(NSString*)name fileSize:(long long)fileSize url:(NSString*)url tags:(NSArray*)tags duration:(NSTimeInterval)duration;
- (id)initWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary *)transformToDictionary;

@end
