//
//  MonoTable.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-26.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSShopMonoTableViewCell.h"
#import "ProductEntity.h"
#import "CartEntity.h"

@interface MonoTable : UITableView <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
//@property NSMutableArray * pdtArray;
//-(void)setPdtArrayWithNSDic:(NSDictionary*)dict;
@property id<UIScrollViewDelegate> theSVDelegate;
@end
