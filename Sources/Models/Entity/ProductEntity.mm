//
//  ProductEntity.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-30.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "ProductEntity.h"

static NSDictionary * products;
static NSArray * product_array;

@implementation ProductEntity

+(BOOL)updateProductDictionaryWithJSON:(NSDictionary*)json{
    
    NSMutableDictionary* mdict=[[NSMutableDictionary alloc]init];
    NSMutableArray *marray=[[NSMutableArray alloc]init];
    @try {
        id dic_category = [json objectForKey:@"category"];
        _Log(@"setPdtArrayWithNSDic dic_category=[%@] class=[%@]",dic_category,[dic_category class]);
        for(id category_item in dic_category){
            NSString* category_key=[category_item objectForKey:@"value"];
            id category_group=[json objectForKey:category_key];
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
                    
                    [mdict setObject:pe forKey: pid];
                    [marray addObject:pe];
                }
            }
        }
        products=[[NSDictionary alloc]initWithDictionary:mdict];
        product_array=[[NSArray alloc]initWithArray:marray];
        return YES;
    }
    @catch (NSException *exception) {
        _Log(@"Update Product Dictionary Exception : %@",exception);
        return NO;
    }
    @finally {
        //Nothing
    }
}

+(NSDictionary*)getProductDictionary{
    return products;
}

+(NSArray*)getProductArray{
    return product_array;
}

-(id) initProductWithId:(int)pid withTitle:(NSString*)title withCents:(int)cents withMagentoID:(NSString*)mid withImageName:(NSString*)image{
    self=[self init];
    self.product_id=pid;
    self.product_title=title;
    self.product_price_cents=cents;
    self.product_magento_id=mid;
    self.product_image=image;
    return self;
}

@end
