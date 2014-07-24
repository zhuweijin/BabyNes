//
//  LSDialoger.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-23.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSDialogerDelegate <NSObject>

-(int)eranda:(int)sentaku;

@end

@interface LSDialoger : UIViewController

@property BOOL isWaiting4Tap;
@property int alertViewRetValue;

@property UILabel * titleLabel;
@property UILabel * msgLabel;
@property UIButton * susumuButton;
@property UIButton * tomaruButton;
@property id<LSDialogerDelegate> LSDDelegate;

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitles:(NSString *)okButtonTitle withDelegate:(id<LSDialogerDelegate>)delegate;

@end


