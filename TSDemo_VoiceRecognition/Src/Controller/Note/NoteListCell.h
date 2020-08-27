//
//  NoteListCell.h
//  Voice2Note
//
//  Created by ciyouzen on 14-6-12.
//  Copyright (c) 2014年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VNNote.h"

@interface NoteListCell : UITableViewCell

+ (CGFloat)heightWithNote:(VNNote *)note;
- (void)updateWithNote:(VNNote *)note;

@end
