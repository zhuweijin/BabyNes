//
//  DialogUIAlertView.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-4.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "DialogUIAlertView.h"

@implementation DialogUIAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    alv = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
    _alert_view_type=NCDialogAlertViewTypeDefault;
    [alv setDelegate:self];
    isWaiting4Tap = YES;
    return self;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    alertViewRetValue = buttonIndex;
    isWaiting4Tap = NO;
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
    _Log(@"DialogAlertView willPresentAlertView !");
    if(_alert_view_type!=NCDialogAlertViewTypeDefault){
        // 遍历 UIAlertView 所包含的所有控件
        for (UIView *tempView in alertView.subviews) {
            
            if ([tempView isKindOfClass:[UILabel class]]) {
                // 当该控件为一个 UILabel 时
                UILabel *tempLabel = (UILabel *) tempView;
                
                if ([tempLabel.text isEqualToString:alertView.message]) {
                    if(_alert_view_type==NCDialogAlertViewTypeBigger){
                        // 调整对齐方式
                        //tempLabel.textAlignment = UITextAlignmentLeft;
                        // 调整字体大小
                        _Log(@"DialogAlertView willPresentAlertView ori:%@",tempLabel.font);
                        [tempLabel setFont:[UIFont systemFontOfSize:30.0]];
                        _Log(@"DialogAlertView willPresentAlertView ato:%@",tempLabel.font);
                    }
                }
            }
        }
    }
}

- (int)showDialog
{
    isWaiting4Tap = YES;
    [alv show];
    while (isWaiting4Tap) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return alertViewRetValue;
}
/*
 - (void)dealloc {
 [super dealloc];
 [alv release];
 }
 */
@end
