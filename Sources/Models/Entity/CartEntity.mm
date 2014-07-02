//
//  CartEntity.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-30.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "CartEntity.h"

static CartEntity * defaultCartEntity=nil;

@implementation CartEntity

+(CartEntity*)getDefaultCartEntity{
    if(defaultCartEntity==nil){
        defaultCartEntity=[[CartEntity alloc]init];
    }
    return defaultCartEntity;
}

-(id)init{
    self=[super init];
    self.cart_array=[[NSMutableArray alloc]init];
    return self;
}

-(void)resetCart{
    self.cart_array=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:self];
}

-(void)addToCart:(int)product_id withQuantity:(int)number{
    _Log(@"Cart addToCart[%d] with %d",product_id,number);
    if(number==0){
        return;
    }else{
        id mono=[[ProductEntity getProductDictionary] objectForKey:[NSString stringWithFormat:@"%d",product_id]];
        id pe=nil;
        for (pe in [[CartEntity getDefaultCartEntity] cart_array]) {
            _Log(@"seek in cart with [%@-%d(%d)]",[pe product_title],[pe product_id],product_id);
            if([pe product_id] == product_id){
                _Log(@"seek ZERO - - OK");
                break;
            }
        }
        if(pe==nil){
            _Log(@"sought out nothing..create");
            ProductEntity * pe=[[ProductEntity alloc]initProductWithId:[mono product_id] withTitle:[mono product_title] withCents:[mono product_price_cents] withMagentoID:[mono product_magento_id] withImageName:[mono product_image]];
            [pe setQuantity:number];
            [self.cart_array addObject:pe];
        }
        else{
            _Log(@"sought pe[%@-%d]",[pe product_title],[pe product_id]);
            if([pe quantity]+number>0){
                [pe setQuantity:[pe quantity]+number];
            }else{
                [[[CartEntity getDefaultCartEntity] cart_array] removeObject:pe];
            }
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
    }
}

-(int)getTotalQuantity{
    int total=0;
    for (ProductEntity * pe in [[CartEntity getDefaultCartEntity] cart_array]) {
        total+=[pe quantity];
    }
    return total;
}

-(int)getTotalCents{
    int total=0;
    for (ProductEntity * pe in [[CartEntity getDefaultCartEntity] cart_array]) {
        total+=[pe product_price_cents]*[pe quantity];
    }
    return total;
}

-(void)testChange{
    _Log(@"testChange called");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
}
@end
