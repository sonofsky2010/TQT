//
//  TQTRootWindowController.h
//  TQT
//
//  Created by lishunnian on 11-7-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TQTWeiBoTableViewController.h"
#import "TQTWeiboRequest.h"
@class TQTPostWeiboWindowController;
@interface TQTRootWindowController : NSWindowController {
@private
    IBOutlet NSImageView *userImgView_;
    IBOutlet NSView* tableView_;
    IBOutlet NSWindow *window_;
    IBOutlet NSMatrix *silders_;
    IBOutlet NSTabView *tabView_;
    IBOutlet TQTWeiBoTableViewController *homeTimeLinesTableViewController;
    IBOutlet TQTWeiBoTableViewController *publicTimeLinesTableViewController;
    TQTPostWeiboWindowController *postWindowController;
    TQTWeiboRequest *weiboRequest_;
}

@property (assign, readonly) NSImageView *userImgView;
@property (assign, readonly) NSView *tableView;
@property (retain, readonly) NSTabView *tabView;
@property (retain) TQTWeiboRequest *weiboRequest;
- (IBAction)postWeibo:(id)sender;
- (IBAction)clickSlider:(id)sender;
- (IBAction)refresh:(id)sender;

- (void)reloadHomeTimeLines;
- (void)reloadPublicTimeLines;
@end
