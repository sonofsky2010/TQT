//
//  TQTHeadImageCell.m
//  TQT
//
//  Created by Developer - No.11 Mac on 11-8-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TQTHeadImageCell.h"

@implementation TQTHeadImageCell

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (BOOL)startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView
{
    NSLog(@"hit image");
    return YES;
}

- (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag
{
    if (flag) {
        NSLog(@"mouse up");
    }
}

- (BOOL)continueTracking:(NSPoint)lastPoint at:(NSPoint)currentPoint inView:(NSView *)controlView
{
    return YES;
}


- (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)flag
{
    NSApplication *theApp = [NSApplication sharedApplication];
    unsigned event_mask = NSLeftMouseDownMask | NSLeftMouseUpMask
    | NSMouseMovedMask | NSLeftMouseDraggedMask | NSOtherMouseDraggedMask
    | NSRightMouseDraggedMask;
    NSPoint location = [theEvent locationInWindow];
    NSPoint point = [controlView convertPoint: location fromView: nil];
    NSPoint last_point = point;
    BOOL done;
    BOOL mouseWentUp;
    unsigned periodCount = 0;
    
    if (![self startTrackingAt: point inView: controlView])
        return NO;
    
    if (![controlView mouse: point inRect: cellFrame])
        return NO; // point is not in cell
    
    mouseWentUp = NO;
    done = NO;
    if (theEvent != [NSApp currentEvent])
        theEvent = [NSApp currentEvent];
    else
        theEvent = [theApp nextEventMatchingMask: event_mask
                                       untilDate: [NSDate distantFuture]
                                          inMode: NSEventTrackingRunLoopMode
                                         dequeue: YES];
    
    while (!done)
    {
        NSEventType eventType;
        BOOL pointIsInCell;
        
        eventType = [theEvent type];
        
        if (eventType != NSPeriodic || periodCount == 4)
        {
            last_point = point;
            if (eventType == NSPeriodic)
            {
                NSWindow *w = [controlView window];
                
                /*
                 * Too many periodic events in succession - 
                 * update the mouse location and reset the counter.
                 */
                location = [w mouseLocationOutsideOfEventStream];
                periodCount = 0;
            }
            else
            {
                location = [theEvent locationInWindow];
            }
            point = [controlView convertPoint: location fromView: nil];
        }
        else
        {
            periodCount++;
        }
        
        if (![controlView mouse: point inRect: cellFrame])
        {
            
            pointIsInCell = NO;        
            if (flag == NO) 
            {
                done = YES;
            }
        }
        else
        {
            pointIsInCell = YES;
        }
        
        if (!done && ![self continueTracking: last_point    // should continue
                                          at: point         // tracking?
                                      inView: controlView])
        {
            done = YES;
        }
        
        // Did the mouse go up?
        if (eventType == NSLeftMouseUp)
        {
            mouseWentUp = YES;
            done = YES;
        }
        
        if (!done)
            theEvent = [theApp nextEventMatchingMask: event_mask
                                           untilDate: [NSDate distantFuture]
                                              inMode: NSEventTrackingRunLoopMode
                                             dequeue: YES];
    }
    
    [self stopTracking: last_point
                    at: point
                inView: controlView
             mouseIsUp: mouseWentUp];
    
    
    // Return YES only if the mouse went up within the cell
    if (mouseWentUp && (flag || [controlView mouse: point inRect: cellFrame]))
    {
        return YES;
    }
    
    return NO; // Otherwise return NO
    
}

- (NSColor *)highlightColorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    return nil;
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    if ([self isHighlighted]) {
        [[NSColor controlColor] set];
        cellFrame.origin.x -= 1;
        cellFrame.origin.y -= 1;
        cellFrame.size.height += 2;
        cellFrame.size.width += 3;
        NSRectFill(cellFrame);
    }
    [super drawInteriorWithFrame:cellFrame inView:controlView];
}
@end
