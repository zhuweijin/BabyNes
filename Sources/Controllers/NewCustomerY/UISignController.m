//
//  UISignController.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-8-12.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "UISignController.h"

@interface UISignController ()

@end

@implementation UISignController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _weber = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    [_weber loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sign" ofType:@"htm"] encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
    [self.view addSubview:_weber];
    
    [_weber setDelegate:self];
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
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //NSLog(@"webview shouldStartLoadWithRequest request:%@[URL=%@] navigationType=%d",request,request.URL.absoluteString,navigationType);
    if([request.URL.absoluteString hasPrefix:@"data:image/png;base64"]){
        NSLog(@"GET BASE64 IMAGE DATA:\n%@",request.URL.absoluteString);
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }else{
        return YES;
    }
}
@end
