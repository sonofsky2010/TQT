//
//  TQTImageViewAttachmentCell.h
//  TQT
//
//  Created by li shunnian on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TQTViewAttachmentCell.h"
@interface TQTImageViewAttachmentCell : TQTViewAttachmentCell
{
    NSString *imageUrlPath_;
}

@property (copy) NSString *imageUrlPath;
- (id)initWithImagePath:(NSString *)imageUrlPath;
@end
