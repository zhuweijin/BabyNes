//
//  NCTableViewCell.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-22.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

//#import <UIKit/UIKit.h>

#define NCTableViewCell_USE_LABEL
//#define NCTableViewCell_USE_TEXTFIELD

@interface NCTableViewCell : UITableViewCell
@property UILabel * cellTitle;
#ifdef NCTableViewCell_USE_LABEL
@property UILabel * cellPreview;
#endif
#ifdef NCTableViewCell_USE_TEXTFIELD
@property UITextField * cellText;
#endif
-(void)setCellWithTitle:(NSString *)title withPreview:(NSString*)preview asTag:(int)tag;
-(void)setCellWithPreview:(NSString*)preview;
@end
