//
//  TQTLoginRequest.m
//  TQT
//
//  Created by lishunnian on 11-7-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TQTLoginRequest.h"
#import "QOauthKey.h"
#import "TQTApiUrl.h"
#import "QOauth.h"
#import "QWeiboRequest.h"
#import "NSURL+QAdditions.h"
#import "SBJsonParser.h"
#import "TQTWeiBo.h"
#import "TQTAppDelegate.h"
extern QOauthKey *oauthKey;
@implementation TQTLoginRequest
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

+ (NSURL *)authorizeRequestUrl
{
    if (oauthKey) {
        [oauthKey autorelease];
        oauthKey = [[QOauthKey alloc] init];
    }
    oauthKey.consumerKey = kAppKey;
    oauthKey.consumerSecret = kAppSecret;
    oauthKey.callbackUrl = @"TQT://www.qq.com/";
    QWeiboRequest *request = [[QWeiboRequest alloc] init];
    NSString *responString = [request syncRequestWithUrl:kRequestTokenUrl httpMethod:@"GET" oauthKey:oauthKey parameters:nil files:nil];
    NSDictionary *responDict = [NSURL parseURLQueryString:responString];
    oauthKey.tokenKey = [responDict objectForKey:@"oauth_token"];
    oauthKey.tokenSecret = [responDict objectForKey:@"oauth_token_secret"];
    NSLog(@"tokenKey:%@", oauthKey.tokenKey);
    NSLog(@"tokenSecret:%@", oauthKey.tokenSecret);
    NSURL *authorizeRequestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAuthorizeUrl, oauthKey.tokenKey]];
	return authorizeRequestUrl;
}

+ (BOOL)setAccessOauthkeyWithVerify:(NSString *)aVerify
{
    oauthKey.verify = aVerify;
    NSLog(@"%@", oauthKey.verify);
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
    [request release];
    NSDictionary *dict = [NSURL parseURLQueryString:response];
    NSLog(@"%@", dict);
    if (![dict objectForKey:@"oauth_token"] || ![dict objectForKey:@"oauth_token_secret"]) {
        return NO;
    }
    oauthKey.tokenKey = [dict objectForKey:@"oauth_token"];
    oauthKey.tokenSecret = [dict objectForKey:@"oauth_token_secret"];
    return YES;
}

- (void)storeOauthKey:(QOauthKey *)aKey
{
	
}

- (QOauthKey *)lastStoreKey
{
	return nil;
}
@end
