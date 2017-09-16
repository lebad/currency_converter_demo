//
//  REVRatesDownloader.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 16/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVRatesDownloader.h"

@implementation REVRatesDownloader

- (void)main {
	if (self.isCancelled) {
		return;
	}
	__block NSArray<REVRate *> *downloadedRates = [NSArray array];
	__block NSError *downloadedError = nil;
	
	dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
	[self.rateService getRatesWithCompletion:^(NSArray<REVRate *> *rates, NSError *error) {
		if (error) {
			downloadedError = error;
		}
		downloadedRates = rates;
		dispatch_semaphore_signal(semaphore);
	}];
	dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
	
	if (self.isCancelled) {
		return;
	}
	
	self.error = downloadedError;
	self.rates = downloadedRates;
}

@end
