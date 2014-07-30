//
//  LSMixTableCell.h
//  LSMixTableLib
//
//  Created by 倪 李俊 on 14-7-25.
//  Copyright (c) 2014年 Sinri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSCustomer.h"
#import "LSOptionalButton.h"
#import "LSDuoPicker.h"
#import "LSSinglePicker.h"

@protocol LSMixTableCellDelegate <NSObject>

-(LSCustomer*)getTheCustomer;
-(void)refresh;

@end

@interface LSMixTableCell : UITableViewCell
<UITextFieldDelegate>
{
    LSOptionalButton * optinalButton;
    UILabel * titleLabel;
    UILabel * previewLabel;
    UITextField * textFieldMain;
    UITextField * textFieldMore;
    //UIPickerView * picker;
    LSDuoPicker * picker;
    LSSinglePicker * singlePicker;
    UIDatePicker * datePicker;
    
    int baby_id;
    int valueType;
}
@property id<LSMixTableCellDelegate> MTDelegate;
+(void)setProvinces:(NSArray*)array;
+(void)setPCMap:(NSDictionary*)dict;
-(void)setSection:(int)section setWithRonriTag:(int)ronriRow;
-(void)setPreview:(NSString*)str;
-(void)setBabySexCell:(int)v;
@end
