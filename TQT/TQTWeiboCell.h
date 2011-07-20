//
//  TQTWeiboCell.h
//  TQT
//
//  Created by lishunnian on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TQTWeiBo.h"

@interface TQTWeiboCell : NSTextFieldCell {
@private
    NSImageCell *imageCell_;
    NSTextFieldCell *nickCell_;
    NSTextFieldCell *timeCell_;
    TQTWeiBo *weibo_;
}

@property (retain) TQTWeiBo *weibo;
@property (retain) NSImageCell *imageCell;
@property (retain) NSTextFieldCell *nickCell;
@property (retain) NSTextFieldCell *timeCell;
@end
