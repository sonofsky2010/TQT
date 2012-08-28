//
//  TQTWeiboCell.m
//  TQT
//
//  Created by lishunnian on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TQTWeiboCell.h"
#import "TQTWeiboDetailController.h"
#import "TQTAppDelegate.h"
#import "NSStringAdditions.h"
#define kImageInset (4.0f)
#define kImageCellHeight (120.0f)


@implementation TQTWeiboCell

@dynamic weibo;
@synthesize headImagView = headImagView_;
@synthesize textView = textView_;
@synthesize timeLabel = timeLabel_;
@synthesize hasImage = hasImage_;

- (void)awakeFromNib
{
    [textView_ setDrawsBackground:NO];
    [textView_ setDelegate:self];
    [headImagView_ setImageScaling:NSScaleToFit];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    self.weibo = nil;
    self.headImagView = nil;
    self.timeLabel = nil;
    self.textView = nil;
    [super dealloc];
}

- (TQTWeiBo *)weibo
{
    return weibo_;
}

- (void)setWeibo:(TQTWeiBo *)aWeibo
{
    if (weibo_ == aWeibo) {
        return;
    }
    [weibo_ autorelease];
    weibo_ = [aWeibo retain];
    NSDate *sendTime = [NSDate dateWithTimeIntervalSince1970:weibo_.timeStamp];
    [sendTime dateWithCalendarFormat:@"%Y-%m-%d %H:%M" timeZone:[NSTimeZone localTimeZone]];
    NSString *dateString = [sendTime descriptionWithCalendarFormat:@"%Y-%m-%d %H:%M"
                                                          timeZone:nil
                                                            locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
    if (dateString) {
        [self.timeLabel setStringValue:dateString];
    }
    [[textView_ textStorage] setAttributedString:weibo_.content];
}

- (void)drawRect:(NSRect)dirtyRect
{
	if([self isSelected]) {
		[[NSColor selectedControlColor] set];
	}
	else {
		[[NSColor colorWithDeviceRed:0.97f green:0.97f blue:0.97f alpha:1.0] set];
    }
    NSRectFill([self bounds]);

    [[NSColor colorWithDeviceRed:0.83f green:0.83f blue:0.83f alpha:1.0f] set];

//    NSBezierPath *topPath = [NSBezierPath bezierPath];
//    [topPath moveToPoint:[self bounds].origin];
    NSPoint topRightPoint = [self bounds].origin;
    topRightPoint.x += [self bounds].size.width;
//    [topPath lineToPoint:topRightPoint];
//    [topPath setLineWidth:1.0f];
//    [topPath stroke];

    NSPoint bottomLeftPoint = [self bounds].origin;
    bottomLeftPoint.y += [self bounds].size.height;
    NSPoint bottomRightPoint = topRightPoint;
    bottomRightPoint.y += [self bounds].size.height;
    NSBezierPath *bottomPath = [NSBezierPath bezierPath];
    [bottomPath moveToPoint:bottomLeftPoint];
    [bottomPath lineToPoint:bottomRightPoint];
    [bottomPath setLineWidth:1.0f];
    [bottomPath stroke];
}

- (void)textView:(NSTextView *)textView clickedOnCell:(id<NSTextAttachmentCell>)cell inRect:(NSRect)cellFrame atIndex:(NSUInteger)charIndex
{
    if (([[weibo_ images] count] > 0 || [[[weibo_ source] images] count] > 0)) {            
        dispatch_queue_t network_queue = dispatch_queue_create("image show", NULL);
        dispatch_async(network_queue, ^(void){
            NSString *imagePath = nil;
            if ([[weibo_ images] count] > 0) {
                imagePath = [[[weibo_ images] objectAtIndex:0] stringByAppendingPathComponent:@"2000"];

            }
            else if([[[weibo_ source] images] count] > 0) {
                imagePath = [[[[weibo_ source] images] objectAtIndex:0] stringByAppendingPathComponent:@"2000"];
            }
            else
                return;
            NSString *imgTmpPath = [NSTemporaryDirectory() stringByAppendingFormat:@"/%@", [imagePath sha1Hash]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:imgTmpPath])
            {
                [[NSWorkspace sharedWorkspace] openFile:imgTmpPath withApplication:@"Preview.app"];
            }
            else
            {
                NSURL *imageUrl = [NSURL URLWithString:imagePath];
                NSData *data = [NSData dataWithContentsOfURL:imageUrl];
                [data writeToFile:imgTmpPath atomically:YES];
                [[NSWorkspace sharedWorkspace] openFile:imgTmpPath withApplication:@"Preview.app"];
            }
        });
    }
}
@end
