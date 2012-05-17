//
//  TQTWeiBo.m
//  TQT
//
//  Created by lishunnian on 11-3-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TQTWeiBo.h"
#import "SBJsonWriter.h"
#import "TQTHelper.h"
#import "NSStringAdditions.h"
#import "TQTImageViewAttachmentCell.h"
@implementation TQTWeiBo
@synthesize text = text_;
@synthesize origtext = origtext_;
@synthesize count = count_;
@synthesize mCount = mCount_;
@synthesize from = from_;
@synthesize images = images_;
@synthesize name = name_;
@synthesize nick = nick_;
@synthesize weiboId = weiboId_;
@synthesize source = source_;
@synthesize timeStamp = timeStamp_;
@synthesize isSelf = isSelf_;
@synthesize type = type_;
@synthesize head = head_;
@synthesize location = location_;
@synthesize countryCode = countryCode_;
@synthesize provinceCode = provinceCode_;
@synthesize cityCode = cityCode_;
@synthesize isVip = isVip_;
@synthesize content = content_;
@synthesize imgAttachment = imgAttachment_;
@synthesize srcImgAttachment = srcImgAttachment_;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if ([dict isEqualTo:[NSNull null]]) {
        return nil;
    }
    if (self)
    {
        self.text = [dict objectForKey:@"text"];
        self.origtext = [dict objectForKey:@"origtext"];
        self.count = [dict objectForKey:@"count"];
        self.mCount = [dict objectForKey:@"mcount"];
        self.from = [dict objectForKey:@"from"];
        self.weiboId = [[dict objectForKey:@"id"] longLongValue];
        if (![[dict objectForKey:@"image"] isEqualTo:[NSNull null]]) {
            self.images = [dict objectForKey:@"image"];
        }
//        self.images = [dict objectForKey:@"image"];
        self.name = [dict objectForKey:@"name"];
        self.nick = [dict objectForKey:@"nick"];
        if ([dict objectForKey:@"source"]) {
            self.source = [TQTWeiBo weiBoFromDict:[dict objectForKey:@"source"]];
        }
        self.timeStamp = [[dict objectForKey:@"timestamp"] longValue];
        self.isSelf = [[dict objectForKey:@"self"] boolValue];
        self.type = [[dict objectForKey:@"type"] intValue];
        self.head = [dict objectForKey:@"head"];
        self.location = [dict objectForKey:@"location"];
        self.countryCode = [[dict objectForKey:@"country_code"] intValue];
        self.provinceCode = [[dict objectForKey:@"province_code"] intValue];
        self.cityCode = [[dict objectForKey:@"city_code"] intValue];
        self.isVip = [[dict objectForKey:@"isvip"] boolValue];
        
        self.content = [self createContent];
    }
    return self;
}

