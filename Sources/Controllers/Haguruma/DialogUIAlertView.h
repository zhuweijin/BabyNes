//
//  DialogUIAlertView.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-4.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
	NCDialogAlertViewTypeDefault=0,
    NCDialogAlertViewTypeBigger=1
} NCDialogAlertViewType;

@interface DialogUIAlertView : NSObject<UIAlertViewDelegate>{
    BOOL isWaiting4Tap;
    UIAlertView * alv;
    int alertViewRetValue;
    
}

@property NSInteger alert_view_type;

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
- (int)showDialog;


@end
