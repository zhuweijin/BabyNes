//
//  LSOptionalButton.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-24.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSOptionalButton : UIControl
{
    int buttonNumber;
    int buttonSelected;
    NSArray * buttonArray;
}

-(id)initWithFrame:(CGRect)frame withNames:(NSArray*)names;
-(int)getSelectedButton;
-(int)getButtonNumber;

-(void)setButtonSelected:(int)button_tag;

@end
