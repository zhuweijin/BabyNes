//
//  RMAFeedbackHTMLViewController.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-9-3.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMAFeedbackHTMLViewController : UIViewController
<UIWebViewDelegate>
{
    NSString * finalURL;
}
@property UIWebView * weber;
@property (readonly) UIView * honbuView;
@end
