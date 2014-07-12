

#import "CacheDataLoader.h"


@implementation CacheDataLoader

//
- (NSString *)cachePath
{
	return NSUtil::CacheUrlPath(self.service);
}

//
- (NSString *)stampKey
{
	return [self.service stringByDeletingPathExtension];
}

//
- (NSDate *)date
{
	return super.date ? super.date : Settings::Get(self.stampKey);
}

//
- (void)loadIfOffline
{
	if (!_online)
	{
		[self loadBegin];
	}
}

//
- (void)loadStart
{
	if (_online) [super loadStart];
}

//
- (NSData *)loadData
{
    _Log(@"CacheDataLoader loadData called");
	NSData *data;
	NSString *cache = self.cachePath;
	if (_online)
	{
		data = [super loadData];
        NSDictionary* dict = [self parseData:data];
		if ([dict isKindOfClass:[NSDictionary class]])
		{
			DataLoaderError error = (DataLoaderError)[dict[@"CODE"] intValue];
			if (error == DataLoaderNoError)
			{
				[data writeToFile:cache atomically:YES];
                _Log(@"CacheDataLoader loadData online done data=[%@] written to cache[%@]",data,cache);
			}else{
                _Log(@"CacheDataLoader loadData online ERROR data=[%@] not written to cache[%@]",data,cache);
            }
		}else{
            _Log(@"CacheDataLoader loadData online INCORRECT data=[%@] not written to cache[%@]",data,cache);
        }
	}
	else
	{
		data = [NSData dataWithContentsOfFile:cache];
        if(data){
            _Log(@"CacheDataLoader loadData offline done data=[%@] from cache[%@]",data,cache);
        }else{
            _online=YES;
            data=[self loadData];
            if(data){
                _Log(@"CacheDataLoader loadData offline->online done data=[%@] from cache[%@]",data,cache);
            }else{
                NSMutableData *data_t = [[NSMutableData alloc] init];
                NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data_t];
                [archiver encodeObject:@"{'CODE':'-1','DATA':'NO CACHE'}" forKey:@"Some Key Value"];
                [archiver finishEncoding];
                data=data_t;
                _Log(@"CacheDataLoader loadData offline->online->fail done data=[%@] from cache[%@]",data,cache);
            }
        }
	}
    _Log(@"CacheDataLoader loadData finally [%@]",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
	return data;
}

//
- (void)loadStop:(NSDictionary *)dict
{
	//
	if (_online)
	{
        _Log(@"CacheDataLoader loadStop online with Dict=[%@]",dict);
		[super loadStop:dict];
		Settings::Save(self.stampKey, self.date);
	}
	else
	{
        _Log(@"CacheDataLoader loadStop offline with Dict=[%@]",dict);
		_online = YES;
		[self performSelector:@selector(loadBegin) withObject:nil afterDelay:1.0];
	}
}

@end
