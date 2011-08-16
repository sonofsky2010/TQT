//
//  TQTWeiBo.m
//  TQT
//
//  Created by lishunnian on 11-3-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TQTWeiBo.h"
#import "SBJsonWriter.h"

@implementation TQTWeiBo
@synthesize text = text_;
@synthesize origtext = origtext_;
@synthesize count = count_;
@synthesize mCount = mCount_;
@synthesize from = from_;
@synthesize images = images_;
@synthesize name = name_;
@synthesize nick = nick_;
@synthesize weiboId = weiboId_;
@synthesize source = source_;
@synthesize timeStamp = timeStamp_;
@synthesize isSelf = isSelf_;
@synthesize type = type_;
@synthesize head = head_;
@synthesize location = location_;
@synthesize countryCode = countryCode_;
@synthesize provinceCode = provinceCode_;
@synthesize cityCode = cityCode_;
@synthesize isVip = isVip_;
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
    if ([dict isEqualTo:[NSNull null]]) {
        return nil;
    }
    if (self)
    {
        self.text = [dict objectForKey:@"text"];
        self.origtext = [dict objectForKey:@"origtext"];
        self.count = [dict objectForKey:@"count"];
        self.mCount = [dict objectForKey:@"mcount"];
        self.from = [dict objectForKey:@"from"];
        self.weiboId = [[dict objectForKey:@"id"] longLongValue];
        if (![[dict objectForKey:@"image"] isEqualTo:[NSNull null]]) {
            self.images = [dict objectForKey:@"image"];
        }
//        self.images = [dict objectForKey:@"image"];
        self.name = [dict objectForKey:@"name"];
        self.nick = [dict objectForKey:@"nick"];
        if ([dict objectForKey:@"source"]) {
            self.source = [TQTWeiBo weiBoFromDict:[dict objectForKey:@"source"]];
        }
        self.timeStamp = [[dict objectForKey:@"timestamp"] longValue];
        self.isSelf = [[dict objectForKey:@"self"] boolValue];
        self.type = [[dict objectForKey:@"type"] intValue];
        self.head = [dict objectForKey:@"head"];
        self.location = [dict objectForKey:@"location"];
        self.countryCode = [[dict objectForKey:@"country_code"] intValue];
        self.provinceCode = [[dict objectForKey:@"province_code"] intValue];
        self.cityCode = [[dict objectForKey:@"city_code"] intValue];
        self.isVip = [[dict objectForKey:@"isvip"] boolValue];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

+ (TQTWeiBo *)weiBoFromDict:(NSDictionary *)dict
{
    TQTWeiBo *weibo = [[[TQTWeiBo alloc] initWithDict:dict] autorelease];

    return weibo;
}

- (NSDictionary *)dictionary
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:text_, @"text",
                          origtext_, @"origtext",
                          count_, @"count",
                          from_, @"from",
                          images_, @"image",
                          name_, @"name",
                          nick_, @"nick",
                          [source_ dictionary], @"source",
                          timeStamp_, @"timestamp",
                          [NSNumber numberWithBool:isSelf_], @"self",
                          [NSNumber numberWithInt:type_], @"type",
                          head_, @"head",
                          location_, @"location",
                          [NSNumber numberWithInt:countryCode_], @"country_code",
                          [NSNumber numberWithInt:provinceCode_], @"province_code",
                          [NSNumber numberWithInt:cityCode_], @"city_code",
                          [NSNumber numberWithBool:isVip_], @"isvip",
                          nil];
    return dict;
}

- (NSString *)jsonString
{
    NSDictionary *dict = [self dictionary];
    SBJsonWriter *jsonWriter = [[[SBJsonWriter alloc] init] autorelease];
    return [jsonWriter stringWithObject:dict];
}
@end
