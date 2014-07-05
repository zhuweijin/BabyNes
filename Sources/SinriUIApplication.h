//
//  SinriUIApplication.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-2.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRMoviePlayer.h"
#import "PRPhotoPlayer.h"

@interface SinriUIApplication : UIApplication
//maxIdleTime 和 idleTimer
@property NSTimer * idleTimer;
-(NSTimeInterval)maxIdleTime;

-(void)registerEndPRNotificationReceiver;

@property BOOL is_playing;

@property UIWindow * PRWindow;
@property UIWindow * PPWindow;
@property UIWindow * OriginalWindow;
@property UIWindow * OriginalWindow_PP;

-(void) loadPR:(NSString*)url withTitle:(NSString *)title;
-(void) unloadPR;
//-(void)PR_EXIT:(NSNotification*)notification;
//-(void)PR_CALLED:(NSNotification*)notification;

/**
 * Resets the idle timer to its initial state. This method gets called
 * every time there is a touch on the screen.  It should also be called
 * when the user correctly enters their pin to access the application.
 */
- (void)resetIdleTimer;
@end
