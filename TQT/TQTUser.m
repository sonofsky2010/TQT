//
//  TQTUser.m
//  TQT
//
//  Created by lishunnian on 11-4-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TQTUser.h"

@implementation TQTUser

@synthesize name = name_;
@synthesize nick = nick_;
@synthesize uid = uid_;
@synthesize head = head_;
@synthesize location = location_;
@synthesize countryCode = countryCode_;
@synthesize provinceCode = provinceCode_;
@synthesize cityCode = cityCode_;
@synthesize isVip = isVip_;
@synthesize isSent = isSent_;
@synthesize introduction = introduction_;
@synthesize verifyInfo = verifyInfo_;
@synthesize birthYear = birthYear_;
@synthesize birthMonth = birthMonth_;
@synthesize birthDay = birthDay_;
@synthesize sex = sex_;
@synthesize fansNum = fansNum_;
@synthesize idolNum = idolNum_;
@synthesize tweetNum = tweetNum_;
@synthesize tag = tag_;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.name = [dict objectForKey:@"name"];
        self.nick = [dict objectForKey:@"nick"];
        self.uid = [dict objectForKey:@"uid"];
        self.head = [dict objectForKey:@"head"];
        self.location = [dict objectForKey:@"location"];
        self.countryCode = [[dict objectForKey:@"country_code"] intValue];
        self.provinceCode = [[dict objectForKey:@"province_code"] intValue];
        self.cityCode = [[dict objectForKey:@"city_code"] intValue];
        self.isVip = [[dict objectForKey:@"isvip"] boolValue];
        self.isSent = [[dict objectForKey:@"isent"] boolValue];
        self.introduction = [dict objectForKey:@"introduction"];
        self.verifyInfo = [dict objectForKey:@"verifyinfo"];
        self.birthYear =[[dict objectForKey:@"birth_year"] intValue];
        self.birthMonth = [[dict objectForKey:@"birth_month"] intValue];
        self.birthDay = [[dict objectForKey:@"birth_day"] intValue];
        self.sex = [[dict objectForKey:@"sex"] boolValue];
        self.fansNum = [[dict objectForKey:@"fansnum"] longValue];
        self.idolNum = [[dict objectForKey:@"idolnum"] longValue];
        self.tweetNum = [[dict objectForKey:@"tweetnum"] longValue];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
