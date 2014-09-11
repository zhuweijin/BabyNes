//
//  NCCustomerNameSubView.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-21.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCRootSubView.h"

@interface NCCustomerNameSubView : NCRootSubView
<UITextFieldDelegate>
@property NSString * value;
@property UITextField * textField;
@end
