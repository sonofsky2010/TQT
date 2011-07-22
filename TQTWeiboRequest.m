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
#import "TQTAppDelegate.h"
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

- (int)postWeiboText:(NSString *)text
{
    QWeiboRequest *request = [[[QWeiboRequest alloc] init] autorelease];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"json" forKey:@"format"];
    [dict setObject:text forKey:@"content"];
    [dict setObject:[self myIP] forKey:@"clientip"];
    [dict setObject:@"" forKey:@"jing"];
    [dict setObject:@"" forKey:@"wei"];
    QOauthKey *oauthKey = [(TQTAppDelegate *)[[NSApplication sharedApplication] delegate] oauthKey];
    NSString *response = [request syncRequestWithUrl:kAddWeiboUrl
                                          httpMethod:@"POST" 
                                            oauthKey:oauthKey
                                          parameters:dict files:nil];
    if (!response) {
        return -1;
    }
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSMutableDictionary *retDict = [parser objectWithString:response];
    if (retDict && [[retDict objectForKey:@"ret"] intValue] == 0) {
        return [[retDict objectForKey:@"errcode"] intValue];
    }
    return -1;
}

- (NSMutableArray *)homeTimeLines
{
    QOauthKey *oauthKey = [(TQTAppDelegate *)[[NSApplication sharedApplication] delegate] oauthKey];
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

- (NSString *)myIP
{
    NSString *result = @"127.0.0.1";
    NSHost *currentHost = [NSHost currentHost];
    NSString *ad = [currentHost address];
    if (ad)
        return ad;
    return result;
}
@end
