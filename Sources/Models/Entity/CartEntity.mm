//
//  CartEntity.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-30.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "CartEntity.h"

static CartEntity * defaultCartEntity=nil;
static BOOL isChanging=false;

static CartMode theCartMode=CartModeSale;

@implementation CartEntity

+(CartMode)getCartMode{
    return theCartMode;
}
+(void)setCartMode:(CartMode)cartMode{
    theCartMode=cartMode;
}
+(NSString*)getCurrentCartModeString{
    return [CartEntity getCartModeString:[CartEntity getCartMode]];
}
+(NSString*)getCartModeString:(CartMode)cartMode{
    if(cartMode==CartModeSale){
        return NSLocalizedString(@"Sale", @"销售");
    }else if(cartMode==CartModeReturn){
        return NSLocalizedString(@"RMA", @"退货");
    }else{
        return @"(╯‵□′)╯︵┻━┻";
    }
}

+(BOOL)getChangeState{
    return isChanging;
}
+(void)setChangeState:(BOOL)isChangeStart{
    isChanging=isChangeStart;
}

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

+(void)setDefaultCartEntity:(CartEntity*)ce{
    defaultCartEntity=ce;
}

-(void)resetCart{
    self.cart_array=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
}

-(int)currentQuantityOfProductID:(int)pid{
    for (ProductEntity * pe in self.cart_array) {
        if([pe product_id]==pid){
            return [pe product_id];
        }
    }
    return 0;
}

-(int)currentArrayIndexOfProductID:(int)pid{
    for (int i=0;i< [self.cart_array count]; i++) {
        ProductEntity * pe= [self.cart_array objectAtIndex:i];
        if([pe product_id]==pid){
            return i;
        }
    }
    return -1;
}

/**
 SALE: product_id is plus
 RMA: product_id is negetive
 **/
-(void)addToCart:(int)product_id withQuantity:(int)number{
    _Log(@"Cart addToCart[%d] with %d",product_id,number);
    isChanging=false;
    if(number==0){
        return;
    }else{
        if([CartEntity getCartMode]==CartModeSale){//SALE
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
                if(number==0){
                    _Log(@"07091229 number=%d",number);
                    return;
                }
                _Log(@"sought out nothing..create");
                ProductEntity * pe=[[ProductEntity alloc]initProductWithId:[mono product_id] withTitle:[mono product_title] withCents:[mono product_price_cents] withMagentoID:[mono product_magento_id] withImageName:[mono product_image]];
                [pe setQuantity:number];
                [self.cart_array addObject:pe];
            }
            else{
                _Log(@"sought pe[%@-%d]",[pe product_title],[pe product_id]);
                if([pe quantity]+number!=0){
                    [pe setQuantity:[pe quantity]+number];
                }else{
                    [[[CartEntity getDefaultCartEntity] cart_array] removeObject:pe];
                }
                
            }
        }else{//RMA
            //首先用【退换模式的product_id的相反数id】找到真正的货物 (PE)mono
            id mono=[[ProductEntity getProductDictionary] objectForKey:[NSString stringWithFormat:@"%d",-product_id]];
            //然后用【退换模式的product_id】找出CECArray里的已有的退换货物，这个Array是在CE里面的，退换的ID也是负的
            id pe=nil;
            for (pe in [[CartEntity getDefaultCartEntity] cart_array]) {
                _Log(@"seek in cart with [%@-%d(%d)]",[pe product_title],[pe product_id],product_id);
                if([pe product_id] == product_id){
                    _Log(@"seek ZERO - - OK");
                    break;
                }
            }
            if(pe==nil){//没有找到退换的
                if(number==0){
                    _Log(@"07301929 number=%d",number);
                    return;
                }
                _Log(@"sought out nothing..create");
                //新建一个PE对象，用于加入CA
                ProductEntity * pe=[[ProductEntity alloc]initProductWithId:-[mono product_id] withTitle:[mono product_title] withCents:[mono product_price_cents] withMagentoID:[mono product_magento_id] withImageName:[mono product_image]];
                [pe setQuantity:number];
                [self.cart_array addObject:pe];
            }
            else{//找到了退换的
                _Log(@"sought pe[%@-%d]",[pe product_title],[pe product_id]);
                if([pe quantity]+number!=0){
                    [pe setQuantity:[pe quantity]+number];
                }else{
                    [[[CartEntity getDefaultCartEntity] cart_array] removeObject:pe];
                }
            }
        }
        
        //Anyway all is over now, tell everyone
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

-(int)getTotalSaleQuantity{
    int total=0;
    for (ProductEntity * pe in [[CartEntity getDefaultCartEntity] cart_array]) {
        if([pe product_id]>0)
            total+=[pe quantity];
    }
    return total;
}
-(int)getTotalSaleCents{
    int total=0;
    for (ProductEntity * pe in [[CartEntity getDefaultCartEntity] cart_array]) {
        if([pe product_id]>0)
            total+=[pe product_price_cents]*[pe quantity];
    }
    return total;
}
-(int)getTotalReturnQuantity{
    int total=0;
    for (ProductEntity * pe in [[CartEntity getDefaultCartEntity] cart_array]) {
        if([pe product_id]<0)
            total+=[pe quantity];
    }
    return -total;
}
-(int)getTotalReturnCents{
    int total=0;
    for (ProductEntity * pe in [[CartEntity getDefaultCartEntity] cart_array]) {
        if([pe product_id]<0)
            total+=[pe product_price_cents]*[pe quantity];
    }
    return total;
}
/*
 -(void)testChange{
 _Log(@"testChange called");
 [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
 }
 */
/*
-(NSDictionary*)toDictionary{
    
}
*/
-(NSString*)toJson{
    NSError * error=nil;
    
    NSMutableArray * orderList=[[NSMutableArray alloc]init];
    for (ProductEntity * pe in self.cart_array) {
        NSString* mid=[pe product_magento_id];
        int q=[pe quantity];
        [orderList addObject:@{@"sku": mid,@"number":[NSNumber numberWithInt:q]}];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:orderList
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}
+(CartEntity*)fromJson:(NSString*)json{
    CartEntity * cart=[[CartEntity alloc]init];
    NSError * error=nil;
    NSMutableArray*ma=[[NSMutableArray alloc]initWithArray: [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:&error]];
    [cart setCart_array:ma];
    return cart;
}
@end
