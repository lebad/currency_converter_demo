//
//  REVCurrencyRateAPIService.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 16/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVCurrencyRateAPIService.h"
#import "REVCurrencyRateXMLParser.h"

@interface REVCurrencyRateAPIService ()

@property (nonatomic, strong) REVCurrencyRateXMLParser *XMLParser;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@end

@implementation REVCurrencyRateAPIService

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.XMLParser = [REVCurrencyRateXMLParser new];
	}
	return self;
}

- (void)getRatesWithCompletion:(REVCurrencyRateAPIServiceCompletion)completion {
	
	if (!completion) {
		return;
	}
	
	[self.dataTask cancel];
	
	NSURL *URL = [NSURL URLWithString:@"http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"];
	self.dataTask =
	[[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		if (error) {
			completion(nil, error);
		}
		else {
			NSInteger HTTPStatusCode = [((NSHTTPURLResponse *)response) statusCode];
			if (HTTPStatusCode != 200 || !data) {
				NSError *error = [NSError errorWithDomain:@"com.servererror"
												 code:HTTPStatusCode
											 userInfo:nil];
				completion(nil, error);
			}
			[self.XMLParser parseData:data withCompletion:completion];
		}
	}];
	[self.dataTask resume];
}

@end
