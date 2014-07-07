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
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if([ProductEntity getProductArray]){
        id mono_info=[[ProductEntity getProductArray] objectAtIndex:indexPath.row];
        [cell loadProduct:mono_info];
    }
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _Log(@"MonoTable 第%d个section中第%d行的被点击",indexPath.section, indexPath.row);
    ProductEntity*pe=[[ProductEntity getProductArray]objectAtIndex:indexPath.row];
    
    //[[CartEntity getDefaultCartEntity]addToCart:[pe product_id] withQuantity:1];
    
    //Only Icon of product do animation
    int no=[tableView.visibleCells indexOfObject:[tableView cellForRowAtIndexPath:indexPath]];
    CGRect civFrame;//=[[tableView cellForRowAtIndexPath:indexPath] frame];
    civFrame.origin.x=[self frame].origin.x+40;
    civFrame.origin.y+=70*no+5;//+[self frame].origin.y;
    civFrame.size.width=80;
    civFrame.size.height=60;
    _Log(@"civFrame %f,%f,%f,%f",civFrame.origin.x,civFrame.origin.y,civFrame.size.width,civFrame.size.height);
    CacheImageView * civ=[[CacheImageView alloc]initWithFrame:civFrame];//CGRectMake(40,5,80,60)
    [civ setCacheImageUrl:[pe product_image]];
    
    NSDictionary * anime_dict=@{@"civ":civ,
                                @"pe":pe,
                                @"inCart":[NSNumber numberWithInt: [[CartEntity getDefaultCartEntity]currentArrayIndexOfProductID:[pe product_id]]],
                                @"monoIPInTable":indexPath
                                };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MonoCellSelected" object:anime_dict];
    /*
    [UIView animateWithDuration:0.4 animations:^{
        LSShopMonoTableViewCell * cell=(LSShopMonoTableViewCell*)[self cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO animated:YES];
        _Log(@"MonoTable 0.4s Over cancel selection");
    }];
     */
    [self deselectRowAtIndexPath:indexPath animated:YES];
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
