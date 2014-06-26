//
//  LSShopCartTableViewCell.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-26.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSShopCartTableViewCell : UITableViewCell
@property UILabel * name;
@property UILabel * price;
@property UITextField * quantity;
@property UIButton * button_plus;
@property UIButton * button_minus;

//-(void)loadCartMono:(LSMonoInfo*)MonoInfo;
-(void)loadCartMonoWithName:(NSString*)name andPrice:(int)cents andQuantity:(int)quantity andID:(int)mono_id;
@end
