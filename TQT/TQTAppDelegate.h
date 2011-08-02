//
//  TQTAppDelegate.h
//  TQT
//
//  Created by lishunnian on 11-3-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QOauthKey.h"
#import "TQTWeiBoTableViewController.h"

@class TQTRootWindowController;
@interface TQTAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    BOOL loadLogin;
    IBOutlet NSTextField *textFiled;
    TQTRootWindowController *homeListWindowController;
    TQTRootWindowController *publicListWindowController;
    IBOutlet NSButton *checkLogin;
    QOauthKey *oauthKey;
}

@property (assign) IBOutlet NSWindow *window;
@property (retain) QOauthKey *oauthKey;
- (IBAction)login:(id)sender;
@end
