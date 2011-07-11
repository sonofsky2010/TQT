//
//  TQTLoginRequest.h
//  TQT
//
//  Created by lishunnian on 11-7-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QOauthKey;
@interface TQTLoginRequest : NSObject {
@private
}

+ (NSURL *)authorizeRequestUrl;
+ (BOOL)setAccessOauthkeyWithVerify:(NSString *)aVerify;
@end
