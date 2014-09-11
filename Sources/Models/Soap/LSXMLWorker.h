//
//  LSXMLWorker.h
//  SoapTester
//
//  Created by 倪 李俊 on 14-7-22.
//  Copyright (c) 2014年 Sinri. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum:NSInteger{
    LSXMLWorkerParseStateInit=0,
    LSXMLWorkerParseStateDone=1,
    LSXMLWorkerParseStateFailed=2
}LSXMLWorkerParseState;

@interface LSXMLObject : NSObject
@property NSString * name;
@property NSMutableDictionary * attributeDictionary;
@property NSString * text;
@property NSMutableArray * subObjectArray;
-(void)addSubObject:(LSXMLObject*)obj;
-(void)addAttribute:(NSString*)attr forKey:(NSString*)key;
-(NSMutableArray*)getSubNodeWithName:(NSString*)name withAttributes:(NSDictionary*)attributes;
@end

@interface LSXMLWorker : NSObject
<NSXMLParserDelegate>
{
    LSXMLObject * currentObject;
    NSMutableArray * objFamily;
    NSMutableString * tmpString;
}
@property LSXMLWorkerParseState prasing_done;

@property NSXMLParser * xmlParser;
@property NSData * xmlData;

@property LSXMLObject * rootObject;
-(id)initWithXMLData:(NSData*)data;
@end

