//
//  SinriUIApplication.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-2.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "SinriUIApplication.h"
#import "ServerConfig.h"

static BOOL shouldMonitorIdle=YES;

@implementation SinriUIApplication

-(NSString*)getPRURL{
    //return @"http://uniquebaby.duapp.com/babynesios/admin/api/video/video-4.mp4";
    NSString*url=[[ServerConfig getServerConfig]getURL_idle_video];
    NSString * cache_file=NSUtil::CacheUrlPath(url);
    NSString*final=url;
    if(NSUtil::IsFileExist(cache_file)){
        final=cache_file;
    }
    _Log(@"PR Time! finally %@",final);
    return final;
}

-(void)registerEndPRNotificationReceiver{
    _is_playing=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PR_EXIT:) name:@"PR_EXIT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PR_CALLED:) name:@"PR_CALLED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PR_PHOTO_EXIT:) name:@"PR_PHOTO_EXIT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PR_PHOTO_CALLED:) name:@"PR_PHOTO_CALLED" object:nil];
}

-(NSTimeInterval)maxIdleTime{
    return 60*5;
    //return 20;
}

+(BOOL)isToMonitorIdle{
    return shouldMonitorIdle;
}
+(void)setShouldMonitorIdle:(BOOL)toMonitor{
    shouldMonitorIdle=toMonitor;
}

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    // 只在开始或结束触摸时 reset 闲置时间, 以减少不必须要的时钟 reset 动作
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0) {
        // allTouchescount 似乎只会是 1, 因此 anyObject 总是可用的
        UITouchPhase phase =((UITouch *)[allTouches anyObject]).phase;
        if (phase ==UITouchPhaseBegan || phase == UITouchPhaseEnded){
            [self resetIdleTimer];
        }
    }
}

- (void)resetIdleTimer {
    if (_idleTimer) {
        [_idleTimer invalidate];
        //_Log(@"SinriUIApplication resetIdleTimer");
    }
    if([SinriUIApplication isToMonitorIdle]){
        _idleTimer = [NSTimer scheduledTimerWithTimeInterval:[self maxIdleTime] target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
        //_Log(@"SinriUIApplication resetIdleTimer start for about %lf seconds",[self maxIdleTime]);
    }
    
} 

- (void)idleTimerExceeded {
    _Log(@"SinriUIApplication idleTimerExceeded");
    //UIUtil::ShowAlert(@"SinriUIApplication idleTimerExceeded");
    if(!_is_playing && [SinriUIApplication isToMonitorIdle]){
        [self loadPR:nil withTitle:nil];
        _Log(@"SinriUIApplication idleTimerExceeded to PR");
    }
}

-(void) loadPR:(NSString*)url withTitle:(NSString *)title{
    self.OriginalWindow=[self keyWindow];
    self.PRWindow=[[UIWindow alloc] initWithFrame:UIUtil::ScreenBounds()];
    if(url==nil)url=[self getPRURL];
    PRMoviePlayer * mp=[[PRMoviePlayer alloc]initWithPath:url withTitle:title];
    
    [self.PRWindow setRootViewController:mp];
    [self.PRWindow makeKeyAndVisible];
    
    //[[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
    [self setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
    
    _is_playing=YES;
}

-(void)unloadPR{
    [self.OriginalWindow makeKeyAndVisible];
    self.PRWindow=nil;
    //[[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    [self setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    _is_playing=NO;
}

-(void)PR_EXIT:(NSNotification*)notification{
    if(self.PRWindow){
        [self unloadPR];
    }
}

-(void)PR_CALLED:(NSNotification*)notification{
    NSDictionary * dict = notification.object;
    NSString * final_video_url=[dict objectForKey:@"file"];
    NSString * name=[dict objectForKey:@"name"];
    _Log(@"PR_CALLED for [%@]",final_video_url);
    [self loadPR:final_video_url withTitle:name];
}

-(void) loadPR_PHOTO:(UIImage*)image withTitle:(NSString *)title{
    self.OriginalWindow_PP=[self keyWindow];
    self.PPWindow=[[UIWindow alloc] initWithFrame:UIUtil::ScreenBounds()];
    //if(url==nil)url=[self getPRURL];
    PRPhotoPlayer * pp=[[PRPhotoPlayer alloc]initWithImage:image withTitle:title];
    
    [self.PPWindow setRootViewController:pp];
    [self.PPWindow makeKeyAndVisible];
    
    //[[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
    [self setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
    
    _is_playing=YES;
}

-(void)unloadPR_PHOTO{
    [self.OriginalWindow_PP makeKeyAndVisible];
    self.PPWindow=nil;
    //[[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    [self setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    _is_playing=NO;
}

-(void)PR_PHOTO_EXIT:(NSNotification*)notification{
    if(self.PPWindow){
        [self unloadPR_PHOTO];
    }
}

-(void)PR_PHOTO_CALLED:(NSNotification*)notification{
    _Log(@"PR_PHOTO_CALLED for dict[%@]", notification.object);
    NSDictionary * dict = notification.object;
    //NSString * final_video_url=[dict objectForKey:@"file"];
    UIImage * image=[dict objectForKey:@"file"];
    NSString * name=[dict objectForKey:@"name"];
    _Log(@"PR_PHOTO_CALLED for [%@]", name);
    [self loadPR_PHOTO:image withTitle:name];
}

@end
