//
//  TQTUserRequest.m
//  TQT
//
//  Created by lishunnian on 11-7-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TQTUserRequest.h"
#import "TQTLoginRequest.h"
#import "QOauthKey.h"
#import "TQTApiUrl.h"
#import "QOauth.h"
#import "QWeiboRequest.h"
#import "NSURL+QAdditions.h"
#import "SBJsonParser.h"
#import "TQTWeiBo.h"
extern QOauthKey *oauthKey;
@implementation TQTUserRequest

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

- (TQTUser *)infoOfSelf
{
    QWeiboRequest *request = [[[QWeiboRequest alloc] init] autorelease];
    NSString *response = [request syncRequestWithUrl:kUserInfoUrl httpMethod:@"GET" oauthKey:oauthKey parameters:nil files:nil];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSMutableDictionary *dict = [parser objectWithString:response];
    if (dict && [[dict objectForKey:@"msg"] isEqualToString:@"ok"]) {
        TQTUser *user = [[[TQTUser alloc] initWithDict:[dict objectForKey:@"data"]] autorelease];
        return user;
    }
    return nil;
}

- (BOOL)updateInfo:(TQTUser *)userInfo
{
    
}

@end
