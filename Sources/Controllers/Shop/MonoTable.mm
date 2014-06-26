//
//  MonoTable.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-26.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "MonoTable.h"

@implementation MonoTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
-(int)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    //NSString *key=[NSString stringWithFormat:@"section %d row %d",section,row]; //[_arrayType objectAtIndex:section];
    
    static NSString *CellIdentifier = @"MonoTypeCell";
    LSShopMonoTableViewCell *cell = (LSShopMonoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[LSShopMonoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell loadMonoWithName:[NSString stringWithFormat:@"Product %d",indexPath.row] andImageName:[NSString stringWithFormat:@"ShopImage/Capsules/capsule-%d@2x.png",indexPath.row+1]];
    //[cell loadMono:[[LSMonoInfo getMonoArray] objectAtIndex:row]];
    
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
