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
#import "NSImage+TQTMask.h"

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
    [homeTimeLinesTableViewController release];
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
//    [self reloadData];
}

- (IBAction)refresh:(id)sender
{
	[self reloadHomeTimeLines];
}

- (IBAction)clickSlider:(id)sender
{
    NSMatrix *bars = (NSMatrix *)sender;
    if ([bars selectedTag] == 1) {
        [self reloadPublicTimeLines];
    }
}

- (void)reloadHomeTimeLines
{
    TQTUserRequest *userRequest = [[[TQTUserRequest alloc] init] autorelease];
    dispatch_queue_t network_queue = dispatch_queue_create("hometimes", NULL);
    dispatch_async(network_queue, ^(void){
        TQTUser *user = [userRequest infoOfSelf];
        NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:[user.head stringByAppendingString:@"/100"]]];
        NSImage *headMaskImage = [NSImage imageNamed:@"headmask"];
        NSImage *maskedImage = [image maskWithImage:headMaskImage];
        [image release];
        [self.userImgView setImage:maskedImage];
        TQTWeiboRequest *request = [[[TQTWeiboRequest alloc] init] autorelease];
        if (homeTimeLinesTableViewController == nil) {
            homeTimeLinesTableViewController = [[TQTWeiBoTableViewController alloc] initWithNibName:@"TQTWeiBoTableViewController" 
                                                                                             bundle:nil];
            for(NSView *aView in [tableView_ subviews]) {
                [aView removeFromSuperview];
            }
            [tableView_ addSubview:homeTimeLinesTableViewController.view];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeTimeLineScrollToBottom) name:@"ScrollToBottom" object:nil];
        }
        homeTimeLinesTableViewController.weibos = [request homeTimeLines];
        [homeTimeLinesTableViewController.tableView reloadData];
    });
}

- (void)reloadPublicTimeLines
{
    dispatch_queue_t network_queue = dispatch_queue_create("public", NULL);
    dispatch_async(network_queue, ^(void){
        TQTWeiboRequest *request = [[[TQTWeiboRequest alloc] init] autorelease];
        if (publicTimeLinesTableViewController == nil) {
            publicTimeLinesTableViewController = [[TQTWeiBoTableViewController alloc] initWithNibName:@"TQTWeiBoTableViewController"
                                                                                               bundle:nil];
            for(NSView *aView in [tableView_ subviews]) {
                [aView removeFromSuperview];
            }
            [tableView_ addSubview:publicTimeLinesTableViewController.view];
        }
        publicTimeLinesTableViewController.weibos = [request publicTimeLines];
        [publicTimeLinesTableViewController.tableView reloadData];
    });
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
        [self reloadHomeTimeLines];
    }
    [postWindowController release];
    postWindowController = nil;
}

- (void)homeTimeLineScrollToBottom
{
    if (homeTimeLinesTableViewController) {
        dispatch_queue_t network_queue = dispatch_queue_create("scroll to button", NULL);
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        dispatch_async(network_queue, ^(void){
            long timeStamp = [(TQTWeiBo *)[homeTimeLinesTableViewController.weibos lastObject] timeStamp];
            TQTWeiboRequest *request = [[[TQTWeiboRequest alloc] init] autorelease];
            NSMutableArray *newWeibos = [request homeTimeLinesWithType:1 OfTimeStamp:timeStamp];
            if (newWeibos) {
               dispatch_async(dispatch_get_main_queue(), ^(void){                                   
                   [homeTimeLinesTableViewController.weibos addObjectsFromArray:newWeibos];
                   NSPoint scrollPoint = [[(NSScrollView *)homeTimeLinesTableViewController.view contentView] bounds].origin;
                   [homeTimeLinesTableViewController.tableView noteNumberOfRowsChanged];
                   [[(NSScrollView *)homeTimeLinesTableViewController.view documentView] scrollPoint:scrollPoint];
               });
            }
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3LL*NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeTimeLineScrollToBottom) name:@"ScrollToBottom" object:nil];
        });

    }
}

@end
