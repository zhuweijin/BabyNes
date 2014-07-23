//
//  ProductEntity.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-30.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductEntity : NSObject

+(void)resetProductsAsEmpty;

+(BOOL)updateProductDictionaryWithJSON:(NSDictionary*)json;
+(NSDictionary*)getProductDictionary;
+(NSArray*)getProductArray;


/*
 @{
 @"product_id": pid,
 @"product_title":product_name,
 @"product_price":price,
 @"product_magento_id":sku_no,
 @"product_image":good_image_url
 };
 */
@property int product_id;
@property NSString * product_title;
@property int product_price_cents;
@property NSString * product_magento_id;
@property NSString * product_image;

@property int quantity;

-(id) initProductWithId:(int)pid withTitle:(NSString*)title withCents:(int)cents withMagentoID:(NSString*)mid withImageName:(NSString*)image;
@end
