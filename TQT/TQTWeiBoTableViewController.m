//
//  TQTWeiBoTableViewController.m
//  TQT
//
//  Created by lishunnian on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import "TQTWeiBo.h"
#import "TQTUser.h"
#import "TQTWeiboRequest.h"
#import "TQTWeiBoTableViewController.h"
#import "TQTWeiboCell.h"

@implementation TQTWeiBoTableViewController
@synthesize weibos = weibos_;
@synthesize tableView = tableView_;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [weibos_ count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    TQTWeiBo *aWeibo = [weibos_ objectAtIndex:row];
    if ([[tableColumn identifier] isEqualToString:@"TQTHead"]) {
        return [[[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:[[aWeibo head] stringByAppendingString:@"/50"]]] autorelease];
    }
    return nil;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (!weibos_ || [weibos_ count] <= 0) {
        return;
    }
    if ([[tableColumn identifier] isEqualToString:@"TQTText"]) {
        ((TQTWeiboCell *)cell).weibo = [weibos_ objectAtIndex:row];
    }
}

//- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
//{
//    return NO;
//}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    TQTWeiBo *aWeibo = [weibos_ objectAtIndex:row];
    float height = 20.0f;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    [attrs setObject:[NSFont systemFontOfSize:12] forKey:NSFontAttributeName];
    NSSize textSize = [aWeibo.text sizeWithAttributes:attrs];
    CGFloat widht = [[tableView tableColumnWithIdentifier:@"TQTText"] width];
    int lineCount = ceil(textSize.width / widht);
    height = height + (lineCount * textSize.height);
    if ([aWeibo.images count] > 0) {
        height += 128;
    }
    if (height < 80) {
        height = 80;
    }
    height += 8;
    return height;
}


@end