- (NSMutableAttributedString *)createContent
{
    NSURL *defaultImgUrl = [[NSBundle mainBundle] URLForImageResource:@"cover.png"];
    NSMutableAttributedString *contentAttributeString = [[[NSMutableAttributedString alloc] init] autorelease];
    NSMutableAttributedString *bodyAttributeString = [[[NSMutableAttributedString alloc] init] autorelease];
    NSMutableParagraphStyle *paragraphStyle = [[[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle setLineHeightMultiple:1.5];
    NSDictionary *nickAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor blueColor], NSForegroundColorAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    NSMutableAttributedString *nickAttributeString = [[[NSMutableAttributedString alloc] initWithString:[self.nick stringByAppendingString:@"\n"] attributes:nickAttributes] autorelease];
    NSMutableAttributedString *bodyTextAttributeString = [[[NSMutableAttributedString alloc] initWithString:[self.text stringByAppendingString:@"\n"] attributes:[NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName]] autorelease];
    [bodyAttributeString appendAttributedString:nickAttributeString];
    [bodyAttributeString appendAttributedString:bodyTextAttributeString];
    if ([self.images count] > 0) {
        NSString *imagePath120 = [[self.images objectAtIndex:0] stringByAppendingPathComponent:@"120"];
        NSTextAttachment *imgAttachment = [TQTHelper imageAttatchmentOfPath:imagePath120];
        NSAttributedString *imgAttatchmentString = [NSAttributedString attributedStringWithAttachment:imgAttachment];
        [bodyAttributeString appendAttributedString:imgAttatchmentString];
    }
    [contentAttributeString appendAttributedString:bodyAttributeString];
    if (self.source) {
        NSMutableParagraphStyle *srcParagraphStyle = [[paragraphStyle mutableCopy] autorelease];
        [srcParagraphStyle setHeadIndent:12.0f];
        [srcParagraphStyle setFirstLineHeadIndent:12.0f];
        NSMutableAttributedString *sourceAttributeString = [[[NSMutableAttributedString alloc] init] autorelease];
        NSMutableAttributedString *srcNickAttributeString = [[[NSMutableAttributedString alloc] initWithString:[self.source.nick stringByAppendingString:@"\n"] attributes:nickAttributes] autorelease];
        [sourceAttributeString appendAttributedString:srcNickAttributeString];
        NSMutableAttributedString *srcTextAttributeString = [[[NSMutableAttributedString alloc] initWithString:[self.source.text stringByAppendingString:@"\n"] attributes:nil] autorelease];
        [sourceAttributeString appendAttributedString:srcTextAttributeString];
        

        [sourceAttributeString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:srcParagraphStyle, NSParagraphStyleAttributeName, nil] range:NSMakeRange(0, [sourceAttributeString length])];
        if ([self.source.images count] > 0) {
           
            NSString *imagePath120 = [[self.source.images objectAtIndex:0] stringByAppendingPathComponent:@"120"];
            NSTextAttachment *attatchment = [TQTHelper imageAttatchmentOfPath:imagePath120];
            self.srcImgAttachment = srcImgAttachment_;
            NSMutableParagraphStyle *attStyle = [[[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
            [attStyle setFirstLineHeadIndent:12.0f];
            NSDictionary *attDict = [NSDictionary dictionaryWithObjectsAndKeys:attStyle, NSParagraphStyleAttributeName, nil];
            NSAttributedString *attStr = [NSAttributedString attributedStringWithAttachment:attatchment];
            NSMutableAttributedString *mutableAttstr = [[attStr mutableCopy] autorelease];
            [mutableAttstr addAttributes:attDict range:NSMakeRange(0, [attStr length])];
            [sourceAttributeString appendAttributedString:mutableAttstr];
        }
        [contentAttributeString appendAttributedString:sourceAttributeString];
    }
    return contentAttributeString;
}
- (void)dealloc
{
    [super dealloc];
}

+ (TQTWeiBo *)weiBoFromDict:(NSDictionary *)dict
{
    TQTWeiBo *weibo = [[[TQTWeiBo alloc] initWithDict:dict] autorelease];

    return weibo;
}

- (NSDictionary *)dictionary
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:text_, @"text",
                          origtext_, @"origtext",
                          count_, @"count",
                          from_, @"from",
                          images_, @"image",
                          name_, @"name",
                          nick_, @"nick",
                          [source_ dictionary], @"source",
                          timeStamp_, @"timestamp",
                          [NSNumber numberWithBool:isSelf_], @"self",
                          [NSNumber numberWithInt:type_], @"type",
                          head_, @"head",
                          location_, @"location",
                          [NSNumber numberWithInt:countryCode_], @"country_code",
                          [NSNumber numberWithInt:provinceCode_], @"province_code",
                          [NSNumber numberWithInt:cityCode_], @"city_code",
                          [NSNumber numberWithBool:isVip_], @"isvip",
                          nil];
    return dict;
}

- (NSString *)jsonString
{
    NSDictionary *dict = [self dictionary];
    SBJsonWriter *jsonWriter = [[[SBJsonWriter alloc] init] autorelease];
    return [jsonWriter stringWithObject:dict];
}

- (void)showImageInView:(NSView *)view
{
    if ([self.images count] > 0 || [self.source.images count] > 0) {
//        [view retain];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
            NSString *imgPath = nil;
            if ([self.images count] > 0) {
                imgPath = [[self.images objectAtIndex:0] stringByAppendingPathComponent:@"120"];
                NSString *imgTmpPath = [NSTemporaryDirectory() stringByAppendingFormat:@"/%@", [imgPath sha1Hash]];
                if (![[NSFileManager defaultManager] fileExistsAtPath:imgTmpPath]) {
                    NSURL *imageUrl = [NSURL URLWithString:imgPath];
                    NSData *data = [NSData dataWithContentsOfURL:imageUrl];
                    [data writeToFile:imgTmpPath atomically:YES];
                    
                }
                NSTextAttachment *imgAttachment = [TQTHelper imageAttatchmentOfPath:imgTmpPath];
//                [self.imgAttachment setAttachmentCell:[imgAttachment attachmentCell]];
                NSRange range = [[self.content string] rangeOfString:[NSString stringWithFormat:@"%C", NSAttachmentCharacter]];
                [self.content addAttributes:[NSDictionary dictionaryWithObject:imgAttachment forKey:NSAttachmentAttributeName] range:range];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [view setNeedsDisplay:YES];
                });
            }
            if ([self.source.images count] > 0) {
                imgPath = [[self.source.images objectAtIndex:0] stringByAppendingPathComponent:@"120"];
                NSString *imgTmpPath = [NSTemporaryDirectory() stringByAppendingFormat:@"/%@", [imgPath sha1Hash]];
                if (![[NSFileManager defaultManager] fileExistsAtPath:imgTmpPath]) {
                    NSURL *imageUrl = [NSURL URLWithString:imgPath];
                    NSData *data = [NSData dataWithContentsOfURL:imageUrl];
                    [data writeToFile:imgTmpPath atomically:YES];
                    
                }
                NSTextAttachment *imgAttachment = [TQTHelper imageAttatchmentOfPath:imgTmpPath];
//                [self.srcImgAttachment setAttachmentCell:[imgAttachment attachmentCell]];
                NSRange range = [[self.content string] rangeOfString:[NSString stringWithFormat:@"%C", NSAttachmentCharacter]];
                [self.content addAttributes:[NSDictionary dictionaryWithObject:imgAttachment forKey:NSAttachmentAttributeName] range:range];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [view setNeedsDisplay:YES];
                });
            }
        });
    }
    
}
@end
