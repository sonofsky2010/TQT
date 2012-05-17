//
//  TQTImageViewAttachmentCell.m
//  TQT
//
//  Created by li shunnian on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TQTImageViewAttachmentCell.h"
#import "NSStringAdditions.h"
@implementation TQTImageViewAttachmentCell
@synthesize imageUrlPath = imageUrlPath_;

- (id)initWithImagePath:(NSString *)imageUrlPath
{
    self = [super init];
    if (self) {
        self.imageUrlPath = imageUrlPath;
    }
    return self;
}
- (CGSize)cellSize
{
    return CGSizeMake(600, 120);
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    if (self.drawView) {
        [super drawWithFrame:cellFrame inView:controlView];
    }
    else {
        if (imageUrlPath_) {
            NSString *imageTmpPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[imageUrlPath_ sha1Hash]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:imageTmpPath]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                    NSURL *url = [NSURL URLWithString:imageUrlPath_];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    if (data) {
                        [data writeToFile:imageTmpPath atomically:YES];
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            NSImage *image = [[[NSImage alloc] initWithContentsOfFile:imageTmpPath] autorelease];
                            [image setCacheMode:NSImageCacheAlways];
                            NSImageView *imageView = [[NSImageView alloc] init];
                            [imageView setImage:image];
                            [imageView setAnimates:YES];
                            self.drawView = imageView;
                            [imageView release];
                            [controlView setNeedsDisplay:YES];
                        });
                    }
                });
            } else {
                NSImage *image = [[[NSImage alloc] initWithContentsOfFile:imageTmpPath] autorelease];
                [image setCacheMode:NSImageCacheAlways];
                NSImageView *imageView = [[NSImageView alloc] init];
                [imageView setImage:image];
                [imageView setAnimates:YES];
                self.drawView = imageView;
                [imageView release];
                [controlView setNeedsDisplay:YES];
            }
        }
    }
}

- (void)dealloc
{
    self.imageUrlPath = nil;
    [super dealloc];
}
@end
