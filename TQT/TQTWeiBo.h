//
//  TQTWeiBo.h
//  TQT
//
//  Created by lishunnian on 11-3-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TQTWeiBo : NSObject {
@private
    NSString *text_;
    NSString *origtext_;
    NSNumber *count_;
    NSNumber *mCount_;
    NSString *from_;
    NSMutableArray *images_;
    NSString *name_;
    NSString *nick_;
    long weiboId_;
    TQTWeiBo *source_;
    long timeStamp_;
    BOOL isSelf_;
    int type_;
    NSString *head_;
    NSString *location_;
    int countryCode_;
    int provinceCode_;
    int cityCode_;
    BOOL isVip_;
}

@property (copy) NSString *text;
@property (copy) NSString *origtext;
@property (retain) NSNumber *count;
@property (retain) NSNumber *mCount;
@property (copy) NSString *from;
@property (retain) NSMutableArray *images;
@property (copy) NSString *name;
@property (copy) NSString *nick;
@property (assign) long weiboId;
@property (retain) TQTWeiBo *source;
@property (assign) long timeStamp;
@property (assign) BOOL isSelf;
@property (assign) int type;
@property (copy) NSString *head;
@property (copy) NSString *location;
@property (assign) int countryCode;
@property (assign) int provinceCode;
@property (assign) int cityCode;
@property (assign) BOOL isVip;

- (id)initWithDict:(NSDictionary *)dict;
+ (TQTWeiBo *)weiBoFromDict:(NSDictionary *)dict;
- (NSDictionary *)dictionary;
- (NSString *)jsonString;
@end
