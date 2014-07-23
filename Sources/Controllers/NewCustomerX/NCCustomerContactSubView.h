//
//  NCCustomerContactSubView.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-21.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCRootSubView.h"

@interface NCCustomerContactSubView : NCRootSubView
<UITextFieldDelegate>
@property NSString * value_area;
@property NSString * value_mobile;
@property NSString * value_email;
@property UITextField * textField_area;
@property UITextField * textField_mobile;
@property UITextField * textField_email;
@end
