//
//  NCCustomerTitleSubView.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-21.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCRootSubView.h"

@interface NCCustomerTitleSubView : NCRootSubView
<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray * selections;
}

@property NSString * value;
@property UIPickerView * pickerView;

@end
