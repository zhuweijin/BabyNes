//
//  LSSigner.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-8-12.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSSigner.h"

@implementation LSSigner

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _weber = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        //[self setBackgroundColor:[UIColor redColor]];
        [_weber setBackgroundColor:[UIColor whiteColor]];
        [_weber setScalesPageToFit:YES];
        
        [_weber setDelegate:self];
        
        [_weber loadHTMLString:
         [NSString stringWithContentsOfFile:
          [[NSBundle mainBundle]
           pathForResource:@"sign_en"//NSLocalizedString(@"sign_en", @"sign_cn")
           ofType:@"htm"
           ] encoding:NSUTF8StringEncoding error:nil
          ] baseURL:nil
         ];
        [self addSubview:_weber];
        
        /*
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
         
         - (void)statusBarOrientationChange:(NSNotification *)notification {
         UIInterfaceOrientation orient = [notification.userInfo[UIApplicationStatusBarOrientationUserInfoKey] integerValue];
         
         // handle the interface orientation as needed
         }
         */
        
        //UIDeviceOrientationDidChangeNotification
        
        
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"webview shouldStartLoadWithRequest request:%@[URL=%@] navigationType=%d",request,request.URL.absoluteString,navigationType);
    if([request.URL.absoluteString hasPrefix:@"data:image/png;base64"]){
        NSLog(@"GET BASE64 IMAGE DATA:\n%@",request.URL.absoluteString);
        //[self.navigationController popViewControllerAnimated:YES];
        _dataurl=request.URL.absoluteString;
        [self sendActionsForControlEvents:(UIControlEventEditingDidEnd)];
        _LogLine();
        return NO;
    }else if([request.URL.absoluteString hasPrefix:@"http://sinri.net.tf"]){
        NSLog(@"GET SIGN CANCELLED:\n%@",request.URL.absoluteString);
        [self sendActionsForControlEvents:(UIControlEventEditingDidEndOnExit)];
        _LogLine();
        return NO;
    }
    else{
        _LogLine();
        return YES;
    }
}


@end
