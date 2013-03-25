//
//  Track.m
//  GameSounds
//
//  Created by Deliany Delirium on 24.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "Track.h"
#import "Tag.h"


#define kFileNameKey @"Filename"
#define kFileSizeKey @"Filesize"
#define kUrlKey @"Url"
#define kTagsKey @"Tags"
#define kDurationKey @"Duration"

@implementation Track

- (id)initWithFileName:(NSString *)fileName fileSize:(long long)fileSize url:(NSString *)url tags:(NSArray *)tags duration:(NSTimeInterval)duration
{
    if (self = [super init]) {
        self.fileName = fileName;
        self.fileSize = fileSize;
        self.url = url;
        self.tags = tags;
        self.duration = duration;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    NSString *fileName = dictionary[kFileNameKey];
    NSString *url = dictionary[kUrlKey];
    
    NSArray *tagsArr = dictionary[kTagsKey];
    NSMutableArray *tags = [NSMutableArray arrayWithCapacity:[tagsArr count]];
    
    for (NSDictionary *tagDic in tagsArr) {
        Tag *tag = [[Tag alloc] initWithDictionary:tagDic];
        [tags addObject:tag];
    }
    NSTimeInterval duration = [dictionary[kDurationKey] doubleValue];
    long long fileSize = [dictionary[kFileSizeKey] longLongValue];
    
    return [self initWithFileName:fileName fileSize:fileSize url:url tags:tagsArr duration:duration];
}


- (NSDictionary *)transformToDictionary
{
    NSMutableArray *tagsArr = [NSMutableArray array];
    for (Tag* tag in self.tags) {
        [tagsArr addObject:[tag transformToDictionary]];
    }
    NSDictionary *dic = @{ kFileNameKey: self.fileName,
                           kFileSizeKey: @(self.fileSize),
                           kUrlKey: self.url,
                           kTagsKey: tagsArr,
                           kDurationKey: @(self.duration) };
    
    return dic;
}

@end
