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
    IBOutlet NSTextField *fileNameLabel_;
    NSString *picPath_;
}

@property (retain) NSWindow *window;
@property (copy) NSString *picPath;
- (IBAction)canclePost:(id)sender;
- (IBAction)post:(id)sender;
- (IBAction)addPicture:(id)sender;
@end
