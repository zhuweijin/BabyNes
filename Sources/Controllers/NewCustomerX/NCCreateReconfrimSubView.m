//
//  NCCreateReconfrimSubView.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-23.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCCreateReconfrimSubView.h"

@implementation NCCreateReconfrimSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitles:(NSString *)okButtonTitle withDelegate:(id<NCCreateReconfrimSubViewDelegate,NCSubViewDelegate>)delegate{
    self=[super initWithFrame:frame withDelegate:delegate];
    if(self){
        [self setBarTitle:title];
        
        _msgLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.contentView.frame.size.width-20, 200)];
        [_msgLabel setText:message];
        [_msgLabel setTextAlignment:(NSTextAlignmentCenter)];
        [_msgLabel setLineBreakMode:(NSLineBreakByWordWrapping)];
        [_msgLabel setFont:[UIFont systemFontOfSize:30]];
        [_msgLabel setNumberOfLines:0];
        [self.contentView addSubview:_msgLabel];
        
        [self.backButton setTitle:cancelButtonTitle forState:(UIControlStateNormal)];
        
        _tomaruButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [_tomaruButton setFrame:CGRectMake(0, 300, self.contentView.frame.size.width/2, 30)];
        [_tomaruButton addTarget:self action:@selector(tomare:) forControlEvents:(UIControlEventTouchUpInside)];
        [[_tomaruButton titleLabel]setFont:[UIFont systemFontOfSize:20]];
        [_tomaruButton setTitle:cancelButtonTitle forState:(UIControlStateNormal)];
        [self addSubview:_tomaruButton];
        
        _susumuButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [_susumuButton setFrame:CGRectMake(self.contentView.frame.size.width/2, 300, self.contentView.frame.size.width/2, 30)];
        [_susumuButton addTarget:self action:@selector(susume:) forControlEvents:(UIControlEventTouchUpInside)];
        [[_susumuButton titleLabel]setFont:[UIFont systemFontOfSize:20]];
        [_susumuButton setTitle:okButtonTitle forState:(UIControlStateNormal)];
        [self addSubview:_susumuButton];
        
        [self.backButton setHidden:YES];
        
        [self setLSDDelegate:delegate];
        
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
-(void)onBackButton:(id)sender{
    [self tomare:sender];
}
-(void)tomare:(id)sender{
    if(_LSDDelegate){
        [_LSDDelegate eranda:0];
    }
    [super onBackButton:sender];
}
-(void)susume:(id)sender{
    if(_LSDDelegate){
        [_LSDDelegate eranda:1];
    }
    [super onBackButton:sender];
}
@end
