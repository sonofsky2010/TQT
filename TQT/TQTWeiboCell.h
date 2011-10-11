//
//  TQTWeiboCell.h
//  TQT
//
//  Created by lishunnian on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TQTWeiBo.h"
#import "PXListViewCell.h"

@interface TQTWeiboCell : PXListViewCell<NSTextViewDelegate> {
@private
    IBOutlet NSImageView *headImagView_;
    IBOutlet NSTextView *textView_;
    IBOutlet NSTextField *timeLabel_;
    TQTWeiBo *weibo_;
    BOOL hasImage_;
}

@property (retain) NSImageView *headImagView;
@property (retain) NSTextView *textView;
@property (retain) NSTextField *timeLabel;
@property (retain) TQTWeiBo *weibo;
@property (assign) BOOL hasImage;
@end
