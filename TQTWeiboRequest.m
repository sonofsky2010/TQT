//
//  TQTWeiboRequest.m
//  TQT
//
//  Created by lishunnian on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import "SBJsonParser.h"
#import "TQTApiUrl.h"
#import "QWeiboRequest.h"
#import "TQTWeiboRequest.h"
#import "TQTWeiBo.h"
#import "TQTApiUrl.h"
#import "QOauthKey.h"
extern QOauthKey *oauthKey;
@implementation TQTWeiboRequest

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

- (BOOL)postWeibo:(TQTWeiBo *)weibo
{
    
}

- (NSMutableArray *)homeTimeLines
{
    QWeiboRequest *request = [[[QWeiboRequest alloc] init] autorelease];
    NSString *response = [request syncRequestWithUrl:kHomeTimeLineUrl httpMethod:@"GET" oauthKey:oauthKey parameters:nil files:nil];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSMutableDictionary *dict = [parser objectWithString:response];
    if (dict && [[dict objectForKey:@"msg"] isEqualToString:@"ok"])
    {
        NSArray *dicts = [[dict objectForKey:@"data"] objectForKey:@"info"];
        NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:[dicts count]];
        for (id aDict in dicts)
        {
            [weibos addObject:[TQTWeiBo weiBoFromDict:aDict]];
        }
        return weibos;
    }
    return nil;
}
@end
