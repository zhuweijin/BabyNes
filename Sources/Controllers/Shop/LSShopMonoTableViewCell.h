//
//  LSShopMonoTableViewCell.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-26.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSShopMonoTableViewCell : UITableViewCell

@property UIImage * image;
//@property UIImageView * image_view;
@property UILabel * label;

//-(void) loadMono:(LSMonoInfo*) mono;
-(void) loadMonoWithName:(NSString*)name andImageName:(NSString*)image_name;

@end
