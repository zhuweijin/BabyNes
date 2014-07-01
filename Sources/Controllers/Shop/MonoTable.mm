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
    if([ProductEntity getProductArray]!=nil){
        _Log(@"MONO TABLE rows...self.pdtArray=[%@] count=%d",[ProductEntity getProductArray],[[ProductEntity getProductArray]count]);
        return [[ProductEntity getProductArray]count];
    }else{
        _Log(@"MONO TABLE rows...self.pdtArray=[%@] count=0",[ProductEntity getProductArray]);
        return 0;
    }
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
    if([ProductEntity getProductArray]){
        id mono_info=[[ProductEntity getProductArray] objectAtIndex:indexPath.row];
        [cell loadProduct:mono_info];
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"第%d个section中第%d行的被点击",indexPath.section, indexPath.row);
    ProductEntity*pe=[[ProductEntity getProductArray]objectAtIndex:indexPath.row];
    [[CartEntity getDefaultCartEntity]addToCart:[pe product_id] withQuantity:1];
    //UIUtil::ShowAlert([NSString stringWithFormat:@"Title=%@ PID=%d",pe.product_title, pe.product_id]);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
/*
-(void)setPdtArrayWithNSDic:(NSDictionary*)dict{
    self.pdtArray=[[NSMutableArray alloc]init];
    id dic_category = [dict objectForKey:@"category"];
    _Log(@"setPdtArrayWithNSDic dic_category=[%@] class=[%@]",dic_category,[dic_category class]);
    for(id category_item in dic_category){
        NSString* category_key=[category_item objectForKey:@"value"];
        id category_group=[dict objectForKey:category_key];
        for(id pdt_good in category_group){
            //_Log(@"setPdtArrayWithNSDic[%@][%@]=[%@]",category_key,[pdt_good objectForKey:@"name"],pdt_good);
            NSString * good_name=[pdt_good objectForKey:@"name"];
            NSString * good_image_url=[pdt_good objectForKey:@"image"];
            
            good_image_url= [@"ShopImage/" stringByAppendingString:[good_image_url lastPathComponent]];
            
            for (id pdt_item in [pdt_good objectForKey:@"products"] ) {
                NSString*pid=[pdt_item objectForKey:@"pid"];
                NSString*price=[pdt_item objectForKey:@"price"];
                NSString*sku_no=[pdt_item objectForKey:@"sku_no"];
                NSString*style=[pdt_item objectForKey:@"style"];
                
                NSString * product_name=[[good_name stringByAppendingString:@" "] stringByAppendingString:style];
                
                _Log(@"pdt: goods[%@] [%@-%@] pid=%@ price=%@ sku_no=%@ style=%@",product_name,good_name,good_image_url,pid,price,sku_no,style);
                
                ProductEntity * pe=[[ProductEntity alloc]initProductWithId:[pid intValue] withTitle:product_name withCents:(int)([price floatValue]*100) withMagentoID:sku_no withImageName:good_image_url];
                [self.pdtArray addObject:pe];
            }
        }
    }
    [self reloadData];
}
*/
@end
