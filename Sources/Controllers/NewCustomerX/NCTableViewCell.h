//
//  NCTableViewCell.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-22.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

//#import <UIKit/UIKit.h>

@interface NCTableViewCell : UITableViewCell
@property UILabel * cellTitle;
@property UILabel * cellPreview;
-(void)setCellWithTitle:(NSString *)title withPreview:(NSString*)preview;
-(void)setCellWithPreview:(NSString*)preview;
@end
