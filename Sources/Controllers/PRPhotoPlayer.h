//
//  PRPhotoPlayer.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-5.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRPhotoPlayer : UIViewController

@property UINavigationBar *navigationBar;
@property UINavigationItem *theNavigationItem;
@property UIBarButtonItem *leftButton;

@property UIImage * theImage;
@property NSString * theTitle;
@property UIImageView * hugeImage;
@property UIScrollView * hugeImageView;

-(id) initWithImage:(UIImage*)image withTitle:(NSString*)title;

@end
