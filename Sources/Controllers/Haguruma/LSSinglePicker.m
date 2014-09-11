//
//  LSSinglePicker.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-30.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSSinglePicker.h"

@implementation LSSinglePicker

- (id)initWithFrame:(CGRect)frame withSelection:(NSArray*)selections{
    self=[super initWithFrame:frame];
    if(self){
        CGRect pickerViewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        //pickerViewFrame.origin.y=0;
        
        level1Array=selections;
        
        thePickerView=[[UIPickerView alloc]initWithFrame:pickerViewFrame];
        
        [thePickerView setAutoresizesSubviews:YES];
        //[_pickerView setBackgroundColor:[UIColor yellowColor]];
        [thePickerView setDataSource:self];
        [thePickerView setDelegate:self];
        //[pickerView reloadAllComponents];
        [thePickerView setTintColor:[UIColor blackColor]];
        [self addSubview:thePickerView];
    }
    return self;
}
-(void)setSelection:(NSString*)selection{
    _Log(@"setLevel1:%@",selection);
    
    [thePickerView selectRow:0 inComponent:0 animated:YES];
    
    int i=0;
    for (i=0; i<[level1Array count];  i++) {
        if([[level1Array objectAtIndex:i] isEqualToString:selection]){
            //_LogLine();
            [thePickerView selectRow:i inComponent:0 animated:YES];
            [self pickerView:thePickerView didSelectRow:i inComponent:0];
            break;
        }
    }
    
    [self pickerView:thePickerView didSelectRow:[thePickerView selectedRowInComponent:0] inComponent:0];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark picker
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //NSLog(@"pickerView numberOfRowsInComponent:[%d]",component);
    return [level1Array count];
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)]; // your frame, so picker gets "colored"
    //label.backgroundColor = [UIColor lightGrayColor];
    [label setTextAlignment:(NSTextAlignmentCenter)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    
    label.text = [level1Array objectAtIndex:row];
    
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"pickerView didSelectRow:%d inComponent:%d",row,component);
    @try {
        _level1Value=[level1Array objectAtIndex:[pickerView selectedRowInComponent:0]];
    }
    @catch (NSException *exception) {
        _Log(@"LSSinglePicker Exception 1");
    }
    @finally {
        //
    }
    [self sendActionsForControlEvents:(UIControlEventValueChanged)];
}


@end
