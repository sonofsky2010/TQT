//
//  QOauthKey.m
//  QWeiboSDK4iOS
//
//  Created on 11-1-12.
//  
//

#import "QOauthKey.h"


@implementation QOauthKey

#pragma mark -
#pragma mark public variables

@synthesize consumerKey;
@synthesize consumerSecret;
@synthesize tokenKey;
@synthesize tokenSecret;
@synthesize verify;
@synthesize callbackUrl;


- (id)initWithCoder:(NSCoder *)coder
{
//    self = [super initWithCoder:coder];
    self = [super init];
    if (self != nil) {
        self.consumerKey = [coder decodeObjectForKey:@"consumerKey"];
        self.consumerSecret = [coder decodeObjectForKey:@"consumerSecret"];
        self.tokenKey = [coder decodeObjectForKey:@"tokenKey"];
        self.tokenSecret = [coder decodeObjectForKey:@"tokenSecret"];
        self.verify = [coder decodeObjectForKey:@"verify"];
        self.callbackUrl = [coder decodeObjectForKey:@"callbackUrl"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
//    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:consumerKey forKey:@"consumerKey"];
    [aCoder encodeObject:consumerSecret forKey:@"consumerSecret"];
    [aCoder encodeObject:tokenKey forKey:@"tokenKey"];
    [aCoder encodeObject:tokenSecret forKey:@"tokenSecret"];
    [aCoder encodeObject:verify forKey:@"verify"];
    [aCoder encodeObject:callbackUrl forKey:@"callbackUrl"];
}
@end
