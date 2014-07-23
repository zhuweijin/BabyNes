//
//  NCCreateReconfrimSubView.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-23.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCRootSubView.h"
@protocol NCCreateReconfrimSubViewDelegate <NSObject>

-(int)eranda:(int)sentaku;

@end
@interface NCCreateReconfrimSubView : NCRootSubView
//@property UILabel * titleLabel;
@property UILabel * msgLabel;
@property UIButton * susumuButton;
@property UIButton * tomaruButton;
@property id<NCCreateReconfrimSubViewDelegate,NCSubViewDelegate> LSDDelegate;

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitles:(NSString *)okButtonTitle withDelegate:(id<NCCreateReconfrimSubViewDelegate,NCSubViewDelegate>)delegate;

@end
