//
//  TQTHelper.h
//  TQT
//
//  Created by li shunnian on 12-5-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TQTHelper : NSObject
+ (NSTextAttachment *)imageAttatchmentOfPath:(NSString *)path;
+ (NSTextAttachment *)imageAttatchmentOfUrl:(NSURL *)url;
@end
