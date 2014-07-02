//
//  SinriUIApplication.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-2.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "SinriUIApplication.h"

@implementation SinriUIApplication

-(NSTimeInterval)maxIdleTime{
    return 5*60;
}

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    // 只在开始或结束触摸时 reset 闲置时间, 以减少不必须要的时钟 reset 动作
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0) {
        // allTouchescount 似乎只会是 1, 因此 anyObject 总是可用的
        UITouchPhase phase =((UITouch *)[allTouches anyObject]).phase;
        if (phase ==UITouchPhaseBegan || phase == UITouchPhaseEnded)
            [self resetIdleTimer];
    }
}

- (void)resetIdleTimer {
    if (_idleTimer) {
        [_idleTimer invalidate];
    }
    _idleTimer = [NSTimer scheduledTimerWithTimeInterval:[self maxIdleTime] target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
    _Log(@"SinriUIApplication resetIdleTimer for about %lf seconds",[self maxIdleTime]);
} 

- (void)idleTimerExceeded {
    _Log(@"SinriUIApplication idleTimerExceeded");
    UIUtil::ShowAlert(@"SinriUIApplication idleTimerExceeded");
}



@end
