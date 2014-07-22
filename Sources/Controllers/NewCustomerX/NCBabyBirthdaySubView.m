//
//  NCBabyBirthdaySubView.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-21.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCBabyBirthdaySubView.h"

@implementation NCBabyBirthdaySubView

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
        [self setBarTitle:NSLocalizedString(@"(Expected) Birthday", @"宝宝的生日/预产期")];
        
        CGRect pickerViewFrame = self.contentView.frame;
        pickerViewFrame.origin.y=10;
        
        //selections=@[NSLocalizedString(@"Boy", @"男"),NSLocalizedString(@"Girl", @"女")];
        _datePicker=[[UIDatePicker alloc]initWithFrame:pickerViewFrame];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker setAutoresizesSubviews:YES];
        //[_pickerView setBackgroundColor:[UIColor yellowColor]];
        [_datePicker addTarget:self action:@selector(onDatePicker:) forControlEvents:(UIControlEventValueChanged)];
        //[pickerView reloadAllComponents];
        [_datePicker setTintColor:[UIColor blackColor]];
        [self.contentView addSubview:_datePicker];
        
        
    }
    return self;
}

-(void)setWithBaby:(LSBaby *)baby{
    if([baby the_birth_date]){
        [_datePicker setDate:[baby the_birth_date]];
    }
    [self onDatePicker:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)onDatePicker:(id)sender{
    NSDate * result_date=_datePicker.date;
    [self.delegate confirmBabyBirthdayForNo:_BabyNo withDate:result_date];
}

@end
