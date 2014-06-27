//
//  LSTabButton.h
//  BabyNesPOS_Akatsuki
//
//  Created by 倪 李俊 on 14-6-25.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSTabButton : UIButton
@property BOOL isActive;

-(void)asActive;
-(void)asInactive;
@end
