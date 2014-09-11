//
//  SRFeedbackHTMLViewController.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-9-4.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "SRFeedbackHTMLViewController.h"
#import "DataLoader.h"

static NSString * baseURL=@"http://www.everstray.com/";
//static NSString * feedbackURL=@"https://172.16.0.186:233/babynes/admin/api/SRFeedback.php?token=";


@interface SRFeedbackHTMLViewController ()

@end

@implementation SRFeedbackHTMLViewController

- (id)initWithSRID:(NSInteger)srid
{
    self = [super init];
    if (self) {
        // Custom initialization
        _sr_id=[NSString stringWithFormat:@"%d",srid];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2]];
    
    self.navigationItem.title=NSLocalizedString(@"SR Feedback", @"业务消息阅读报告");
    
    UIBarButtonItem * submitBtn=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Send", @"发送") style:(UIBarButtonItemStylePlain) target:self action:@selector(onSend:)];
    self.navigationItem.rightBarButtonItem=submitBtn;
    
    //_honbuView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 540, 620)];
    _honbuView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view addSubview:_honbuView];
    
    self.honbuView.backgroundColor=UIUtil::Color(240, 240, 240);
    
    _weber = [[UIWebView alloc]initWithFrame:CGRectMake(10, 0, self.honbuView.frame.size.width-20,768)];
    [_weber loadHTMLString:[self getHTMLforCustomer] baseURL:[NSURL URLWithString:baseURL]];
    [_weber setDelegate:self];
    [self.honbuView addSubview:_weber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString*)getHTMLforCustomer{
    NSString * ori=[NSString stringWithContentsOfFile:
                    [[NSBundle mainBundle]
                     pathForResource:@"feedback_cn"//NSLocalizedString(@"feedback_en", @"feedback_cn")
                     ofType:@"htm"
                     ] encoding:NSUTF8StringEncoding error:nil
                    ];
    
    finalURL=[[[ServerConfig getServerConfig] getURL_sr_feedback] stringByAppendingString:[NSString stringWithFormat:@"?token=%@",[DataLoader accessToken]]];
    
    ori=[ori stringByReplacingOccurrencesOfString:@"{$ACTION_URL}" withString:finalURL];
    ori=[ori stringByReplacingOccurrencesOfString:@"{$SR_ID}" withString:_sr_id];

    return ori;
}

#pragma mark on button click
-(void)closeView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

-(void)onSend:(id)sender{
    //NSString *text = [_weber stringByEvaluatingJavaScriptFromString:@"document.getElementById('text').value;" ];
    NSString *text = [_weber stringByEvaluatingJavaScriptFromString:@"document.feedbackForm.text.value" ];
    _Log(@"_weber form text=%@",text);
    /*
     NSString * image_count_str = [_weber stringByEvaluatingJavaScriptFromString:@"image_count" ];
     _Log(@"_weber form count=%@",image_count_str);
     for (int i=0; i<[image_count_str intValue]; i++) {
     NSString *img = [_weber stringByEvaluatingJavaScriptFromString:@"document.getElementById('image_'+i).value" ];
     _Log(@"_weber form image[%d]=%@",i,img);
     }
     */
    [_weber stringByEvaluatingJavaScriptFromString:@"submitFeedback();"];
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

#pragma mark web delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    _Log(@"webView shouldStartLoadWithRequest:%@ navigationType:%d",request,navigationType);
    if(![request.URL.absoluteString hasPrefix:baseURL]){
        NSData*data=[request HTTPBody];
        NSLog(@"body[%@]（%@）",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding],data);
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    UIUtil::ShowAlert(NSLocalizedString(@"Failed to post sr feedback.", @"反馈发送失败。"));
}


@end
