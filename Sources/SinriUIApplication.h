//
//  SinriUIApplication.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-2.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinriUIApplication : UIApplication
//maxIdleTime 和 idleTimer
@property NSTimer * idleTimer;
-(NSTimeInterval)maxIdleTime;

/**
 * Resets the idle timer to its initial state. This method gets called
 * every time there is a touch on the screen.  It should also be called
 * when the user correctly enters their pin to access the application.
 */
- (void)resetIdleTimer;
@end
