//
//  LSSoapWorker.m
//  SoapTester
//
//  Created by 倪 李俊 on 14-7-22.
//  Copyright (c) 2014年 Sinri. All rights reserved.
//

#import "LSSoapWorker.h"

@implementation LSSoapWorker

static BOOL debugModeOn=YES;

+(BOOL)debugMode{
    return debugModeOn;
}

+(void)setDebugMode:(BOOL)on{
    debugModeOn=on;
}

/*
@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;
*/

// 开始查询
- (void)doQueryWithMatchingElement:(NSString*)matchingElement withSoapMsg:(NSString*)soapMsg withURL:(NSString*)the_url withHeaders:(NSDictionary*)dict{
    // 设置我们之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签对应
    _matchingElement = matchingElement;
    // 创建SOAP消息，内容格式就是网站上提示的请求报文的实体主体部分,将这个XML字符串打印出来
    NSLog(@"SOAP消息:%@", soapMsg);
    // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
    NSURL *url = [NSURL URLWithString: the_url];
    // 根据上面的URL创建一个请求
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    if(dict && [dict isKindOfClass:[NSDictionary class]]){
        for (NSString* key in [dict allKeys]) {
            NSString *value=[dict objectForKey:key];
            [req addValue:value forHTTPHeaderField:key];
        }
    }
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
    // 添加请求的详细信息，与请求报文前半部分的各字段对应
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    // 设置请求行方法为POST，与请求报文第一行对应
    [req setHTTPMethod:@"POST"];
    // 将SOAP消息加到请求中
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    // 创建连接
    _conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (_conn) {
        _webData = [NSMutableData data];
    }
}

#pragma mark -
#pragma mark URL Connection Data Delegate Methods

// 刚开始接受响应时调用
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response{
    [_webData setLength: 0];
}

// 每接收到一部分数据就追加到webData中
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *) data {
    [_webData appendData:data];
}

// 出现错误时
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) error {
    _conn = nil;
    _webData = nil;
}

// 完成接收数据时调用
-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    NSString *theXML = [[NSString alloc] initWithBytes:[_webData mutableBytes]
                                                length:[_webData length]
                                              encoding:NSUTF8StringEncoding];
    
    // 打印出得到的XML
    NSLog(@"%@", theXML);
    // 使用NSXMLParser解析出我们想要的结果
    LSXMLWorker * xmlWorker=[[LSXMLWorker alloc]initWithXMLData:_webData];
    NSLog(@"get xmlWorker, parsed=%d as:\n%@",xmlWorker.prasing_done,xmlWorker.rootObject);
    /*
    _xmlParser = [[NSXMLParser alloc] initWithData: _webData];
    [_xmlParser setDelegate: self];
    [_xmlParser setShouldResolveExternalEntities: YES];
    [_xmlParser parse];
     */
}

#pragma mark -
#pragma mark XML Parser Delegate Methods

// 开始解析一个元素名
-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict {
    if([LSSoapWorker debugMode]){
        NSLog(@"LSSoapWorker parser didStartElement:%@ namespaceURI:%@ qualifiedName:%@ attributes:%@",elementName,namespaceURI,qName,attributeDict);
    }
    if ([elementName isEqualToString:_matchingElement]) {
        if (!_soapResults) {
            _soapResults = [[NSMutableString alloc] init];
        }
        _elementFound = YES;
    }
}

// 追加找到的元素值，一个元素值可能要分几次追加
-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string {
    if([LSSoapWorker debugMode]){
        NSLog(@"LSSoapWorker parser foundCharacters:%@",string);
    }
    if (_elementFound) {
        [_soapResults appendString: string];
    }
}

// 结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([LSSoapWorker debugMode]){
        NSLog(@"LSSoapWorker parser didEndElement:%@ namespaceURI:%@ qualifiedName:%@",elementName,namespaceURI,qName);
    }
    if ([elementName isEqualToString:_matchingElement]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"手机号码信息"
                                                        message:[NSString stringWithFormat:@"%@", _soapResults]
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        //_elementFound = FALSE;
        // 强制放弃解析
        //[_xmlParser abortParsing];
    }
}

// 解析整个文件结束后
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if([LSSoapWorker debugMode]){
        NSLog(@"LSSoapWorker parserDidEndDocument");
    }
    if (_soapResults) {
        _soapResults = nil;
    }
}

// 出错时，例如强制结束解析
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if([LSSoapWorker debugMode]){
        NSLog(@"LSSoapWorker parser parseErrorOccurred:%@",parseError);
    }
    if (_soapResults) {
        _soapResults = nil;
    }
}

@end
