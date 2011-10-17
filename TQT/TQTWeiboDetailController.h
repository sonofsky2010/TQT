//
//  TQTWeiboDetailController.h
//  TQT
//
//  Created by Developer - No.11 Mac on 11-8-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TQTWeiBo.h"

@interface TQTWeiboDetailController : NSObject<NSTableViewDelegate, NSTableViewDataSource, NSDrawerDelegate>{
    NSMutableArray *replyList_;
    IBOutlet NSTableView *replyTableView_;
    IBOutlet NSTextField *replyTextField_;
    TQTWeiBo *showWeibo_;
    int rowNumber_;
    BOOL isReAdd_;
    IBOutlet NSDrawer *drawer_;
}

@property (retain) NSMutableArray *replyList;
@property (retain) TQTWeiBo *showWeibo;
@property (retain) NSTextField *replyTextField;
@property (assign) int rowNumber;
@property (assign) BOOL isReAdd;
@property (retain) NSDrawer *drawer;
- (IBAction)closeWindow:(id)sender;
- (IBAction)reply:(id)sender;
@end
