//
//  LSShopMonoTableViewCell.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-26.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductEntity.h"
#import "CartEntity.h"

@interface LSShopMonoTableViewCell : UITableViewCell

//@property UIImage * image;
//@property UIImageView * image_view;

@property CacheImageView * image_view;
@property UILabel * label;

-(void) loadProduct:(ProductEntity*) mono;
//-(void) loadMonoWithName:(NSString*)name andImageName:(NSString*)image_name;


@end
