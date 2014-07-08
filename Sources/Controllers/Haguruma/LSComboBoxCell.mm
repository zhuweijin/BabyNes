//
//  LSComboBoxCell.m
//  BabyNesPOS_Akatsuki
//
//  Created by 倪 李俊 on 14-6-23.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import "LSComboBoxCell.h"

@implementation LSComboBoxCell

-(UIButton*)newCellButtonWithTitle:(NSString*)title withTag:(int)tag withFrame:(CGRect)frame{
    UIButton* btn=[UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTag:tag];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn setBackgroundImage:UIUtil::ImageWithColor([UIColor grayColor]) forState:(UIControlStateHighlighted)];
    [btn setBackgroundImage:UIUtil::ImageWithColor([UIColor whiteColor]) forState:(UIControlStateNormal)];
    [btn setBackgroundImage:UIUtil::ImageWithColor([UIColor redColor]) forState:(UIControlStateSelected)];
    [btn setFrame:frame];
    [btn setTitle:title forState:(UIControlStateNormal)];
    //[btn addTarget:comboBox action:@selector(select_item:) forControlEvents:(UIControlEventTouchUpInside)];
    [btn.titleLabel setTextAlignment:(NSTextAlignmentLeft)];
    return btn;
}

-(void)loadforComboBox:(UIView*)comboBox withTag:(int)tag withText:(NSString *)text asFrame:(CGRect) frame{
    if(self.btn){
        [self.btn removeFromSuperview];
        self.btn=nil;
    }
    _Log(@"LSComboBoxCell load With...%d/%@",tag,text);
    self.btn=[self newCellButtonWithTitle:text withTag:tag withFrame:frame];
    [self.btn addTarget:comboBox action:@selector(select_item:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btn];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier forComboBox:(UIView*)comboBox withTag:(int)tag withText:(NSString *)text asFrame:(CGRect) frame
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor grayColor]];
        [self setAlpha:0.8];
        
        self.btn=nil;
        _Log(@"LSComboBoxCell initWith...%d/%@",tag,text);
        self.btn=[self newCellButtonWithTitle:text withTag:tag withFrame:frame];
        [self.btn addTarget:comboBox action:@selector(select_item:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btn];
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    _Log(@"LSComboBoxCell selected");
    // Configure the view for the selected state
}

@end
