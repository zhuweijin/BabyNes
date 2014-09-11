//
//  SRFeedbackHTMLViewController.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-9-4.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRFeedbackHTMLViewController : UIViewController
<UIWebViewDelegate>
{
    NSString * finalURL;
}

@property NSString * sr_id;
@property UIWebView * weber;
@property (readonly) UIView * honbuView;

- (id)initWithSRID:(NSInteger)srid;
@end
