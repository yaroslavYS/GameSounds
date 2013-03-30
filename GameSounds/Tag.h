//
//  Tag.h
//  GameSounds
//
//  Created by Deliany Delirium on 25.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tag : NSObject

@property (strong) NSString *category;
@property (strong) NSString *name;

- (id)initWithName:(NSString*)name andCategory:(NSString*)category;
- (id)initWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary *)transformToDictionary;

@end
