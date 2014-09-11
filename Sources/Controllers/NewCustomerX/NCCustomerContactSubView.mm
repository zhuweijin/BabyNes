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
        
        CGFloat y=10;
        
        _textField_mobile = [[UITextField alloc]initWithFrame:CGRectMake(10, y, self.contentView.frame.size.width-20, 30)];
        [_textField_mobile setBorderStyle:(UITextBorderStyleRoundedRect)];
        [_textField_mobile setPlaceholder:NSLocalizedString(@"Mobile", @"手机号")];
        [_textField_mobile setReturnKeyType:(UIReturnKeyDone)];
        [_textField_mobile setDelegate:self];
        [self.contentView addSubview:_textField_mobile];
        
        y+=40;
        
        UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.contentView.frame.size.width-20, 30)];
        [label1 setLineBreakMode:(NSLineBreakByWordWrapping)];
        [label1 setNumberOfLines:0];
        [label1 setText:NSLocalizedString(@"Input Mobile Number here.",@"请填写手机号。")];
        [self.contentView addSubview:label1];
        
        y+=40;
        
        _textField_area = [[UITextField alloc]initWithFrame:CGRectMake(10, y, 100, 30)];
        [_textField_area setBorderStyle:(UITextBorderStyleRoundedRect)];
        [_textField_area setPlaceholder:NSLocalizedString(@"Area Code", @"地区号")];
        [_textField_area setReturnKeyType:(UIReturnKeyDone)];
        [_textField_area setDelegate:self];
        [self.contentView addSubview:_textField_area];
        
        _textField_phone = [[UITextField alloc]initWithFrame:CGRectMake(120, y, self.contentView.frame.size.width-120-10, 30)];
        [_textField_phone setBorderStyle:(UITextBorderStyleRoundedRect)];
        [_textField_phone setPlaceholder:NSLocalizedString(@"Phone", @"电话号码")];
        [_textField_phone setReturnKeyType:(UIReturnKeyDone)];
        [_textField_phone setDelegate:self];
        [self.contentView addSubview:_textField_phone];
        
        y+=40;
        
        UILabel * label2=[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.contentView.frame.size.width-20, 30)];
        [label2 setLineBreakMode:(NSLineBreakByWordWrapping)];
        [label2 setNumberOfLines:0];
        [label2 setText:NSLocalizedString(@"Input the Area Code and Phone Number here. It is optional.",@"请填写地区代号和电话号码。这是一个可选项。")];
        [self.contentView addSubview:label2];
        
        y+=40;
        
        _textField_email = [[UITextField alloc]initWithFrame:CGRectMake(10, y, self.contentView.frame.size.width-20, 30)];
        [_textField_email setBorderStyle:(UITextBorderStyleRoundedRect)];
        [_textField_email setPlaceholder:NSLocalizedString(@"Email(Optional)", @"电子邮件(可选)")];
        [_textField_email setReturnKeyType:(UIReturnKeyDone)];
        [_textField_email setDelegate:self];
        [self.contentView addSubview:_textField_email];
        
        y+=40;
        
        UILabel * label3=[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.contentView.frame.size.width-20, 30)];
        [label3 setLineBreakMode:(NSLineBreakByWordWrapping)];
        [label3 setNumberOfLines:0];
        [label3 setText:NSLocalizedString(@"Input your email here. It is optional.",@"请填写电子邮箱。这是一个可选项。")];
        [self.contentView addSubview:label3];
        
        
        [_textField_mobile setKeyboardType:(UIKeyboardTypePhonePad)];
        [_textField_area setKeyboardType:(UIKeyboardTypePhonePad)];
        [_textField_phone setKeyboardType:(UIKeyboardTypePhonePad)];
        [_textField_email setKeyboardType:(UIKeyboardTypeEmailAddress)];
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
    self.value_phone=_textField_phone.text;
    [self.delegate confirmCustomerProperty:(NCSubViewPropertyTypeCustomerAreaCode) withValue:self.value_area];
    [self.delegate confirmCustomerProperty:(NCSubViewPropertyTypeCustomerMobile) withValue:self.value_mobile];
    [self.delegate confirmCustomerProperty:(NCSubViewPropertyTypeCustomerEmail) withValue:self.value_email];
    [self.delegate confirmCustomerProperty:(NCSubViewPropertyTypeCustomerPhone) withValue:self.value_phone];
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //_Log(@"NCCustomerNameSubView textFieldShouldReturn");
    [textField resignFirstResponder];
    return NO;
}

@end
