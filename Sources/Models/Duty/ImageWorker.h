//
//  ImageWorker.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-9-2.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageWorker : NSObject
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
