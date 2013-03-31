//
//  TrackTCV.m
//  GameSounds
//
//  Created by Deliany Delirium on 25.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "TrackCellView.h"

@implementation TrackCellView

- (void)hideDownloadButton
{
    [self.downloadButton setHidden:YES];
    [self.sizeTextField setHidden:YES];
}

- (void)showDownloadButton
{
    [self.downloadButton setHidden:NO];
    [self.sizeTextField setHidden:NO];
}

@end
