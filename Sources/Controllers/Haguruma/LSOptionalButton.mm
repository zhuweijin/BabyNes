//
//  LSOptionalButton.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-24.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSOptionalButton.h"

@implementation LSOptionalButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withNames:(NSArray*)names{
    self = [super initWithFrame:frame];
    if (self && names && [names isKindOfClass:[NSArray class]] && [names count]>0) {
        // Initialization code
        NSMutableArray * btnArray=[[NSMutableArray alloc]init];
        CGRect btnFrame=CGRectMake(0, 0, frame.size.width/[names count], frame.size.height);
        for (int i=0; i<[names count]; i++) {
            UIButton * btn=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
            [btn setFrame:btnFrame];
            //[[btn titleLabel]setText:[names objectAtIndex:i]];
            //[[btn titleLabel] setTextColor:[UIColor blackColor]];
            [btn setTitle:[names objectAtIndex:i] forState:(UIControlStateDisabled)];
            [btn setTitle:[names objectAtIndex:i] forState:(UIControlStateNormal)];
            [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateDisabled)];
            [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [btn setBackgroundImage:UIUtil::ImageWithColor([UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1]) forState:(UIControlStateDisabled)];
            [btn setBackgroundImage:UIUtil::ImageWithColor(UIUtil::Color(235, 238, 250)) forState:(UIControlStateNormal)];
            [btn setTag:i];
            [btn addTarget:self action:@selector(onButtonSelected:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:btn];
            /*
            if(i==0){
                [btn setEnabled:NO];
            }else{
                [btn setEnabled:YES];
            }
            */
            [btnArray addObject:btn];
            btnFrame.origin.x+=frame.size.width/[names count];
        }
        buttonSelected=0;
        buttonArray=[[NSArray alloc]initWithArray: btnArray];
        [self onButtonSelected:[buttonArray objectAtIndex:0]];
    }
    return self;
}
-(int)getSelectedButton{
    return buttonSelected;
}
-(int)getButtonNumber{
    if(buttonArray && [buttonArray isKindOfClass:[NSArray class]]){
        return [buttonArray count];
    }else{
        return -1;
    }
}

-(void)onButtonSelected:(id)sender{
    if([sender isKindOfClass:[UIButton class]]){
        _Log(@"LSOptionalButton onButtonSelected:%d",[sender tag]);
        buttonSelected=[sender tag];
        for (UIButton * btn in buttonArray) {
            if(btn.tag==buttonSelected){
                [[btn titleLabel] setFont:[UIFont systemFontOfSize:18]];
                [btn setEnabled:NO];
            }else{
                [[btn titleLabel] setFont:[UIFont systemFontOfSize:15]];
                [btn setEnabled:YES];
            }
        }
        [self sendActionsForControlEvents:(UIControlEventTouchUpInside)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
