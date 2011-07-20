//
//  TQTWeiBoTableViewController.h
//  TQT
//
//  Created by lishunnian on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TQTWeiBoTableViewController : NSViewController<NSTableViewDataSource, NSTableViewDelegate> {
@private
    NSMutableArray *weibos_;
}

@property (retain) NSMutableArray *weibos;
@end
