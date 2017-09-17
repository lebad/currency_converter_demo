//
//  REVCurrencyRateAPIService.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 16/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVCurrencyRateAPIService.h"
#import "REVCurrencyRateXMLParser.h"

NSString * const REVRateURLString = @"http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml";

@interface REVCurrencyRateAPIService ()

@property (nonatomic, strong) REVCurrencyRateXMLParser *XMLParser;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLRequest *request;

@end

@implementation REVCurrencyRateAPIService

- (instancetype)init
{
	self = [super init];
	if (self) {
		_XMLParser = [REVCurrencyRateXMLParser new];
	}
	return self;
}

- (NSURLSession *)session {
	if (!_session) {
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
		configuration.allowsCellularAccess = YES;
		configuration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
		_session = [NSURLSession sessionWithConfiguration:configuration];
	}
	return _session;
}

- (NSURLRequest *)request {
	if (!_request) {
		NSURL *URL = [NSURL URLWithString:REVRateURLString];
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
		[request setHTTPMethod:@"GET"];
		_request = [request copy];
	}
	return _request;
}

- (void)getRatesWithCompletion:(REVCurrencyRateAPIServiceCompletion)completion {
	
	if (!completion) {
		return;
	}
	
	[self.dataTask cancel];
	
	self.dataTask =
	[self.session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
