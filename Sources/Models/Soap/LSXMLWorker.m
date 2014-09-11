//
//  LSXMLWorker.m
//  SoapTester
//
//  Created by 倪 李俊 on 14-7-22.
//  Copyright (c) 2014年 Sinri. All rights reserved.
//

#import "LSXMLWorker.h"

static BOOL xml_debug=NO;

@implementation LSXMLWorker

-(id)initWithXMLData:(NSData*)data{
    self=[super init];
    if(self){
        _xmlData=data;
        _xmlParser=[[NSXMLParser alloc]initWithData:_xmlData];
        [_xmlParser setDelegate:self];
        _prasing_done=LSXMLWorkerParseStateInit;
        BOOL parsed=[_xmlParser parse];
        if(xml_debug)_Log(@"parsed=%d",parsed);
    }
    return self;
}

#pragma mark xmlparser
//step 1 :准备解析
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    if(xml_debug)_Log(@"LSXMLWorker parserDidStartDocument");
    objFamily=[[NSMutableArray alloc]init];
}
//step 2：准备解析节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if(xml_debug)_Log(@"LSSoapWorker parser didStartElement:%@ namespaceURI:%@ qualifiedName:%@ attributes:%@",elementName,namespaceURI,qName,attributeDict);
    currentObject=[[LSXMLObject alloc]init];
    [currentObject setName:elementName];
    [currentObject setAttributeDictionary:[[NSMutableDictionary alloc]initWithDictionary:attributeDict]];
    if([objFamily count]>0){
        LSXMLObject * parentObject=[objFamily objectAtIndex:[objFamily count]-1];
        [parentObject addSubObject:currentObject];
    }else{
        _rootObject = currentObject;
    }
    [objFamily addObject:currentObject];
    tmpString=[[NSMutableString alloc]init];
}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(xml_debug)_Log(@"LSSoapWorker parser foundCharacters:%@",string);
    [tmpString appendString:string];
}

//step 4 ：解析完当前节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if(xml_debug)_Log(@"LSSoapWorker parser didEndElement:%@ namespaceURI:%@ qualifiedName:%@",elementName,namespaceURI,qName);
    [currentObject setText:tmpString];
    if([objFamily count]>0){
        [objFamily removeLastObject];
    }else{
        if(xml_debug)_Log(@"error - -");
    }
    if([objFamily count]==0){
        if(xml_debug)_Log(@"FINALLY:%@",_rootObject);
    }
}

//step 5：解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if(xml_debug)_Log(@"LSSoapWorker parserDidEndDocument");
    _prasing_done=LSXMLWorkerParseStateDone;    
}
//step 6：获取cdata块数据
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    if(xml_debug)_Log(@"LSSoapWorker parser foundCDATA:%@",CDATABlock);
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    _prasing_done=LSXMLWorkerParseStateFailed;
}
@end

@implementation LSXMLObject

-(void)addSubObject:(LSXMLObject*)obj{
    if(!_subObjectArray){
        _subObjectArray=[[NSMutableArray alloc]init];
    }
    [_subObjectArray addObject:obj];
}
-(void)addAttribute:(NSString*)attr forKey:(NSString*)key{
    if(!_attributeDictionary){
        _attributeDictionary=[[NSMutableDictionary alloc]init];
    }
    [_attributeDictionary setObject:attr forKey:key];
}
-(NSMutableArray*)getSubNodeWithName:(NSString*)name withAttributes:(NSDictionary*)attributes{
    if(_subObjectArray && [_subObjectArray count]>0){
        NSMutableArray * array=[[NSMutableArray alloc]init];
        for (LSXMLObject * node in _subObjectArray) {
            BOOL allright=YES;
            if([[node name]isEqualToString:name]){
                if(attributes && [attributes count]>0){
                    for (id key in [attributes allKeys]) {
                        NSString * atari=[attributes objectForKey:key];
                        NSString * sought=[node.attributeDictionary objectForKey:key];
                        if(!(sought && [sought isEqualToString:atari])){
                            allright=NO;
                            break;
                        }
                    }
                }
            }else{
                allright=NO;
            }
            if(allright){
                [array addObject:node];
            }
        }
        return array;
    }
    return nil;
}
#pragma mark description from NSObject
-(NSString*)description{
    NSMutableString* str=[[NSMutableString alloc]initWithString: @"LSXMLObject"];
    [str appendFormat:@" NAME[%@]",_name];
    if (_attributeDictionary && [_attributeDictionary count]>0) {
        [str appendFormat:@"\nATTRIBUTES{\n%@\n}", _attributeDictionary];
    }
    [str appendFormat:@"\nTEXT:%@",_text];
    if(_subObjectArray && [_subObjectArray count]>0){
        //[str appendFormat:@"\nSUB OBJECTS<\n%@\n>", _subObjectArray];
        [str appendString:@"\nSUB OBJECTS<"];
        for (LSXMLObject * obj in _subObjectArray) {
            [str appendFormat:@"\n%@",obj];
        }
        [str appendString:@"\n>"];
    }
    return [str description];
}
@end