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
- (NSMutableArray *)homeTimeLinesWithType:(int)type OfTimeStamp:(long)timeStamp;
- (int)postWeiboText:(NSString *)text;
- (int)postWeiboText:(NSString *)text withPicture:(NSString *)picPath;
- (NSString *)myIP;

@end
