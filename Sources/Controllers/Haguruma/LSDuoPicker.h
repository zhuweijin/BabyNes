//
//  LSDuoPicker.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-26.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSDuoPicker : UIControl
<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView * thePickerView;
    NSArray * level1Array;
    NSArray * level2Array;
    NSDictionary * duoMap;
}
@property (readonly) NSString* level1Value;
@property (readonly) NSString* level2Value;
- (id)initWithFrame:(CGRect)frame withProvinces:(NSArray*)provinces withCities:(NSDictionary*)cities;
-(void)setLevel1:(NSString*)l1 Level2:(NSString*)l2;
@end
