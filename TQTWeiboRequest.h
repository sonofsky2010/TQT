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
- (NSMutableArray *)publicTimeLines;
- (NSMutableArray *)publicTimeLinesWithType:(int)type ofTimeStamp:(long)timeStamp reqNum:(int)number;
- (int)postWeiboText:(NSString *)text;
- (int)postWeiboText:(NSString *)text withPicture:(NSString *)picPath;
- (NSString *)myIP;
- (NSMutableArray *)replyListOfWeiboId:(long long) weiboId 
                                  type:(int)flag
                              pageFlag:(int)pageFlag
                              pageTime:(long)pageTime
                                reqNum:(int)reqNum 
                                   tId:(long long)tId;

- (int)reply:(NSString *)content weiboId:(long long)weiboId;
- (int)reAdd:(NSString *)content weiboId:(long long)weiboId;
- (int)comment:(NSString *)content weiboId:(long long)weiboId;
@end
