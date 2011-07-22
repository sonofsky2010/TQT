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

- (void)dealloc
{
    [super dealloc];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [weibos_ count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return nil;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (!weibos_ || [weibos_ count] <= 0) {
        return;
    }
    if ([[tableColumn identifier] isEqualToString:@"TQTText"]) {
        ((TQTWeiboCell *)cell).weibo = [weibos_ objectAtIndex:row];
    }
    if ([[tableColumn identifier] isEqualToString:@"TQTHead"])
    {
        TQTWeiBo *aWeibo = [weibos_ objectAtIndex:row];
        NSImageCell *imgCell = (NSImageCell *)cell;
        NSString *headImgPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", [[aWeibo head] hash]]];
        NSImage *img = [[NSImage alloc] initWithContentsOfFile:headImgPath];
        if (!img) {
            dispatch_queue_t network_queue = dispatch_queue_create("TQT", NULL);
            dispatch_async(network_queue, ^(void){
                TQTWeiBo *aWeibo = [weibos_ objectAtIndex:row];
                NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[aWeibo head] stringByAppendingString:@"/50"]]];
                if (imgData) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        if (![[NSFileManager defaultManager] fileExistsAtPath:headImgPath]) {
                            [imgData writeToFile:headImgPath atomically:YES];
                        }
                        [[tableColumn tableView] reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
                    });
                }
            });
            return;
        }
        [imgCell setImage:img];
    }
}


- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    TQTWeiBo *aWeibo = [weibos_ objectAtIndex:row];
    float height = 20.0f;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    [attrs setObject:[NSFont systemFontOfSize:12] forKey:NSFontAttributeName];
    NSString *text = aWeibo.origtext;
    NSSize textSize = [text sizeWithAttributes:attrs];
    CGFloat widht = [[tableView tableColumnWithIdentifier:@"TQTText"] width];
    int lineCount = ceil(textSize.width / widht);
    if (aWeibo.source && aWeibo.type == 2) {
        text = aWeibo.source.origtext;
        textSize = [aWeibo.source.origtext sizeWithAttributes:attrs];
        lineCount += ceil(textSize.width / widht);
        lineCount ++;
    }
    lineCount ++;
    height = height + (lineCount * textSize.height);
    if ([aWeibo.images count] > 0) {
        height += 128;
    }
    if ([aWeibo source] &&aWeibo.type == 2 && [[[aWeibo source] images] count] > 0) {
        height += 128;
    }
    height = height < 80 ? 80 : height;
    height += 8;
    return height;
}


@end
