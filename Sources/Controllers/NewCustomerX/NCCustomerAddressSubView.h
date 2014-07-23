//
//  NCCustomerAddressSubView.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-21.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCRootSubView.h"

@interface NCCustomerAddressSubView : NCRootSubView
<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

@property NSArray * provinceArray;
@property NSArray * cityArray;
@property NSDictionary * province_city_dict;

@property NSString * value_province;
@property NSString * value_city;
@property NSString * value_home;

@property UIPickerView * pickerView;

@property UITextField * homeTextField;

-(id)initWithFrame:(CGRect)frame withDelegate:(id<NCSubViewDelegate>)delegate withProvinces:(NSArray*)provinces withCities:(NSDictionary*)cities;

@end
