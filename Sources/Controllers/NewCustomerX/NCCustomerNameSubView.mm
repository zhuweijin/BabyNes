//
//  NCCustomerNameSubView.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-21.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCCustomerNameSubView.h"

@implementation NCCustomerNameSubView

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
        [self setBarTitle:NSLocalizedString(@"Name", @"姓名")];
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, self.contentView.frame.size.width-20, 30)];
        [_textField setBorderStyle:(UITextBorderStyleRoundedRect)];
        [_textField setPlaceholder:NSLocalizedString(@"* Name:", @"* 姓名：")];
        [_textField setReturnKeyType:(UIReturnKeyDone)];
        [_textField setDelegate:self];
        [self.contentView addSubview:_textField];
    }
    return self;
}

-(void)setWithCustomer:(LSCustomer *)customer{
    [_textField setText:[customer theName]];
    [self textFieldDidEndEditing:_textField];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)textFieldDidEndEditing:(UITextField *)textField{
    _Log(@"NCCustomerNameSubView textFieldDidEndEditing");
    self.value=textField.text;
    [self.delegate confirmCustomerProperty:(NCSubViewPropertyTypeCustomerName) withValue:self.value];
    [_textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    _Log(@"NCCustomerNameSubView textFieldShouldReturn");
    [_textField resignFirstResponder];
    return NO;
}

@end
