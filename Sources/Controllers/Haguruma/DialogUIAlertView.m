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
    
    isWaiting4Tap = YES;
    return self;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    alertViewRetValue = buttonIndex;
    isWaiting4Tap = NO;
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
