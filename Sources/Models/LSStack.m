//
//  LSStack.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-28.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSStack.h"

@implementation LSStack
-(id)init{
    self=[super init];
    if(self){
        array=[[NSMutableArray alloc]init];
    }
    return self;
}
- (void)push:(id)object{
    [array addObject:object];
}
- (id)pop{
    id returnObject = [array lastObject];
    if (returnObject) {
        [array removeLastObject];
    }
    return returnObject;
}
@end
