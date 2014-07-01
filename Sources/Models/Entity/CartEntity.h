//
//  CartEntity.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-30.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductEntity.h"

@interface CartEntity : NSObject

@property NSMutableArray * cart_array;

+(CartEntity*)getDefaultCartEntity;
-(void)resetCart;

-(void)addToCart:(int)product_id withQuantity:(int)number;

-(int)getTotalQuantity;
-(int)getTotalCents;

-(void)testChange;
@end
