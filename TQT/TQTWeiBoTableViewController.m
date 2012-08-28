//
//  TQTWeiBoTableViewController.m
//  TQT
//
//  Created by lishunnian on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import "TQTWeiBo.h"
#import "TQTUser.h"
#import "TQTWeiboRequest.h"
#import "TQTWeiBoTableViewController.h"
#import "TQTWeiboCell.h"
#import "NSImage+TQTMask.h"
#import "TQTWeiboDetailController.h"
#import "TQTAppDelegate.h"
#import "NSStringAdditions.h"
@implementation TQTWeiBoTableViewController
@synthesize weibos = weibos_;
@synthesize tableView = tableView_;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.

    }
    
    return self;
}

- (void)awakeFromNib
{
//    [tableView_ setCellSpacing:2.0f];
    [tableView_ setUsesLiveResize:YES];
}
- (void)dealloc
{
    self.weibos = nil;
    [super dealloc];
}

- (NSUInteger)numberOfRowsInListView:(PXListView *)aListView
{
    return [weibos_ count];
}

- (PXListViewCell *)listView:(PXListView *)aListView cellForRow:(NSUInteger)row
{
    
    TQTWeiboCell *weiboCell = (TQTWeiboCell *)[aListView dequeueCellWithReusableIdentifier:@"Weibo Cell"];
    if (!weiboCell) {
        weiboCell = [TQTWeiboCell cellLoadedFromNibNamed:@"TQTWeiboCell" reusableIdentifier:@"Weibo Cell"];
    }
    if (!weibos_ || [weibos_ count] <= 0) {
        return weiboCell;
    }
    TQTWeiBo *aWeibo = [weibos_ objectAtIndex:row];
    [weiboCell setWeibo:aWeibo];
    NSString *headImgPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[aWeibo head] sha1Hash]]];
    NSImage *img = [[[NSImage alloc] initWithContentsOfFile:headImgPath] autorelease];
    if (!img) {
        dispatch_queue_t network_queue = dispatch_queue_create("TQT", NULL);
        dispatch_async(network_queue, ^(void){
            TQTWeiBo *aWeibo = [weibos_ objectAtIndex:row];
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[aWeibo head] stringByAppendingString:@"/100"]]];
            if (imgData) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    NSImage *tmpImage = [[[NSImage alloc] initWithData:imgData] autorelease];
                    NSImage *cornerImage = [tmpImage imageWithXRadius:10.0 yRaidus:10.0];
                    if (![[NSFileManager defaultManager] fileExistsAtPath:headImgPath]) {
                        [[cornerImage TIFFRepresentation] writeToFile:headImgPath atomically:YES];
                    }
                    [[(TQTWeiboCell *)[aListView cellForRowAtIndex:row] headImagView] setImage:cornerImage];
                    [[(TQTWeiboCell *)[aListView cellForRowAtIndex:row] headImagView] setNeedsDisplay:YES];
                });
            }
        });
    }
    else
    {
        [weiboCell.headImagView setImage:img];
        [weiboCell.headImagView setNeedsDisplay:YES];
    }
    return weiboCell;
}

- (CGFloat)listView:(PXListView *)aListView heightOfRow:(NSUInteger)row
{
    NSSize size = [aListView bounds].size;
    size.width -= 97.f;
//    size.width = 191.f;
    TQTWeiBo *aWeibo = [weibos_ objectAtIndex:row];
    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithAttributedString:aWeibo.content] autorelease];
    NSTextContainer *textContainer = [[[NSTextContainer alloc]
                                       initWithContainerSize: NSMakeSize(size.width, FLT_MAX)] autorelease];
    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init]
                                      autorelease];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textContainer setLineFragmentPadding:5.0];
    [layoutManager glyphRangeForTextContainer:textContainer];
    CGFloat height = [layoutManager usedRectForTextContainer:textContainer].size.height;
    height += 20;
    if (height < 80) {
        return 80;
    }
    return height;
}

@end
