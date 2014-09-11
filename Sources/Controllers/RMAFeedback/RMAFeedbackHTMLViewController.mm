//
//  RMAFeedbackHTMLViewController.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-9-3.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "RMAFeedbackHTMLViewController.h"
#import "LSCustomer.h"

static NSString * baseURL=@"http://www.everstray.com/";
//static NSString * feedbackURL=@"https://172.16.0.186:233/babynes/admin/api/after_sale_feedback.php?token=";

@interface RMAFeedbackHTMLViewController ()

@end

@implementation RMAFeedbackHTMLViewController

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
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2]];
    
    self.navigationItem.title=NSLocalizedString(@"RMA Feedback", @"问题反馈");
    
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
    NSString * c_id=[[LSCustomer getCurrentCustomer] theID];
    NSString * c_mobile=[[LSCustomer getCurrentCustomer] theMobile];
    
    if(c_id==nil){
        c_id=@"";
    }
    if(c_mobile==nil){
        c_mobile=@"";
    }
    
    NSString * ori=[NSString stringWithContentsOfFile:
     [[NSBundle mainBundle]
      pathForResource:@"feedback_cn"//NSLocalizedString(@"feedback_en", @"feedback_cn")
      ofType:@"htm"
      ] encoding:NSUTF8StringEncoding error:nil
     ];
    
    finalURL=[[[ServerConfig getServerConfig] getURL_rma_feedback] stringByAppendingString:[NSString stringWithFormat:@"?token=%@",[DataLoader accessToken]]];
    
    ori=[ori stringByReplacingOccurrencesOfString:@"{$ACTION_URL}" withString:finalURL];
    ori=[ori stringByReplacingOccurrencesOfString:@"{$CUSTOMER_ID}" withString:c_id];
    ori=[ori stringByReplacingOccurrencesOfString:@"{$CUSTOMER_MOBILE}" withString:c_mobile];
    
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
    UIUtil::ShowAlert(NSLocalizedString(@"Failed to post feedback.", @"反馈发送失败。"));
}

@end
