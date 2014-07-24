//
//  LSDialoger.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-23.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSDialoger.h"

@interface LSDialoger ()

@end

@implementation LSDialoger

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitles:(NSString *)okButtonTitle withDelegate:(id<LSDialogerDelegate>)delegate{
    self=[super init];
    if(self){
        self.view.frame=CGRectMake(0, 0, 300,180);
        
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300,30)];
        [_titleLabel setText:title];
        [_titleLabel setTextAlignment:(NSTextAlignmentCenter)];
        [self.view addSubview:_titleLabel];
        
        _msgLabel=[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 300,100)];
        [_msgLabel setText:message];
        [_msgLabel setTextAlignment:(NSTextAlignmentCenter)];
        [_msgLabel setLineBreakMode:(NSLineBreakByWordWrapping)];
        [_msgLabel setNumberOfLines:0];
        [self.view addSubview:_msgLabel];
        
        _tomaruButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150,30)];
        [_tomaruButton addTarget:self action:@selector(tomare:) forControlEvents:(UIControlEventTouchUpInside)];
        [_tomaruButton setTitle:cancelButtonTitle forState:(UIControlStateNormal)];
        [self.view addSubview:_tomaruButton];
        
        _susumuButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150,30)];
        [_susumuButton addTarget:self action:@selector(susume:) forControlEvents:(UIControlEventTouchUpInside)];
        [_susumuButton setTitle:okButtonTitle forState:(UIControlStateNormal)];
        [self.view addSubview:_susumuButton];
        
        self.view.center=[[UIApplication sharedApplication]keyWindow].center;
        
        _LSDDelegate=delegate;
        
        _isWaiting4Tap = YES;
        _alertViewRetValue=-1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)tomare:(id)sender{
    _isWaiting4Tap = NO;
    _alertViewRetValue = 0;
    [_LSDDelegate eranda:_alertViewRetValue];
    [self dismissViewControllerAnimated:YES completion:^{
        _Log(@"TOMARETA");
    }];
}
-(void)susume:(id)sender{
    _isWaiting4Tap = NO;
    _alertViewRetValue = 1;
    [_LSDDelegate eranda:_alertViewRetValue];
    [self dismissViewControllerAnimated:YES completion:^{
        _Log(@"SUSUNDA");
    }];
}
@end
