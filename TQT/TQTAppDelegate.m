//
//  TQTAppDelegate.m
//  TQT
//
//  Created by lishunnian on 11-3-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TQTAppDelegate.h"
#import "QOauthKey.h"
#import "QOauth.h"
#import "QWeiboRequest.h"
#import "NSURL+QAdditions.h"
#import "SBJsonParser.h"
#import "TQTWeiBo.h"
#import "TQTLoginRequest.h"
#import "TQTUserRequest.h"
#import "TQTUser.h"
#import "TQTRootWindowController.h"
#import <WebKit/WebKit.h>


#define kAppKey @"14a6b38d5ffe47c7a9acd86902660cdd"
#define kAppSecret @"3016f15bfcf6990f4fb71b4a368d950f"
#define kRequestTokenUrl @"https://open.t.qq.com/cgi-bin/request_token"
#define kAuthorizeUrl @"http://open.t.qq.com/cgi-bin/authorize?oauth_token="

QOauthKey *oauthKey;

@implementation TQTAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    oauthKey = [[QOauthKey alloc] init];  
}

- (IBAction)login:(id)sender
{
//	TQTLoginRequest *loginRequest = [[TQTLoginRequest alloc] init];
	NSURL *url = [TQTLoginRequest authorizeRequestUrl];
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self
                                                       andSelector:@selector(handleVerify:withReplyEvent:) 
                                                     forEventClass:kInternetEventClass 
                                                        andEventID:kAEGetURL];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (void)handleVerify:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
    NSString *urlString = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    NSLog(@"urlString: %@", urlString);
    NSString *verifier = nil;
    if (!urlString) {
        //TODO:handle error
        goto ERROR;
    }
    NSDictionary *dict = [NSURL parseURLQueryString:urlString];
    verifier = [dict objectForKey:@"oauth_verifier"];
    if (!verifier) {
        //TODO: handl error
        goto ERROR;
    }
    TQTUser *user = nil;
    if ([TQTLoginRequest setAccessOauthkeyWithVerify:verifier])
    {
        TQTUserRequest *request = [[[TQTUserRequest alloc] init] autorelease];
        user = [request infoOfSelf];      
    }
    else
    {
        TQTUserRequest *request = [[[TQTUserRequest alloc] init] autorelease];
        user = [request infoOfSelf]; 
    }
    rootWindowController = [[TQTRootWindowController alloc] init];
    [NSBundle loadNibNamed:@"TQTRootWindowController" owner:rootWindowController];
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:[user.head stringByAppendingString:@"/100"]]];
    [rootWindowController.userImgView setImage:image];
    [rootWindowController.window makeKeyAndOrderFront:nil];
    [window orderOut:nil];
    NSLog(@"%@", user);  
    [[NSAppleEventManager sharedAppleEventManager] removeEventHandlerForEventClass:kInternetEventClass andEventID:kAEGetURL];
    
ERROR:
    [[NSAppleEventManager sharedAppleEventManager] removeEventHandlerForEventClass:kInternetEventClass andEventID:kAEGetURL];
    return;
}
@end
