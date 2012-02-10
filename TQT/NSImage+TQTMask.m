//
//  NSImage+TQTMask.m
//  TQT
//
//  Created by Developer - No.11 Mac on 11-8-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSImage+TQTMask.h"

@implementation NSImage (NSImage_TQTMask)

- (NSImage *)maskWithImage:(NSImage *)maskImage
{
    NSImage *retImage = [[NSImage alloc] initWithSize:[self size]];
    [retImage lockFocus];
    [[NSColor whiteColor] set];
    NSRect drawRect = NSZeroRect;
    drawRect.size = [self size];
    NSRectFill(drawRect);
    NSRect headRect = NSInsetRect(drawRect, 5, 5);
    [self drawInRect:headRect fromRect:drawRect operation:NSCompositeCopy fraction:1.0];
    NSRect maskRect = drawRect;
    maskRect.size = [maskImage size];
    [maskImage drawInRect:drawRect fromRect:maskRect operation:NSCompositeSourceAtop fraction:1.0];
    [retImage autorelease];
    [retImage unlockFocus];
    return retImage;
}
@end
