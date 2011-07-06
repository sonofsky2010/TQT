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
@implementation TQTLoginRequest

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
		oauthKey = [[QOauthKey alloc] init];	
    }
    
    return self;
}

- (void)dealloc
{
	[oauthKey release];
    [super dealloc];
}

- (NSURL *)authorizeRequestUrl
{
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
	return authorizeRequestUrl;
}

- (void)storeOauthKey:(QOauthKey *)aKey
{
	
}

- (QOauthKey *)lastStoreKey
{
	
}
@end
