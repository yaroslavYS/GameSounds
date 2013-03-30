//
//  NSButton+Select.m
//  GameSounds
//
//  Created by Deliany Delirium on 30.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "NSButton+AlternateImage.h"

@implementation NSButton (AlternateImage)

- (void)useAlternateImage
{
    NSImage *const img = [self image];
    [self setImage:[self alternateImage]];
    [self setAlternateImage:img];
}

- (void)setPlaying:(BOOL)isPlaying
{
    NSImage *playImg = [NSImage imageNamed:@"play.png"];
    NSImage *stopImg = [NSImage imageNamed:@"stop.png"];
    NSImage *const img = isPlaying ? playImg : stopImg;
    NSImage *const altImg = isPlaying ? stopImg : playImg;
    if (img != self.image && altImg != self.alternateImage) {
        [self setImage:img];
        [self setAlternateImage:altImg];
    }
}

@end
