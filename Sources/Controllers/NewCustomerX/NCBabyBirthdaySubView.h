//
//  NCBabyBirthdaySubView.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-21.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCRootSubView.h"

@interface NCBabyBirthdaySubView : NCRootSubView
{
    NSArray * yearArray;
    NSArray * monthArray;
    NSArray * dayArray;
}
@property int BabyNo;

@property NSString * value;
@property UIDatePicker * datePicker;

-(id)initWithFrame:(CGRect)frame withDelegate:(id<NCSubViewDelegate>)delegate withBabyNo:(int)baby_no;
@end
