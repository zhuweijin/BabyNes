//
//  LSShopCartTableViewCell.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-26.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSShopCartTableViewCell.h"

@implementation LSShopCartTableViewCell

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
    // Configure the view for the selected state
}


-(void) cleanOldView{
    if([self name]!=nil){
        [self.name removeFromSuperview];
        self.name=nil;
    }
    if([self price]!=nil){
        [self.price removeFromSuperview];
        self.price=nil;
    }
    if([self quantity]!=nil){
        [self.quantity removeFromSuperview];
        self.quantity=nil;
    }
    if([self button_plus]!=nil){
        [self.button_plus removeFromSuperview];
        self.button_plus=nil;
    }
    if([self button_minus]!=nil){
        [self.button_minus removeFromSuperview];
        self.button_minus=nil;
    }
}

-(void)loadCartMonoWithName:(NSString*)name andPrice:(int)cents andQuantity:(int)quantity andID:(int)mono_id{
    [self cleanOldView];
    _Log(@"loadCartMonoWithName %@ ... with ID %d",name,mono_id);
    //_Log(@"loadCartMonoWithNameAnd... cleaned");
    if(self.name==nil){
        self.name= [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 210,40)];
        [self addSubview:self.name];
    }
    self.name.text=name;
    
    
    if(self.price==nil){
        self.price= [[UILabel alloc]initWithFrame:CGRectMake(220, 5, 90,40)];
        [self addSubview:self.price];
    }
    [self.price setTextAlignment:(NSTextAlignmentRight)];
    NSString * hk=[NSString stringWithFormat:@"$%.2f",cents/100.0];
    NSString * cn=[NSString stringWithFormat:@"￥%.2f",cents/100.0];
    self.price.text=NSLocalizedString(hk,cn);
    
    
    if(self.button_minus==nil){
        self.button_minus=[[UIButton alloc]initWithFrame:CGRectMake(325, 5, 40, 40)];
        [self addSubview:self.button_minus];
        
        self.button_minus.titleLabel.font = [UIFont systemFontOfSize: 30.0];
        self.button_minus.titleLabel.textColor=[UIColor whiteColor];
        self.button_minus.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
        [self.button_minus setBackgroundImage:UIUtil::ImageWithColor(117, 114, 184) forState:UIControlStateHighlighted];
        [self.button_minus setTitle:@"-" forState:(UIControlStateNormal)];
        [self.button_minus setTag: mono_id];
        [self.button_minus addTarget:self action:@selector(cart_mono_minus:) forControlEvents:UIControlEventTouchUpInside];
        self.button_minus.titleEdgeInsets=UIEdgeInsetsMake(-5, 0, 0, 0);
    }
    
    
    
    if(self.quantity==nil){
        self.quantity =[[UITextField alloc]initWithFrame:CGRectMake(365, 5, 40,40)];
        [self addSubview:self.quantity];
    }
    [self.quantity setBorderStyle:(UITextBorderStyleNone)];
    self.quantity.text=[NSString stringWithFormat:@"%d",quantity];
    [self.quantity setTextAlignment:(NSTextAlignmentCenter)];
    [self.quantity setEnabled:NO];
    
    
    if (self.button_plus==nil){
        self.button_plus=[[UIButton alloc]initWithFrame:CGRectMake(405, 5, 40, 40)];
        [self addSubview:self.button_plus];
        
        self.button_plus.titleLabel.font = [UIFont systemFontOfSize: 30.0];
        self.button_plus.titleLabel.textColor=[UIColor whiteColor];
        self.button_plus.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
        [self.button_plus setBackgroundImage:UIUtil::ImageWithColor(117, 114, 184) forState:UIControlStateHighlighted];
        [self.button_plus setTitle:@"+" forState:(UIControlStateNormal)];
        [self.button_plus setTag:mono_id];
        [self.button_plus addTarget:self action:@selector(cart_mono_plus:) forControlEvents:UIControlEventTouchUpInside];
        self.button_plus.titleEdgeInsets=UIEdgeInsetsMake(-5, 0, 0, 0);
        
        
    }
    
    
    
    //_Log(@"cart cell super is [%@]",self.superview);
}

-(void)cart_mono_minus:(id)sender{
    _Log(@"IN CELL cart_mono_minus[%d] called",[sender tag]);
}
-(void)cart_mono_plus:(id)sender{
    _Log(@"IN CELL cart_mono_plus[%d] called",[sender tag]);
}


@end
