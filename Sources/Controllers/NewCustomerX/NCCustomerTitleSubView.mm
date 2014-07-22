//
//  NCCustomerTitleSubView.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-21.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCCustomerTitleSubView.h"

@implementation NCCustomerTitleSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withDelegate:(id<NCSubViewDelegate>)delegate{
    self=[super initWithFrame:frame withDelegate:delegate];
    if(self){
        [self setBarTitle:NSLocalizedString(@"Title", @"称呼")];
        
        CGRect pickerViewFrame = self.contentView.frame;
        pickerViewFrame.origin.y=10;
        
        selections=@[NSLocalizedString(@"Mr", @"先生"),NSLocalizedString(@"Ms", @"女士")];
        _pickerView=[[UIPickerView alloc]initWithFrame:pickerViewFrame];
        
        [_pickerView setAutoresizesSubviews:YES];
        //[_pickerView setBackgroundColor:[UIColor yellowColor]];
        [_pickerView setDataSource:self];
        [_pickerView setDelegate:self];
        //[pickerView reloadAllComponents];
        [_pickerView setTintColor:[UIColor blackColor]];
        [self.contentView addSubview:_pickerView];
        
        //[self pickerView:_pickerView didSelectRow:0 inComponent:0];
    }
    return self;
}

-(void)setWithCustomer:(LSCustomer *)customer{
    for (int i=0;i<[selections count];i++) {
        NSString *selection =[selections objectAtIndex:i];
        _Log(@"NCCustomerTitleSubView setWithCustomer %@~%@",selection,[customer theTitle]);
        if([selection isEqualToString:[customer theTitle]]){
            [[self pickerView]selectRow:i inComponent:0 animated:YES];
            [self pickerView:_pickerView didSelectRow:i inComponent:0];
            _Log(@"NCCustomerTitleSubView setWithCustomer %@=%@",selection,[customer theTitle]);
            return;
        }
    }
    [[self pickerView]selectRow:0 inComponent:0 animated:YES];
    [self pickerView:_pickerView didSelectRow:0 inComponent:0];
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
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSLog(@"pickerView numberOfRowsInComponent:[%d] as %d",component,[selections count]);
    return [selections count];
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
    label.text = [selections objectAtIndex:row];
    
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
    _value=[selections objectAtIndex:row];
    [self.delegate confirmCustomerProperty:(NCSubViewPropertyTypeCustomerTitle) withValue:_value];
}


@end
