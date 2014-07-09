//
//  CartTable.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-26.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "CartTable.h"

@implementation CartTable

-(void)addCartChangedObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealCartChanged:) name:@"CartChanged" object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addCartChangedObserver];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self=[super initWithFrame:frame style:style];
    [self addCartChangedObserver];
    return self;
}



-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[CartEntity getDefaultCartEntity]cart_array]count];
}
-(int)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSUInteger section = [indexPath section];
    //NSUInteger row = [indexPath row];
    
    //NSString *key=[NSString stringWithFormat:@"section %d row %d",section,row]; //[_arrayType objectAtIndex:section];
    
    static NSString *CellIdentifier = @"CartCell";
    LSShopCartTableViewCell *cell = (LSShopCartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[LSShopCartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //[cell loadMono:[[LSMonoInfo getMonoArray] objectAtIndex:row]];
    //[cell loadCartMonoWithName:[NSString stringWithFormat:@"Product %d",indexPath.row] andPrice:indexPath.row andQuantity:1 andID:indexPath.row];
    
    ProductEntity* pe= [[[CartEntity getDefaultCartEntity]cart_array] objectAtIndex:indexPath.row];
    [cell loadCartMonoWithName:[pe product_title] andPrice:[pe product_price_cents] andQuantity:[pe quantity] andID:[pe product_id]];
    
    [cell.button_minus addTarget:self action:@selector(cart_mono_minus:) forControlEvents:UIControlEventTouchUpInside];
    [cell.button_plus addTarget:self action:@selector(cart_mono_plus:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _Log(@"第%d个section中第%d行的被点击",indexPath.section, indexPath.row);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)cart_mono_minus:(id)sender{
    _Log(@"IN TABLE cart_mono_minus[%d] called",[sender tag]);
    ProductEntity* pe = [[ProductEntity getProductDictionary] objectForKey:[NSString stringWithFormat:@"%d",[sender tag]]];
    [[CartEntity getDefaultCartEntity]addToCart:[pe product_id] withQuantity:-1];
    /*
    if([self.quantity.text intValue]>1){
        self.quantity.text=[NSString stringWithFormat:@"%d",[self.quantity.text intValue]-1];
    }else{
        //[self removeFromSuperview];
    }
     */
}
-(void)cart_mono_plus:(id)sender{
    _Log(@"IN TABLE cart_mono_plus[%d] called",[sender tag]);
    ProductEntity* pe = [[ProductEntity getProductDictionary] objectForKey:[NSString stringWithFormat:@"%d",[sender tag]]];
    if(pe){
        [[CartEntity getDefaultCartEntity]addToCart:[pe product_id] withQuantity:1];
    }else{
        UIUtil::ShowAlert(@"No such tag...");
    }
    //self.quantity.text=[NSString stringWithFormat:@"%d",[self.quantity.text intValue]+1];
    
}

-(void)dealCartChanged:(NSNotification*) notification{
    _Log(@"dealCartChanged !");
    
    [self reloadData];
}

@end
