//
//  TQTAppDelegate.h
//  TQT
//
//  Created by lishunnian on 11-3-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QOauthKey.h"

@class TQTRootWindowController;
@interface TQTAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    BOOL loadLogin;
    IBOutlet NSTextField *textFiled;
    TQTRootWindowController *rootWindowController;
}

@property (assign) IBOutlet NSWindow *window;
- (void)loadWeibo;
- (IBAction)postVerfy:(id)sender;
- (IBAction)login:(id)sender;
@end
