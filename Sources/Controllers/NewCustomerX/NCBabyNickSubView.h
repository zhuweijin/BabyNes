//
//  NCBabyNickSubView.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-21.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCRootSubView.h"

@interface NCBabyNickSubView : NCRootSubView
<UITextFieldDelegate>
@property int BabyNo;
@property NSString * value;
@property UITextField * textField;
-(id)initWithFrame:(CGRect)frame withDelegate:(id<NCSubViewDelegate>)delegate withBabyNo:(int)baby_no;
@end
