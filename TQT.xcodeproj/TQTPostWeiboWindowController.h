//
//  TQTPostWeiboWindowController.h
//  TQT
//
//  Created by lishunnian on 11-7-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TQTPostWeiboWindowController : NSWindowController {
@private
    IBOutlet NSTextView *weiboTextView_;
    IBOutlet NSWindow *window_;
}

@property (retain) NSWindow *window;
- (IBAction)canclePost:(id)sender;
- (IBAction)post:(id)sender;
@end
