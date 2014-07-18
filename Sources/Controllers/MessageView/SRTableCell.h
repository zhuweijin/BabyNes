//
//  SRTableCell.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-17.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRMessage.h"

@interface SRTableCell : UITableViewCell
@property SRMessage * msg;
@property UIView * lineView;
@property UILabel * titleLabel;
@property UILabel * timeLabel;
-(void)setSRMessage:(SRMessage*)sr_msg;
@end
