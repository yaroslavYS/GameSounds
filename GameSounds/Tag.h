//
//  Tag.h
//  GameSounds
//
//  Created by Deliany Delirium on 25.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tag : NSObject

@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *name;

- (id)initWithName:(NSString*)name andCategory:(NSString*)category;
- (id)initWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary *)transformToDictionary;

@end
