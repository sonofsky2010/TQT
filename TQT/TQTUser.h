//
//  TQTUser.h
//  TQT
//
//  Created by lishunnian on 11-4-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TQTUser : NSObject {
@private
    NSString *name_;
    NSString *nick_;
    NSString *uid_;
    NSString *head_;
    NSString *location_;
    int countryCode_;
    int provinceCode_;
    int cityCode_;
    BOOL isVip_;
    BOOL isSent_;
    NSString *introduction_;
    NSString *verifyInfo_;
    int birthYear_;
    int birthMonth_;
    int birthDay_;
    int sex_;
    long fansNum_;
    long idolNum_;
    long tweetNum_;
    NSMutableArray *tag_;
}

@property (copy) NSString *name;
@property (copy) NSString *nick;
@property (copy) NSString *uid;
@property (copy) NSString *head;
@property (copy) NSString *location;
@property (assign) int countryCode;
@property (assign) int provinceCode;
@property (assign) int cityCode;
@property (assign) BOOL isVip;
@property (assign) BOOL isSent;
@property (copy) NSString *introduction;
@property (copy) NSString *verifyInfo;
@property (assign) int birthYear;
@property (assign) int birthMonth;
@property (assign) int birthDay;
@property (assign) int sex;
@property (assign) long fansNum;
@property (assign) long idolNum;
@property (assign) long tweetNum;
@property (retain) NSMutableArray *tag;

- (id)initWithDict:(NSDictionary *)dict;
@end
