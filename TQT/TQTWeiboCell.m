//
//  TQTWeiboCell.m
//  TQT
//
//  Created by lishunnian on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TQTWeiboCell.h"

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
@synthesize imageCell = imageCell_;
@synthesize nickCell = nickCell_;
@synthesize timeCell = timeCell_;
@synthesize hasImage = hasImage_;

- (id)copyWithZone:(NSZone *)zone
{
    TQTWeiboCell *result = [super copyWithZone:zone];
    if (result != nil)
    {
        result->imageCell_ = [imageCell_ copyWithZone:zone];
        result->nickCell_ = [nickCell_ copyWithZone:zone];
        result->timeCell_ = [timeCell_ copyWithZone:zone];
    }
    return result;
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
    [imageCell_ release];
    self.nickCell = nil;
    self.timeCell = nil;
    [super dealloc];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    if (hasImage_) {
        [imageCell_ drawWithFrame:[self _imageCellFrameForInteriorFrame:cellFrame] inView:controlView];
    }
    if (nickCell_) {
        [nickCell_ drawWithFrame:[self _nickCellFrameForInteriorFrame:cellFrame] inView:controlView];
    }
    if (timeCell_) {
        [timeCell_ drawWithFrame:[self _timeCellFrameForInteriorFrame:cellFrame] inView:controlView];
    }
    NSString *text = weibo_.origtext;
    if (weibo_.source && (weibo_.type == 2 || weibo_.type == 4)) {
        text = [text stringByAppendingFormat:@"\r\n--------------\r\n@%@:%@", weibo_.source.nick, weibo_.source.origtext];
    }
    [self setStringValue:text];
    [self setFont:[NSFont systemFontOfSize:12]];
    [self setTextColor:[NSColor darkGrayColor]];
    NSRect textFrame = [self _textCellFrameForInteriorFrame:cellFrame];
    [super drawInteriorWithFrame:textFrame inView:controlView];
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
    if (aWeibo.nick) {
        self.nickCell = [[[NSTextFieldCell alloc] initTextCell:aWeibo.nick] autorelease];
        [nickCell_ setFont:[NSFont boldSystemFontOfSize:12]];
        [nickCell_ setAlignment:NSLeftTextAlignment];
    }
    NSDate *sendTime = [NSDate dateWithTimeIntervalSince1970:weibo_.timeStamp];
    [sendTime dateWithCalendarFormat:@"%Y-%m-%d %H:%M" timeZone:[NSTimeZone localTimeZone]];
    NSString *dateString = [sendTime descriptionWithCalendarFormat:@"%Y-%m-%d %H:%M"
                                                          timeZone:nil
                                                            locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
    if (dateString) {
        self.timeCell = [[[NSTextFieldCell alloc] initTextCell:dateString] autorelease];
        [timeCell_ setTextColor:[NSColor grayColor]];
        [timeCell_ setFont:[NSFont systemFontOfSize:10.0f]];
        [timeCell_ setAlignment:NSRightTextAlignment];
    }
}

- (void)setImage:(NSImage *)image
{
    if (imageCell_ == nil) {
        imageCell_ = [[NSImageCell alloc] init];
        [imageCell_ setControlView:[self controlView]];
        [imageCell_ setBackgroundStyle:[self backgroundStyle]];
    }
    hasImage_ = YES;
    [imageCell_ setImageScaling:NSImageScaleProportionallyUpOrDown];
    imageCell_.image = image;
}
@end
