//
//  TQTRootWindowController.m
//  TQT
//
//  Created by lishunnian on 11-7-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TQTUserRequest.h"
#import "TQTWeiboRequest.h"
#import "TQTRootWindowController.h"
#import "TQTWeiBoTableViewController.h"
#import "TQTPostWeiboWindowController.h"

@implementation TQTRootWindowController

@synthesize userImgView = userImgView_;
@synthesize tableView = tableView_;
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
    TQTWeiboRequest *weiboRequest = [[TQTWeiboRequest alloc] init];
    if (tableViewController == nil)
    {
        tableViewController = [[TQTWeiBoTableViewController alloc] initWithNibName:@"TQTWeiBoTableViewController" 
                                                                        bundle:nil];
        [tableView_ addSubview:tableViewController.view];
    }
    tableViewController.weibos = [weiboRequest homeTimeLines];
    [weiboRequest release];
    [tableViewController.tableView reloadData];
//    [(NSTableView *)[tableViewController view] reloadData];
//    [window_ setNeedDisplay:YES];
}


- (IBAction)postWeibo:(id)sender
{
    TQTPostWeiboWindowController *postWindowController = [[TQTPostWeiboWindowController alloc] init];
    [NSBundle loadNibNamed:@"TQTPostWeiboWindow" owner:postWindowController];
    [NSApp beginSheet:[postWindowController.window] modalForWindow:window_ modalDelegate:self didEndSelector:@selector(endSheet) contextInfo:NULL];
}
@end
