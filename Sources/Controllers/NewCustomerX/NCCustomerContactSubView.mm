//
//  NCCustomerContactSubView.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-21.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCCustomerContactSubView.h"

@implementation NCCustomerContactSubView

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
        [self setBarTitle:NSLocalizedString(@"Contact", @"联系方式")];
        
        _textField_area = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
        [_textField_area setBorderStyle:(UITextBorderStyleRoundedRect)];
        [_textField_area setPlaceholder:NSLocalizedString(@"Area Code", @"地区号")];
        [_textField_area setReturnKeyType:(UIReturnKeyDone)];
        [_textField_area setDelegate:self];
        [self.contentView addSubview:_textField_area];
        
        _textField_mobile = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, self.contentView.frame.size.width-120-10, 30)];
        [_textField_mobile setBorderStyle:(UITextBorderStyleRoundedRect)];
        [_textField_mobile setPlaceholder:NSLocalizedString(@"Mobile", @"手机号")];
        [_textField_mobile setReturnKeyType:(UIReturnKeyDone)];
        [_textField_mobile setDelegate:self];
        [self.contentView addSubview:_textField_mobile];
        
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, self.contentView.frame.size.width-20, 30)];
        [label setLineBreakMode:(NSLineBreakByWordWrapping)];
        [label setNumberOfLines:0];
        [label setText:NSLocalizedString(@"Input the Area Code and mobile here.",@"请填写地区代号和手机号。")];
        [self.contentView addSubview:label];
        
        _textField_email = [[UITextField alloc]initWithFrame:CGRectMake(10, 90, self.contentView.frame.size.width-20, 30)];
        [_textField_email setBorderStyle:(UITextBorderStyleRoundedRect)];
        [_textField_email setPlaceholder:NSLocalizedString(@"Email(Optional)", @"电子邮件(可选)")];
        [_textField_email setReturnKeyType:(UIReturnKeyDone)];
        [_textField_email setDelegate:self];
        [self.contentView addSubview:_textField_email];
        
        UILabel * label_2=[[UILabel alloc]initWithFrame:CGRectMake(10, 130, self.contentView.frame.size.width-20, 30)];
        [label_2 setLineBreakMode:(NSLineBreakByWordWrapping)];
        [label_2 setNumberOfLines:0];
        [label_2 setText:NSLocalizedString(@"Input your email here. It is optional.",@"请填写电子邮箱。这是一个可选项。")];
        [self.contentView addSubview:label_2];
    }
    return self;
}

-(void)setWithCustomer:(LSCustomer *)customer{
    [_textField_area setText:[customer theAreaCode]];
    [_textField_mobile setText:[customer theMobile]];
    [_textField_email setText:[customer theEmail]];
    [self textFieldDidEndEditing:_textField_mobile];
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
    //_Log(@"NCCustomerNameSubView textFieldDidEndEditing");
    self.value_area=_textField_area.text;
    self.value_mobile=_textField_mobile.text;
    self.value_email=_textField_email.text;
    [self.delegate confirmCustomerProperty:(NCSubViewPropertyTypeCustomerAreaCode) withValue:self.value_area];
    [self.delegate confirmCustomerProperty:(NCSubViewPropertyTypeCustomerMobile) withValue:self.value_mobile];
    [self.delegate confirmCustomerProperty:(NCSubViewPropertyTypeCustomerEmail) withValue:self.value_email];
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //_Log(@"NCCustomerNameSubView textFieldShouldReturn");
    [textField resignFirstResponder];
    return NO;
}

@end
