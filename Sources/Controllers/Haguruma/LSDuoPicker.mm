//
//  LSDuoPicker.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-26.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSDuoPicker.h"

@implementation LSDuoPicker

- (id)initWithFrame:(CGRect)frame withProvinces:(NSArray*)provinces withCities:(NSDictionary*)cities
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect pickerViewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        //pickerViewFrame.origin.y=0;
        
        level1Array=provinces;
        duoMap=cities;
        level2Array=@[@"..."];
        
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
    return 2;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //NSLog(@"pickerView numberOfRowsInComponent:[%d]",component);
    if (component==0) {
        return [level1Array count];
    }else{
        return [level2Array count];
    }
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)]; // your frame, so picker gets "colored"
    //label.backgroundColor = [UIColor lightGrayColor];
    [label setTextAlignment:(NSTextAlignmentCenter)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    if(component==0){
        label.text = [level1Array objectAtIndex:row];
    }else{
        label.text=[level2Array objectAtIndex:row];
    }
    
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"pickerView didSelectRow:%d inComponent:%d",row,component);
    @try {
        _level1Value=[level1Array objectAtIndex:[pickerView selectedRowInComponent:0]];
    }
    @catch (NSException *exception) {
        _Log(@"LSDuoPicker Exception 1");
    }
    @finally {
        //
    }
    
    if(component==0){
        @try {
            level2Array = [duoMap objectForKey:_level1Value];
            [pickerView reloadComponent:1];
        }
        @catch (NSException *exception) {
            _Log(@"LSDuoPicker Exception 2");
        }
        @finally {
            //
        }
        
    }
    
    @try {
        _level2Value=[level2Array objectAtIndex:[pickerView selectedRowInComponent:1]];
    }
    @catch (NSException *exception) {
        _Log(@"LSDuoPicker Exception 3");
    }
    @finally {
        //
    }
    /*
    [self.delegate confirmCustomerProperty:(NCSubViewPropertyTypeCustomerProvince) withValue:_value_province];
    [self.delegate confirmCustomerProperty:(NCSubViewPropertyTypeCustomerCity) withValue:_value_city];
    */
    [self sendActionsForControlEvents:(UIControlEventValueChanged)];
}

-(void)setLevel1:(NSString*)l1 Level2:(NSString*)l2{
    _Log(@"setLevel1:%@ Level2:%@",l1,l2);
    
    [thePickerView selectRow:0 inComponent:0 animated:YES];
    [thePickerView selectRow:0 inComponent:1 animated:YES];
    
    int i=0;
    for (i=0; i<[level1Array count];  i++) {
        if([[level1Array objectAtIndex:i] isEqualToString:l1]){
            //_LogLine();
            [thePickerView selectRow:i inComponent:0 animated:YES];
            [self pickerView:thePickerView didSelectRow:i inComponent:0];
            break;
        }
    }
    
    [self pickerView:thePickerView didSelectRow:[thePickerView selectedRowInComponent:0] inComponent:0];
    
    for (i=0; i<[level2Array count];  i++) {
        if([[level2Array objectAtIndex:i] isEqualToString:l2]){
            //_LogLine();
            [thePickerView selectRow:i inComponent:1 animated:YES];
            [self pickerView:thePickerView didSelectRow:i inComponent:1];
            break;
        }
    }
    
    [self pickerView:thePickerView didSelectRow:[thePickerView selectedRowInComponent:1] inComponent:1];
    //[self sendActionsForControlEvents:(UIControlEventValueChanged)];
}

@end
