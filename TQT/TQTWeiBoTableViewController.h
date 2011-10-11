//
//  TQTWeiBoTableViewController.h
//  TQT
//
//  Created by lishunnian on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PXListView.h"

@interface TQTWeiBoTableViewController : NSViewController<PXListViewDelegate> {
@private
    NSMutableArray *weibos_;
    IBOutlet PXListView *tableView_;
}

@property (retain) NSMutableArray *weibos;
@property (readonly) PXListView *tableView;
- (NSImage *)maskImage:(NSImage *)headImage withMaskImage:(NSImage *)maskImage;
@end
