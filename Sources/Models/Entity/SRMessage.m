//
//  SRMessage.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-17.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "SRMessage.h"

@implementation SRMessage

/**
 {
 "srid":"1",
 "read":"0",
 "created":"100000000",
 "title":"MSG 1",
 "url":"https:\/\/testbaby.i9i8.com\/admin\/api\/asset\/pdt_outline.html"
 }
 **/
-(id)initWithItemDictionary:(NSDictionary*)dict{
    self=[super init];
    _srid=[(NSNumber*)[dict objectForKey:@"srid"] integerValue];
    _read=[(NSNumber*)[dict objectForKey:@"have_read"] intValue]==0?NO:YES;
    _time=[(NSNumber*)[dict objectForKey:@"created"] integerValue];
    _title=[dict objectForKey:@"title"];
    _url=[dict objectForKey:@"url"];
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeInt:self.srid forKey:@"srid"];
    [coder encodeBool:self.read forKey:@"read"];
    [coder encodeInt32:self.time forKey:@"created"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.url forKey:@"url"];
}

- (id) initWithCoder: (NSCoder *) coder
{
    _srid = [coder decodeIntegerForKey:@"srid"];
    _read = [coder decodeBoolForKey:@"read"];
    _time = [coder decodeInt32ForKey:@"created"];
    _title = [[coder decodeObjectForKey:@"title"] copy];
    _url = [[coder decodeObjectForKey:@"url"] copy];
    return self;
}

-(NSString*)logAbstract{
    return [NSString stringWithFormat:@"srid[%d](R=%d):%@ -> %@",_srid,_read,_title,_url];
}

@end
