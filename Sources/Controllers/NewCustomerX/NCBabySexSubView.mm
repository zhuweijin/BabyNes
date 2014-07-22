//
//  NCBabySexSubView.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-21.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCBabySexSubView.h"

@implementation NCBabySexSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withDelegate:(id<NCSubViewDelegate>)delegate withBabyNo:(int)baby_no{
    self=[super initWithFrame:frame withDelegate:delegate];
    if(self){
        _BabyNo=baby_no;
        [self setBarTitle:NSLocalizedString(@"Sex of baby", @"宝宝的性别")];
        
        CGRect pickerViewFrame = self.contentView.frame;
        pickerViewFrame.origin.y=10;
        
        selections=@[NSLocalizedString(@"Boy", @"男"),NSLocalizedString(@"Girl", @"女")];//,NSLocalizedString(@"Pregnant",@"胎儿")];
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

-(void)setWithCustomer:(LSCustomer*)customer{
    
}
-(void)setWithBaby:(LSBaby *)baby{
    for (int i=0;i<[selections count];i++) {
        NSString *selection =[selections objectAtIndex:i];
        if([selection isEqualToString:[baby the_sex]]){
            [self pickerView:_pickerView didSelectRow:i inComponent:0];
            [[self pickerView]selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
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

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"pickerView didSelectRow:%d inComponent:%d",row,component);
    _value=[selections objectAtIndex:row];
    [self.delegate confirmBabyProperty:(NCSubViewPropertyTypeBabySex) forNo:_BabyNo withValue:_value];
}
@end
