//
//  ImageWorker.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-9-2.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "ImageWorker.h"

@implementation ImageWorker
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
@end
