//
//  NCCustomerAddressSubView.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-21.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCCustomerAddressSubView.h"

@implementation NCCustomerAddressSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withDelegate:(id<NCSubViewDelegate>)delegate  withProvinces:(NSArray*)provinces withCities:(NSDictionary*)cities{
    self=[super initWithFrame:frame withDelegate:delegate];
    if(self){
        [self setBarTitle:NSLocalizedString(@"Address", @"地址")];
        
        CGRect pickerViewFrame = self.contentView.frame;
        pickerViewFrame.origin.y=0;
        pickerViewFrame.size.height-=130;
        
        _provinceArray=provinces;
        _province_city_dict=cities;
        _cityArray=@[@"..."];
        //_Log(@"NCCustomerAddressSubView\nprovinces=[%@]\ndict=[%@]",_provinceArray,_province_city_dict);
        
        _pickerView=[[UIPickerView alloc]initWithFrame:pickerViewFrame];
        
        [_pickerView setAutoresizesSubviews:YES];
        //[_pickerView setBackgroundColor:[UIColor yellowColor]];
        [_pickerView setDataSource:self];
        [_pickerView setDelegate:self];
        //[pickerView reloadAllComponents];
        [_pickerView setTintColor:[UIColor blackColor]];
        [self.contentView addSubview:_pickerView];
        
        _homeTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, pickerViewFrame.origin.y+pickerViewFrame.size.height+10, self.contentView.frame.size.width-20, 30)];
        [_homeTextField setBorderStyle:(UITextBorderStyleRoundedRect)];
        [_homeTextField setPlaceholder:NSLocalizedString(@"Address", @"地址")];
        [_homeTextField setReturnKeyType:(UIReturnKeyDone)];
        [_homeTextField setDelegate:self];
        [self.contentView addSubview:_homeTextField];
        
        
    }
    return self;
}

-(void)setWithCustomer:(LSCustomer *)customer{
    [_homeTextField setText:[customer theAddress]];
    
    [_pickerView selectRow:0 inComponent:0 animated:YES];
    [_pickerView selectRow:0 inComponent:1 animated:YES];
    
    int i=0;
    for (i=0; i<[_provinceArray count];  i++) {
        if([[_provinceArray objectAtIndex:i] isEqualToString:[customer theProvince]]){
            _LogLine();
            [_pickerView selectRow:i inComponent:0 animated:YES];
            [self pickerView:_pickerView didSelectRow:i inComponent:0];
        }
    }
    
    for (i=0; i<[_cityArray count];  i++) {
        if([[_cityArray objectAtIndex:i] isEqualToString:[customer theCity]]){
            _LogLine();
            [_pickerView selectRow:i inComponent:1 animated:YES];
            [self pickerView:_pickerView didSelectRow:i inComponent:1];
        }
    }
    
    [self pickerView:_pickerView didSelectRow:[_pickerView selectedRowInComponent:0] inComponent:0];
    [self pickerView:_pickerView didSelectRow:[_pickerView selectedRowInComponent:1] inComponent:1];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
#pragma mark UIPickerView Delegate

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSLog(@"pickerView numberOfRowsInComponent:[%d]",component);
    if (component==0) {
        return [_provinceArray count];
    }else{
        return [_cityArray count];
    }
}
/*
 -(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
 NSLog(@"pickerView titleForRow:%d,forComponent:%d as [%@]",row,component,[_selections objectAtIndex:row]);
 return [_selections objectAtIndex:row];
 }
 */
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)]; // your frame, so picker gets "colored"
    //label.backgroundColor = [UIColor lightGrayColor];
    [label setTextAlignment:(NSTextAlignmentCenter)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    if(component==0){
        label.text = [_provinceArray objectAtIndex:row];
    }else{
        label.text=[_cityArray objectAtIndex:row];
    }
    
    return label;
}
/*
 - (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
 return self.contentView.frame.size.width;
 }
 - (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
 return 40;
 }
 */

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"pickerView didSelectRow:%d inComponent:%d",row,component);
    @try {
        _value_province=[_provinceArray objectAtIndex:row];
    }
    @catch (NSException *exception) {
        //
    }
    @finally {
        //
    }

    if(component==0){
        _cityArray = [_province_city_dict objectForKey:_value_province];
        [pickerView reloadComponent:1];
    }else{
        //
    }
    
    @try {
        _value_city=[_cityArray objectAtIndex:row];
    }
    @catch (NSException *exception) {
        //
    }
    @finally {
        //
    }
    
    [self.delegate confirmCustomerProperty:(NCSubViewPropertyTypeCustomerProvince) withValue:_value_province];
    [self.delegate confirmCustomerProperty:(NCSubViewPropertyTypeCustomerCity) withValue:_value_city];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    //_Log(@"NCCustomerNameSubView textFieldDidEndEditing");
    self.value_home=textField.text;
    [self.delegate confirmCustomerProperty:(NCSubViewPropertyTypeCustomerHome) withValue:self.value_home];
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //_Log(@"NCCustomerNameSubView textFieldShouldReturn");
    [textField resignFirstResponder];
    return NO;
}
@end
