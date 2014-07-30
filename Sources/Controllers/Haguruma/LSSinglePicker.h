//
//  LSSinglePicker.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-30.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSSinglePicker : UIControl
<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView * thePickerView;
    NSArray * level1Array;
}
@property (readonly) NSString* level1Value;
- (id)initWithFrame:(CGRect)frame withSelection:(NSArray*)selections;
-(void)setSelection:(NSString*)selection;
@end
