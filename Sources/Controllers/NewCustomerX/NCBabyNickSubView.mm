//
//  NCBabyNickSubView.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-21.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCBabyNickSubView.h"

@implementation NCBabyNickSubView

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
        [self setBarTitle:NSLocalizedString(@"Baby's Nickname", @"宝宝的昵称")];
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, self.contentView.frame.size.width-20, 30)];
        [_textField setBorderStyle:(UITextBorderStyleRoundedRect)];
        [_textField setPlaceholder:NSLocalizedString(@"Nickname", @"昵称")];
        [_textField setReturnKeyType:(UIReturnKeyDone)];
        [_textField setDelegate:self];
        [self.contentView addSubview:_textField];
    }
    return self;
}

-(void)setWithBaby:(LSBaby *)baby{
    [_textField setText:[baby the_nick]];
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
    self.value=textField.text;
    //[self.delegate confirmCustomerProperty:(NCSubViewPropertyTypeCustomerName) withValue:self.value];
    [self.delegate confirmBabyProperty:(NCSubViewPropertyTypeBabyNick) forNo:_BabyNo withValue:self.value];
    [_textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_textField resignFirstResponder];
    return NO;
}

@end
