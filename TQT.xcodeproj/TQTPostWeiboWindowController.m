//
//  TQTPostWeiboWindowController.m
//  TQT
//
//  Created by lishunnian on 11-7-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TQTPostWeiboWindowController.h"
#import "TQTWeiboRequest.h"
#import "QOauthKey.h"
@interface TQTPostWeiboWindowController (private)
- (void)showErrorSheetWithCode:(int)errorCode;

@end

@implementation TQTPostWeiboWindowController (private)

- (void)showErrorSheetWithCode:(int)errorCode
{
    
}

@end

@implementation TQTPostWeiboWindowController

@synthesize window = window_;

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
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)canclePost:(id)sender
{
    [NSApp endSheet:window_ returnCode:0];
    [window_ orderOut:nil];
}
- (IBAction)post:(id)sender
{
    TQTWeiboRequest *request = [[[TQTWeiboRequest alloc] init] autorelease];
    NSString *weiBoText = [weiboTextView_ string];
    if (!weiBoText || [weiBoText length] <= 0) {
        NSBeginAlertSheet(@"微博内容不能为空", 
                          @"确定",
                          nil,
                          nil, 
                          window_, 
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
                          window_, 
                          nil, 
                          NULL, 
                          NULL, 
                          NULL,
                          @"您最多只能输入140个字符");
        return;
    }
    int ret = [request postWeiboText:weiBoText];
    if (ret==0) {
        [NSApp endSheet:window_ returnCode:1];
        [window_ orderOut:nil];
        return;
    } 
    [self showErrorSheetWithCode:ret];
}


@end
