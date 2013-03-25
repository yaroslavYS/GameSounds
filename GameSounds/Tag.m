//
//  Tag.m
//  GameSounds
//
//  Created by Deliany Delirium on 25.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "Tag.h"

#define kNameKey @"Name"
#define kCategoryKey @"Category"

@implementation Tag

- (id)initWithName:(NSString *)name andCategory:(NSString *)category
{
    if (self = [super init]) {
        self.name = name;
        self.category = category;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    NSString *name = dictionary[kNameKey];
    NSString *category = dictionary[kCategoryKey];
    return [self initWithName:name andCategory:category];
}

- (NSDictionary *)transformToDictionary
{
    NSDictionary *dic = @{ kNameKey : self.name,
                           kCategoryKey : self.category };
    return dic;
}

@end
