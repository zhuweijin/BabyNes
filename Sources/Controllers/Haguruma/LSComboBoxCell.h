//
//  LSComboBoxCell.h
//  BabyNesPOS_Akatsuki
//
//  Created by 倪 李俊 on 14-6-23.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSComboBox.h"

@interface LSComboBoxCell : UITableViewCell
@property UIButton* btn;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier forComboBox:(UIView*)comboBox withTag:(int)tag withText:(NSString *)text asFrame:(CGRect) frame;
-(void)loadforComboBox:(UIView*)comboBox withTag:(int)tag withText:(NSString *)text asFrame:(CGRect) frame;
@end
