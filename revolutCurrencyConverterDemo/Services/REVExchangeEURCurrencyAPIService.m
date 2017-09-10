//
//  REVEchangeEURCurrencyAPIService.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 10/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVExchangeEURCurrencyAPIService.h"

@interface REVExchangeEURCurrencyAPIService ()

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) REVExchangeCurrencyAPIServiceCompletion completion;

@end

@implementation REVExchangeEURCurrencyAPIService

- (void)retrieveRateDataForCurrency:(REVCurrency *)currency
						 completion:(REVExchangeCurrencyAPIServiceCompletion)completion {
	if (![currency isKindOfClass:[REVEURCurrency class]] || !completion) {
		return;
	}
	self.completion = completion;
	
	[self.dataTask cancel];
	
	NSURL *URL = [NSURL URLWithString:@"http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"];
	self.dataTask =
	[[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		if (error) {
			self.error = error;
		}
		else {
			NSInteger HTTPStatusCode = [((NSHTTPURLResponse *)response) statusCode];
			if (HTTPStatusCode != 200) {
				self.error = [NSError errorWithDomain:@"com.wrongstatuscode"
												 code:HTTPStatusCode
											 userInfo:nil];
			}
		}
	}];
	[self.dataTask resume];
}

@end
