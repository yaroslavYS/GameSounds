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

- (void)setPlayingImage:(BOOL)isPlaying
{
    NSImage *playImg = [NSImage imageNamed:@"play.png"];
    NSImage *stopImg = [NSImage imageNamed:@"stop.png"];
    NSImage *const img = isPlaying ? stopImg : playImg;
    NSImage *const altImg = isPlaying ? playImg : stopImg;
    if (img != self.image && altImg != self.alternateImage) {
        [self setImage:img];
        [self setAlternateImage:altImg];
    }
}

@end
