//
//  LSStack.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-28.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSStack : NSObject
{
    NSMutableArray * array;
}
- (void)push:(id)object;
- (id)pop;
@end
