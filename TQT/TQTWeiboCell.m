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
@interface TQTWeiboCell (private)
- (NSRect)_imageCellFrameForInteriorFrame:(NSRect)frame;
- (NSRect)_nickCellFrameForInteriorFrame:(NSRect)frame;
- (NSRect)_timeCellFrameForInteriorFrame:(NSRect)frame;
@end

@implementation TQTWeiboCell (private)

- (NSRect)_imageCellFrameForInteriorFrame:(NSRect)frame
{
    CGRect result = frame;
    result.origin.y = frame.origin.y + frame.size.height - kImageInset - kImageCellHeight;
    result.size.height = kImageCellHeight;
    return result;
}

- (NSRect)_nickCellFrameForInteriorFrame:(NSRect)frame
{
    NSString *nick = weibo_.nick;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    [attrs setObject:[NSFont boldSystemFontOfSize:12] forKey:NSFontAttributeName];
    NSSize nickSize = [nick sizeWithAttributes:attrs];
    NSRect result = frame;
    result.size = nickSize;
    result.size.width += 5;
    return result;
}
- (NSRect)_timeCellFrameForInteriorFrame:(NSRect)frame
{
    NSDate *sendTime = [NSDate dateWithTimeIntervalSince1970:weibo_.timeStamp];
    [sendTime dateWithCalendarFormat:@"%Y-%m-%d %H:%M" timeZone:[NSTimeZone localTimeZone]];
    NSString *dateString = [sendTime descriptionWithCalendarFormat:@"%Y-%m-%d %H:%M"
                                                          timeZone:nil
                                                            locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    [attrs setObject:[NSFont systemFontOfSize:10] forKey:NSFontAttributeName];
    NSSize stringSize = [dateString sizeWithAttributes:attrs];
    NSRect result = frame;
    result.size = stringSize;
    result.origin.x = frame.size.width - result.size.width + frame.origin.x;
    return frame;
}

- (NSRect)_textCellFrameForInteriorFrame:(NSRect)frame
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    [attrs setObject:[NSFont systemFontOfSize:12.0f] forKey:NSFontAttributeName];
    NSString *text = weibo_.origtext;
    NSSize textSize = [text sizeWithAttributes:attrs];
    int lineCount = ceil(textSize.width / frame.size.width);
    if (weibo_.source && (weibo_.type == 2 || weibo_.type == 4)) {
        textSize = [weibo_.source.origtext sizeWithAttributes:attrs];
        lineCount += ceil(textSize.width / frame.size.width);
        lineCount ++;
    }
    lineCount ++;
    NSRect result = frame;
    result.size.height = textSize.height * lineCount;
    result.origin.y += 20;
    return result;
}

@end


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
//    [textView_ setBackgroundColor:[NSColor redColor]];
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
//    if ([weibo_.images count] > 0 || [weibo_.source.images count] > 0) {
//        [weibo_ showImageInView:textView_];
//    }
}

- (void)drawRect:(NSRect)dirtyRect
{
	if([self isSelected]) {
		[[NSColor selectedControlColor] set];
	}
	else {
		[[NSColor whiteColor] set];
    }
    
    //Draw the border and background
	NSBezierPath *roundedRect = [NSBezierPath bezierPathWithRoundedRect:[self bounds] xRadius:6.0 yRadius:6.0];
	[roundedRect fill];
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
