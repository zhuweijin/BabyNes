//
//  DialogUIAlertView.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-4.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DialogUIAlertView : NSObject{
    BOOL isWaiting4Tap;
    UIAlertView * alv;
    int alertViewRetValue;
    
}
- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
- (int)showDialog;


@end
