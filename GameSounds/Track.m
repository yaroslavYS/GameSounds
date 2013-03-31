//
//  Track.m
//  GameSounds
//
//  Created by Deliany Delirium on 24.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "Track.h"
#import "Tag.h"


#define kNameKey @"Name"
#define kFileSizeKey @"Filesize"
#define kUrlKey @"Url"
#define kTagsKey @"Tags"
#define kDurationKey @"Duration"

@implementation Track

- (id)initWithName:(NSString *)name fileSize:(long long)fileSize url:(NSString *)url tags:(NSArray *)tags duration:(NSTimeInterval)duration
{
    if (self = [super init]) {
        self.name = name;
        self.fileSize = fileSize;
        self.url = url;
        self.tags = tags;
        self.duration = duration;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    NSString *name = dictionary[kNameKey];
    NSString *url = dictionary[kUrlKey];
    
    NSArray *tagsArr = dictionary[kTagsKey];
    NSMutableArray *tags = [NSMutableArray arrayWithCapacity:[tagsArr count]];
    
    for (NSDictionary *tagDic in tagsArr) {
        Tag *tag = [[Tag alloc] initWithDictionary:tagDic];
        [tags addObject:tag];
    }
    NSTimeInterval duration = [dictionary[kDurationKey] doubleValue];
    long long fileSize = [dictionary[kFileSizeKey] longLongValue];
    
    return [self initWithName:name fileSize:fileSize url:url tags:tags duration:duration];
}

- (NSString *)tagsAsString
{
    return [self.tags componentsJoinedByString:@", "];
}

- (NSString *)beautifiedSize
{
    float floatSize = self.fileSize;
    if (floatSize<1023)
        return([NSString stringWithFormat:@"%f bytes",floatSize]);
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

- (NSDictionary *)transformToDictionary
{
    NSMutableArray *tagsArr = [NSMutableArray array];
    for (Tag* tag in self.tags) {
        [tagsArr addObject:[tag transformToDictionary]];
    }
    NSDictionary *dic = @{ kNameKey: self.name,
                           kFileSizeKey: @(self.fileSize),
                           kUrlKey: self.url,
                           kTagsKey: tagsArr,
                           kDurationKey: @(self.duration) };
    
    return dic;
}

@end
