//
//  CartTable.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-26.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "CartTable.h"

@implementation CartTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(int)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    //NSString *key=[NSString stringWithFormat:@"section %d row %d",section,row]; //[_arrayType objectAtIndex:section];
    
    static NSString *CellIdentifier = @"CartTypeCell";
    LSShopCartTableViewCell *cell = (LSShopCartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[LSShopCartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //[cell loadMono:[[LSMonoInfo getMonoArray] objectAtIndex:row]];
    [cell loadCartMonoWithName:[NSString stringWithFormat:@"Product %d",indexPath.row] andPrice:indexPath.row andQuantity:1 andID:indexPath.row];
    //[cell.button_minus addTarget:self action:@selector(cart_mono_minus:) forControlEvents:UIControlEventTouchUpInside];
    //[cell.button_plus addTarget:self action:@selector(cart_mono_plus:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"第%d个section中第%d行的被点击",indexPath.section, indexPath.row);
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
