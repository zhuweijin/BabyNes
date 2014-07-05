//
//  PRMoviePlayer.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-3.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "MoviePlayer.h"

@interface PRMoviePlayer : MoviePlayer{
    //BOOL isClickedFullScreenButton;
    BOOL is_show_status_bar;
}
@property UIButton * endPR;
@property NSString * theTitle;
-(id)initWithPath:(NSString *)path withTitle:(NSString*)title;
@end
