//
//  LSConnectionDelegater.m
//  BNLP_Ni
//
//  Created by 倪 李俊 on 14-6-11.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import "LSConnectionDelegater.h"

@implementation LSConnectionDelegater


-(BOOL)tryMakeArrayFromData{
    id json=[NSJSONSerialization JSONObjectWithData:self.resultData options:NSJSONReadingMutableLeaves error:nil];
    if ([json isKindOfClass:[NSArray class]]) {
        NSArray *categories = json;
        self.resultArray=[[NSMutableArray alloc]init];
        // Process the array
        for (id item in categories) {
            //_Log(@"ARRAY item=%@",item);
            [self.resultArray addObject:item];
        }
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)tryMakeDictionaryFromData{
    id json=[NSJSONSerialization JSONObjectWithData:self.resultData options:NSJSONReadingMutableLeaves error:nil];
    if ([json isKindOfClass:[NSDictionary class]]) {
        NSArray *categories = json;
        self.resultDictionary=[[NSMutableDictionary alloc]init];
        // Process the array
        for (id item in categories) {
            //_Log(@"DIC item=%@",item);
            [self.resultDictionary addObject:[item valueForKey:@"user_name"]];
        }
        return YES;
    }else{
        return NO;
    }
}


/*
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse object.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    if (httpResponse.statusCode==200){
        NSLog(@"[LSConnectionDelegater] HTTP response OK received");
    }else{
        NSLog(@"[LSConnectionDelegater] HTTP response [%d] received",httpResponse.statusCode);
    }
    _resultData=[[NSMutableData alloc] initWithData:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [_resultData appendData:data];
    NSLog(@"[LSConnectionDelegater] didReceiveData [%@]",_resultData);
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    //theConnection = nil;
    // inform the user
    NSLog(@"[LSConnectionDelegater] Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a property elsewhere
    NSLog(@"[LSConnectionDelegater] Succeeded! Received %d bytes of data",[_resultData length]);
    
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    //theConnection = nil;
    _resultData = nil;
}

- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *)destinationURL{
    //Sent to the delegate when the URL connection has successfully downloaded the URL asset to a destination file.
    //Parameters
    // connection
    //  The URL connection object that downloaded the asset.
    // destinationURL
    //  A file URL specifying a destination in the file system. For iOS applications, this is a location in the application sandbox.
    //Discussion
    //This method will be called once after a successful download. The file downloaded to destinationURL is guaranteed to exist there only for the duration of this method implementation; the delegate should copy or move the file to a more persistent and appropriate location.
    NSString*data=[NSString stringWithContentsOfURL:destinationURL encoding:(NSUTF8StringEncoding) error:nil];
    NSLog(@"[LSConnectionDelegater] connectionDidFinishDownloading for %@ got [%@]",[destinationURL description],data);
    
}
*/


@end
