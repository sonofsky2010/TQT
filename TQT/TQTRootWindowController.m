//
//  TQTRootWindowController.m
//  TQT
//
//  Created by lishunnian on 11-7-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TQTRootWindowController.h"


@implementation TQTRootWindowController

@synthesize userImgView = userImgView_;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
