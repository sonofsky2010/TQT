//
//  TQTAppDelegate.h
//  TQT
//
//  Created by lishunnian on 11-3-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QOauthKey.h"
@interface TQTAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    BOOL loadLogin;
    QOauthKey *oauthKey;
    IBOutlet NSTextField *textFiled;
}

@property (assign) IBOutlet NSWindow *window;

- (void)loadWeibo;

- (IBAction)postVerfy:(id)sender;
@end
