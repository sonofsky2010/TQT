//
//  TQTWeiboDetailController.m
//  TQT
//
//  Created by Developer - No.11 Mac on 11-8-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TQTWeiboDetailController.h"
#import "TQTWeiBo.h"
#import "TQTWeiboCell.h"
#import "NSImage+TQTMask.h"
#import "TQTWeiboRequest.h"
@implementation TQTWeiboDetailController
@synthesize replyList = replyList_;
@synthesize rowNumber = rowNumber_;
@synthesize isReAdd = isReAdd_;
@synthesize replyTextField = replyTextField_;
@dynamic showWeibo;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)dealloc
{
    self.replyList = nil;
    [super dealloc];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [replyList_ count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return nil;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (!replyList_ || [replyList_ count] <= 0) {
        return;
    }
    if (row == [replyList_ count] - 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollToBottom" object:self];
    }
    if ([[tableColumn identifier] isEqualToString:@"TQTText"]) {
        TQTWeiBo *aWeibo = [replyList_ objectAtIndex:row];
        ((TQTWeiboCell *)cell).image = nil;
        ((TQTWeiboCell *)cell).weibo = aWeibo;
    }
    if ([[tableColumn identifier] isEqualToString:@"TQTHead"])
    {
        TQTWeiBo *aWeibo = [replyList_ objectAtIndex:row];
        NSImageCell *imgCell = (NSImageCell *)cell;
        NSString *headImgPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", [[aWeibo head] hash]]];
        NSImage *img = [[[NSImage alloc] initWithContentsOfFile:headImgPath] autorelease];
        if (!img) {
            dispatch_queue_t network_queue = dispatch_queue_create("TQT", NULL);
            dispatch_async(network_queue, ^(void){
                TQTWeiBo *aWeibo = [replyList_ objectAtIndex:row];
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
        else
        {
            NSImage *headMaskImage = [NSImage imageNamed:@"headmask"];
            img = [img maskWithImage:headMaskImage];
        }
        [imgCell setImage:img];
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    TQTWeiBo *aWeibo = [replyList_ objectAtIndex:row];
    aWeibo.source = nil;
    float height = 20.0f;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    [attrs setObject:[NSFont systemFontOfSize:12] forKey:NSFontAttributeName];
    NSString *text = aWeibo.origtext;
    NSSize textSize = [text sizeWithAttributes:attrs];
    CGFloat widht = [[tableView tableColumnWithIdentifier:@"TQTText"] width];
    int lineCount = ceil(textSize.width / widht);
    if (aWeibo.source && (aWeibo.type == 2)) {
        text = aWeibo.source.origtext;
        textSize = [aWeibo.source.origtext sizeWithAttributes:attrs];
        lineCount += ceil(textSize.width / widht);
        lineCount ++;
    }
    lineCount ++;
    height = height + (lineCount * textSize.height);
    height = height < 80 ? 80 : height;
    height += 8;
    return height;
}

- (void)changeSize:(NSNotification *)aNotification
{
    NSWindow *aWin = [self.window parentWindow];
    NSRect frame = [aWin frame];
    NSRect myFrame = [self.window frame];
    myFrame.origin.x = NSMaxX(frame);
    myFrame.origin.y = frame.origin.y + 20;
    [self.window setFrame:myFrame display:NO];
}

- (void)reload
{
    [replyTableView_ reloadData];
}

- (TQTWeiBo *)showWeibo
{
    return showWeibo_;
}
- (void)setShowWeibo:(TQTWeiBo *)aWeibo
{
    dispatch_queue_t network_queue = dispatch_queue_create("weibo list", NULL);
    if (showWeibo_ != aWeibo) {
        [aWeibo retain];
        [showWeibo_ autorelease];
        showWeibo_ = aWeibo;
    }
    dispatch_async(network_queue, ^(void){
        TQTWeiboRequest *request = [[[TQTWeiboRequest alloc] init] autorelease];
        self.replyList = [request replyListOfWeiboId:aWeibo.weiboId type:2 pageFlag:0 pageTime:0 reqNum:20 tId:0];
        int i = 0;
        for (i = 0; i < [replyList_ count]; i++)
        {
            TQTWeiBo *aw = [replyList_ objectAtIndex:i];
            if ([[aw origtext] length] <= 0) {
                [replyList_ removeObject:aw];
                i--;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [replyTableView_ reloadData];
            [[replyTableView_ superview] setNeedsDisplay:YES];
        });
    });
}

- (IBAction)closeWindow:(id)sender
{
    NSRect parentFrame = [self.window parentWindow].frame;
    NSRect selfFrame = [self.window frame];
    selfFrame.origin.x = parentFrame.origin.x;
    [self.window setFrame:selfFrame display:NO animate:YES];
    [[self.window parentWindow] removeChildWindow:self.window];
    [self.window orderOut:nil];
    
}

- (IBAction)reply:(id)sender
{
    TQTWeiboRequest *request = [[[TQTWeiboRequest alloc] init] autorelease];
    NSString *weiBoText = [replyTextField_ stringValue];
    if ((!weiBoText || [weiBoText length] <= 0)) {
        NSBeginAlertSheet(@"微博内容不能为空", 
                          @"确定",
                          nil,
                          nil, 
                          self.window, 
                          nil, 
                          NULL, 
                          NULL, 
                          NULL,
                          @"请在文本框中输入微博内容");
        return;
    }
    if ([weiBoText length] > 140)
    {
        NSBeginAlertSheet(@"字数太多", 
                          @"确定",
                          nil,
                          nil, 
                          self.window, 
                          nil, 
                          NULL, 
                          NULL, 
                          NULL,
                          @"您最多只能输入140个字符");
        return;
    }
    int ret;
    if (isReAdd_) {
        ret = [request reAdd:weiBoText weiboId:showWeibo_.weiboId];
    }
    else
    {
        ret = [request comment:weiBoText weiboId:showWeibo_.weiboId];
    }
}

@end
