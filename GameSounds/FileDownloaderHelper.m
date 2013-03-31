//
//  FileDownloaderHelper.m
//  GameSounds
//
//  Created by Deliany Delirium on 31.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "FileDownloaderHelper.h"

@interface FileDownloaderHelper () <NSURLDownloadDelegate>
@property long long expectedContentLength;
@property long long bytesReceived;

@property (weak) NSProgressIndicator *progressIndicator;
@end



@implementation FileDownloaderHelper

- (void)startDownloadingURL:(NSString*)pathUrl progressIndicator:(NSProgressIndicator*)indicator
{
    // Create the request.
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:pathUrl]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:60.0];
    
    self.progressIndicator = indicator;
    
    
    // Create the connection with the request and start loading the data.
    NSURLDownload  *theDownload = [[NSURLDownload alloc] initWithRequest:theRequest
                                                                delegate:self];
    if (!theDownload) {
        // inform the user that the download failed.
    }
}


- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error
{    
    // Inform the user.
    NSLog(@"Download failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)downloadDidFinish:(NSURLDownload *)download
{
    // Do something with the data.
    NSLog(@"%@",@"downloadDidFinish");
}

-(void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename
{
    NSString *destinationFilename;
    NSString *homeDirectory = NSHomeDirectory();
    NSString *downloadsDirectory = [homeDirectory stringByAppendingPathComponent:@"Downloads"];
    
    NSString *gameSounds = [downloadsDirectory stringByAppendingPathComponent:@"GameSounds"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir;
    if (![fileManager fileExistsAtPath:gameSounds isDirectory:&isDir]) {
        NSError *error;
        BOOL success = [fileManager createDirectoryAtPath:gameSounds withIntermediateDirectories:YES attributes:nil error:&error];
        if (!success) {
            NSLog(@"Directory creation failed! Error - %@", [error localizedDescription]);
            return;
        }
    }
    
    destinationFilename = [gameSounds stringByAppendingPathComponent:filename];
    [download setDestination:destinationFilename allowOverwrite:NO];
}

-(void)download:(NSURLDownload *)download didCreateDestination:(NSString *)path
{
    // path now contains the destination path
    // of the download, taking into account any
    // unique naming caused by -setDestination:allowOverwrite:
    NSLog(@"Final file destination: %@",path);
}

- (void)updateProgressIndicatorWithValue:(double)value
{
    [self.progressIndicator setDoubleValue:value];
    if (value == 0.0) {
        [self.progressIndicator setHidden:NO];
    }
    else if (value == 100.0) {
        [self.progressIndicator setHidden:YES];
    }
}


- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response
{
    // Reset the progress, this might be called multiple times.
    // bytesReceived is an instance variable defined elsewhere.
    self.bytesReceived = 0;
    
    // Retain the response to use later.
    self.expectedContentLength = [response expectedContentLength];
    
    [self updateProgressIndicatorWithValue:0.0];
}
- (void)download:(NSURLDownload *)download didReceiveDataOfLength:(NSUInteger)length
{
    long long expectedLength = self.expectedContentLength;
    
    self.bytesReceived += length;
    
    if (expectedLength != NSURLResponseUnknownLength) {
        // If the expected content length is
        // available, display percent complete.
        float percentComplete = (self.bytesReceived/(float)expectedLength)*100.0;
        [self updateProgressIndicatorWithValue:percentComplete];
        NSLog(@"Percent complete - %f",percentComplete);
    } else {
        // If the expected content length is
        // unknown, just log the progress.
        NSLog(@"Bytes received - %lld",self.bytesReceived);
    }
}

@end
