//
//  NCTableView.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-19.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCTableViewCell.h"

@protocol NCTableViewDelegate <NSObject>

-(void)processTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface NCTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property NSMutableArray * sectionArrayOfDict;
@property id<NCTableViewDelegate> NCDelegate;
@end
