//
//  TQTRootWindowController.m
//  TQT
//
//  Created by lishunnian on 11-7-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TQTUserRequest.h"
#import "TQTRootWindowController.h"
#import "TQTWeiBoTableViewController.h"
#import "TQTPostWeiboWindowController.h"
#import "QOauthKey.h"

@implementation TQTRootWindowController

@synthesize userImgView = userImgView_;
@synthesize tableView = tableView_;
@synthesize weiboRequest = weiboRequest_;
- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [tableViewController release];
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
//    [self reloadData];
}

- (void)reloadData
{
    TQTUserRequest *userRequest = [[[TQTUserRequest alloc] init] autorelease];
    TQTUser *user = [userRequest infoOfSelf];
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:[user.head stringByAppendingString:@"/100"]]];
    [self.userImgView setImage:image];
    [image release];
    self.weiboRequest = [[[TQTWeiboRequest alloc] init] autorelease];
    if (tableViewController == nil)
    {
        tableViewController = [[TQTWeiBoTableViewController alloc] initWithNibName:@"TQTWeiBoTableViewController" 
                                                                        bundle:nil];
        [tableView_ addSubview:tableViewController.view];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToBottom) name:@"ScrollToBottom" object:nil];
    }
    tableViewController.weibos = [weiboRequest_ homeTimeLines];
    [tableViewController.tableView reloadData];
}


- (IBAction)postWeibo:(id)sender
{
    postWindowController = [[TQTPostWeiboWindowController alloc] init];
    [NSBundle loadNibNamed:@"TQTPostWeiboWindow" owner:postWindowController];
    [NSApp beginSheet:postWindowController.window modalForWindow:[sender window] modalDelegate:self didEndSelector:@selector(endSheet:returnCode:contextInfo:) contextInfo:NULL];
}

- (void)endSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    if (returnCode == 1) {
        [self reloadData];
    }
    [postWindowController release];
    postWindowController = nil;
}

- (void)scrollToBottom
{
    if (tableViewController) {
        dispatch_queue_t network_queue = dispatch_queue_create("scroll to button", NULL);
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        dispatch_async(network_queue, ^(void){
            long timeStamp = [(TQTWeiBo *)[tableViewController.weibos lastObject] timeStamp];
            NSMutableArray *newWeibos = [weiboRequest_ homeTimeLinesWithType:1 OfTimeStamp:timeStamp];
            NSUInteger nowWeibosCount = [tableViewController.weibos count];
            if (newWeibos) {
               dispatch_async(dispatch_get_main_queue(), ^(void){                                   
                  [tableViewController.weibos addObjectsFromArray:newWeibos];
                  NSPoint scrollPoint = [[(NSScrollView *)tableViewController.view contentView] bounds].origin;
                  NSLog(@"%@", NSStringFromPoint(scrollPoint));
                  [tableViewController.tableView noteNumberOfRowsChanged];
                  //            dispatch_async(dispatch_get_main_queue(), ^(void){
                  //                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToBottom) name:@"ScrollToBottom" object:nil];
                  //            });
                  [[(NSScrollView *)tableViewController.view documentView] scrollPoint:scrollPoint];
               });
            }
        });
        [self performSelector:@selector(observeAgain) withObject:nil afterDelay:3];
    }
}

- (void)observeAgain
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToBottom) name:@"ScrollToBottom" object:nil];
}
@end
