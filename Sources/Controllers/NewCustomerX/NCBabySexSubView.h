//
//  NCBabySexSubView.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-21.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCRootSubView.h"

@interface NCBabySexSubView : NCRootSubView
<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray * selections;
}
@property int BabyNo;

@property NSString * value;
@property UIPickerView * pickerView;

-(id)initWithFrame:(CGRect)frame withDelegate:(id<NCSubViewDelegate>)delegate withBabyNo:(int)baby_no;

@end
