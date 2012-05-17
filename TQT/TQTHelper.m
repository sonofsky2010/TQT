//
//  TQTHelper.m
//  TQT
//
//  Created by li shunnian on 12-5-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TQTHelper.h"

@implementation TQTHelper
+ (NSTextAttachment *)imageAttatchmentOfPath:(NSString *)path
{
    NSURL *imgUrl = [NSURL URLWithString:path];
    if (!imgUrl) {
        imgUrl = [NSURL fileURLWithPath:path];
    }
    if (!imgUrl) {
        return nil;
    }
    
    return [self imageAttatchmentOfUrl:imgUrl];
}

+ (NSTextAttachment *)imageAttatchmentOfUrl:(NSURL *)url
{
    NSString *imgHtmlFormat = @"<html><body><div><img src=\"%@\" height=\"120\"/></div></body></html>";
    NSString *imgHtmlString = [NSString stringWithFormat:imgHtmlFormat, [url absoluteString]];
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithHTML:[imgHtmlString dataUsingEncoding:NSUTF8StringEncoding] options:nil documentAttributes:NULL];
    NSDictionary *dict = [attStr attributesAtIndex:0 effectiveRange:NULL];
    NSTextAttachment *imgAttachment = [dict objectForKey:NSAttachmentAttributeName];
    return imgAttachment;
}
@end
