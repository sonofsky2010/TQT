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
#import "TQTWeiboRequest.h"
#import <WebKit/WebKit.h>
#import "TQTApiUrl.h"



QOauthKey *oauthKey;

@implementation TQTAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//    oauthKey = [[QOauthKey alloc] init];
    NSData *keyData = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessOauthKey];
    if (keyData) {
        oauthKey = [NSKeyedUnarchiver unarchiveObjectWithData:keyData];
    }
    if (oauthKey == nil) {
        [self.window makeKeyAndOrderFront:nil];
        oauthKey = [[QOauthKey alloc] init];
    }
    else
    {
        rootWindowController = [[TQTRootWindowController alloc] init];
        [NSBundle loadNibNamed:@"TQTRootWindowController" owner:rootWindowController];
        [rootWindowController.window makeKeyAndOrderFront:nil];
        [rootWindowController reloadData];
    }
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
//    TQTUser *user = nil;
    if (![TQTLoginRequest setAccessOauthkeyWithVerify:verifier])
    {
//        TQTUserRequest *request = [[[TQTUserRequest alloc] init] autorelease];
//        user = [request infoOfSelf];      
        goto ERROR;
    }
    
    if ([checkLogin state] == NSOnState)
    {
        NSData *keyData = [NSKeyedArchiver archivedDataWithRootObject:oauthKey];
        [[NSUserDefaults standardUserDefaults] setObject:keyData forKey:kAccessOauthKey];
        if (![[NSUserDefaults standardUserDefaults] synchronize])
        {
            //handle error of save defautlts
        }
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessOauthKey];
    }
    
    if (!rootWindowController) {
        rootWindowController = [[TQTRootWindowController alloc] init];
        [NSBundle loadNibNamed:@"TQTRootWindowController" owner:rootWindowController];
        [window orderOut:nil];
        [rootWindowController.window makeKeyAndOrderFront:nil];
    }
    [rootWindowController reloadData];
    [[NSAppleEventManager sharedAppleEventManager] removeEventHandlerForEventClass:kInternetEventClass andEventID:kAEGetURL];
    return;
    
ERROR:
    [[NSAppleEventManager sharedAppleEventManager] removeEventHandlerForEventClass:kInternetEventClass andEventID:kAEGetURL];
    return;
}

- (void)dealloc
{
    [oauthKey release];
    [super dealloc];
}
@end
