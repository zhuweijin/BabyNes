//
//  PRMoviePlayer.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-3.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "PRMoviePlayer.h"

@interface PRMoviePlayer ()

+(NSString*)get_PR_Movie_URL;

@end

@implementation PRMoviePlayer

+(NSString*)get_PR_Movie_URL{
    return @"http://uniquebaby.duapp.com/babynesios/admin/api/video/video-4.mp4";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_player setRepeatMode:(MPMovieRepeatModeOne)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _endPR=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];//[[UIButton alloc]initWithFrame:CGRectMake(40, 40, 100, 50)];
    [_endPR setFrame:CGRectMake(40, 40, 120, 50)];
    [_endPR setBackgroundColor:[UIColor redColor]];
    [_endPR.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [_endPR setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_endPR setTitle:NSLocalizedString(@"Exit", @"退出") forState:(UIControlStateNormal)];
    [_endPR addTarget:self action:@selector(exit:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_endPR];
    [self.view bringSubviewToFront:_endPR];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self performSelector:@selector(killEndPR:) withObject:self afterDelay:5];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)killEndPR:(id)sender{
    if(_endPR){
        [_endPR removeFromSuperview];
    }
}

-(void)exit:(id)sender{
    _Log(@"PRMoviePlayer exit called");
    [_player stop];
    _player=nil;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PR_EXIT" object:nil];
}

@end
