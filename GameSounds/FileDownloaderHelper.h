//
//  FileDownloaderHelper.h
//  GameSounds
//
//  Created by Deliany Delirium on 31.03.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileDownloaderHelper : NSObject

- (void)startDownloadingURL:(NSString*)pathUrl progressIndicator:(NSProgressIndicator*)indicator;

@end
