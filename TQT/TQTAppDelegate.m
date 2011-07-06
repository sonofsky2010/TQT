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
#import <WebKit/WebKit.h>


#define kAppKey @"14a6b38d5ffe47c7a9acd86902660cdd"
#define kAppSecret @"3016f15bfcf6990f4fb71b4a368d950f"
#define kRequestTokenUrl @"https://open.t.qq.com/cgi-bin/request_token"
#define kAuthorizeUrl @"http://open.t.qq.com/cgi-bin/authorize?oauth_token="

@implementation TQTAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    oauthKey = [[QOauthKey alloc] init];
    oauthKey.consumerKey = kAppKey;
    oauthKey.consumerSecret = kAppSecret;
    oauthKey.callbackUrl = @"null";
    QWeiboRequest *request = [[QWeiboRequest alloc] init];
    NSString *responString = [request syncRequestWithUrl:kRequestTokenUrl httpMethod:@"GET" oauthKey:oauthKey parameters:nil files:nil];
    NSDictionary *responDict = [NSURL parseURLQueryString:responString];
    oauthKey.tokenKey = [responDict objectForKey:@"oauth_token"];
    oauthKey.tokenSecret = [responDict objectForKey:@"oauth_token_secret"];
    NSLog(@"tokenKey:%@", oauthKey.tokenKey);
    NSLog(@"tokenSecret:%@", oauthKey.tokenSecret);
    NSURL *authorizeRequestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAuthorizeUrl, oauthKey.tokenKey]];
    [[NSWorkspace sharedWorkspace] openURL:authorizeRequestUrl];

//    NSURLRequest *authorizeRequest = [NSURLRequest requestWithURL:authorizeRequestUrl];
//    WebView *webView = [[WebView alloc] initWithFrame:[[window contentView] bounds]];
//    [webView setFrameLoadDelegate:self];
//    [[webView mainFrame] loadRequest:authorizeRequest];
//    [webView setEditable:YES];
//    loadLogin = NO;
//    NSURLConnection *connection = [NSURLConnection connectionWithRequest:authorizeRequest delegate:self];    
}
- (IBAction)postVerfy:(id)sender
{
    oauthKey.verify = [textFiled stringValue];
    NSLog(@"%@", oauthKey.verify);
    [sender removeFromSuperview];
    QWeiboRequest *request = [[QWeiboRequest alloc] init];
    QOauthKey *key = [[QOauthKey alloc] init];
    key.consumerKey = oauthKey.consumerKey;
    key.consumerSecret = oauthKey.consumerSecret;
    key.tokenKey = oauthKey.tokenKey;
    key.tokenSecret = oauthKey.tokenSecret;
    key.verify = oauthKey.verify;
    NSString *response = [request syncRequestWithUrl:@"https://open.t.qq.com/cgi-bin/access_token"
                                          httpMethod:@"GET"
                                            oauthKey:key
                                          parameters:nil
                                               files:nil];
    [key release];
    NSDictionary *dict = [NSURL parseURLQueryString:response];
    NSLog(@"%@", dict);
    oauthKey.tokenKey = [dict objectForKey:@"oauth_token"];
    oauthKey.tokenSecret = [dict objectForKey:@"oauth_token_secret"];
    [self loadWeibo];
}
//- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
//{
//    if (!loadLogin) {
//        DOMDocument *document = [frame DOMDocument];
//        DOMNodeList *docList = [document getElementsByClassName:@"main"];
//        DOMNode *footer = [[document getElementsByClassName:@"wrapper foot"] item:0];
//        DOMElement *formLogin = [document getElementById:@"Login_Frame"];
//        DOMNode *main = [docList item:0];
//        DOMNode *body = [main parentNode];
//        DOMHTMLFormElement *form = (DOMHTMLFormElement *)[[document forms] item:0];
//        [document getElementById:@"u"].value = @"1034908295";
//        NSLog(@"%@", [document getElementById:@"p"].value);
//        [document getElementById:@"p"].value = @"sonofskysonofsky";
////        [form submit];
////        NSLog(@"%@", [form innerHTML]);
//        [body appendChild:formLogin];
//        [body removeChild:main];
//        [body removeChild:footer];
//        [[window contentView] addSubview:sender];
//        loadLogin = YES;
//        [sender setEditable:NO];
//    }
//}

- (void)webView:(WebView *)sender 
    willPerformClientRedirectToURL:(NSURL *)URL
    delay:(NSTimeInterval)seconds
    fireDate:(NSDate *)date
    forFrame:(WebFrame *)frame
{
    NSDictionary *dict = [NSURL parseURLQueryString:[URL absoluteString]];
    NSLog(@"%@", dict);
    NSString *str = (NSString *)[dict objectForKey:@"oauth_verifier"];
    if (str && ![str isEqualToString:@""]) {
        oauthKey.verify = str;
        NSLog(@"%@", oauthKey.verify);
        [sender removeFromSuperview];
        QWeiboRequest *request = [[QWeiboRequest alloc] init];
        QOauthKey *key = [[QOauthKey alloc] init];
        key.consumerKey = oauthKey.consumerKey;
        key.consumerSecret = oauthKey.consumerSecret;
        key.tokenKey = oauthKey.tokenKey;
        key.tokenSecret = oauthKey.tokenSecret;
        key.verify = oauthKey.verify;
        NSString *response = [request syncRequestWithUrl:@"https://open.t.qq.com/cgi-bin/access_token"
                                              httpMethod:@"GET"
                                                oauthKey:key
                                              parameters:nil
                                                   files:nil];
        [key release];
        NSDictionary *dict = [NSURL parseURLQueryString:response];
        NSLog(@"%@", dict);
        oauthKey.tokenKey = [dict objectForKey:@"oauth_token"];
        oauthKey.tokenSecret = [dict objectForKey:@"oauth_token_secret"];
        [self loadWeibo];
    }
//    [sender removeFromSuperview];
}

- (void)loadWeibo
{
    QWeiboRequest *request = [[QWeiboRequest alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"json" forKey:@"format"];
    [dict setObject:@"0" forKey:@"pos"];
    [dict setObject:@"2" forKey:@"reqnum"];
    NSString * response = [request syncRequestWithUrl:@"http://open.t.qq.com/api/statuses/public_timeline"
                                          httpMethod:@"GET"
                                            oauthKey:oauthKey
                                          parameters:dict
                                                files:nil];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSMutableDictionary *weiBo = [parser objectWithString:response];
    if ([[weiBo objectForKey:@"ret"] isEqual:[NSNumber numberWithInt:0]])
    {
        NSMutableDictionary *data = [weiBo objectForKey:@"data"];
        NSMutableArray *array = [data objectForKey:@"info"];
        for (NSMutableDictionary *aWeibo in array)
        {
            TQTWeiBo *aweibo = [TQTWeiBo weiBoFromDict:aWeibo];
        }
    }
//    NSLog(@"%@", response);
}
@end
