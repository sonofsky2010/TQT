//
//  TQTWeiboRequest.h
//  TQT
//
//  Created by lishunnian on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TQTWeiBo.h"
@class QOauthKey;
@interface TQTWeiboRequest : NSObject {
@private
//    QOauthKey *oauthKey;
}

//@property QOauthKey *oauthKey;

- (NSMutableArray *)homeTimeLines;
- (int)postWeiboText:(NSString *)text;
- (NSString *)myIP;

@end
