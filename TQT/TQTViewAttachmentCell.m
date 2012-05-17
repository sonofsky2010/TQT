//
//  TQTAttachmentViewCell.m
//  TQT
//
//  Created by li shunnian on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TQTViewAttachmentCell.h"

@implementation TQTViewAttachmentCell
@synthesize drawView = drawView_;

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    if (drawView_) {
        drawView_.frame = cellFrame;
        for (NSView *view in [controlView subviews]) {
            if ([view isKindOfClass:[NSImageView class]] && view != drawView_) {
                [view removeFromSuperview];
            }
        }
        if (![[controlView subviews] containsObject:drawView_]) {
            [controlView addSubview:drawView_];
        }
    }
}

- (void)dealloc
{
    [self.drawView removeFromSuperview];
    self.drawView = nil;
    [super dealloc];
}
@end
