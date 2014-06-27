//
//  LSTabButton.m
//  BabyNesPOS_Akatsuki
//
//  Created by 倪 李俊 on 14-6-25.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import "LSTabButton.h"

@implementation LSTabButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)asActive{
    [self setTitleColor:[UIColor colorWithRed:118/255.0 green:115/255.0 blue:184/255.0 alpha:1] forState:(UIControlStateNormal)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[self.titleLabel text]];
    NSRange rangeAll = NSMakeRange(0, attributedString.string.length);
    NSMutableAttributedString *as = [attributedString mutableCopy];
    [as beginEditing];
    [as addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:rangeAll];
    [as addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:118/255.0 green:115/255.0 blue:184/255.0 alpha:1] range:rangeAll];
    [as addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:rangeAll];
    [as endEditing];
    [self setAttributedTitle:as forState:UIControlStateNormal];
}
-(void)asInactive{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[self.titleLabel text]];
    NSRange rangeAll = NSMakeRange(0, attributedString.string.length);
    NSMutableAttributedString *as = [attributedString mutableCopy];
    [as beginEditing];
    [as addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleNone] range:rangeAll];
    [as addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangeAll];
    [as addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:rangeAll];
    [as endEditing];
    [self setAttributedTitle:as forState:UIControlStateNormal];
}

@end
