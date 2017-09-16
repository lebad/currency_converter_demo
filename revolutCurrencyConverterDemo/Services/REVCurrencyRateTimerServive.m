//
//  REVCurrencyRateTimerServive.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 16/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVCurrencyRateTimerServive.h"
#import "REVRatesDownloader.h"
#import "REVCurrencyRateAPIService.h"

static const NSTimeInterval TimerInterval = 30.0;

@interface REVCurrencyRateTimerServive ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) REVCurrencyRateAPIServiceCompletion completion;
@property (nonatomic, strong) REVRatesDownloader *ratesDownloader;
@end

@implementation REVCurrencyRateTimerServive

+ (instancetype)shared
{
	static REVCurrencyRateTimerServive *timerService = nil;
	static dispatch_once_t token;
	dispatch_once(&token, ^{
		timerService = [self new];
	});
	return timerService;
}

- (void)getRatesWithCompletion:(REVCurrencyRateAPIServiceCompletion)completion {
	if (!completion) {
		return;
	}
	self.completion = completion;
	[self.queue cancelAllOperations];
	self.queue = [[NSOperationQueue alloc] init];
	self.timer = [NSTimer scheduledTimerWithTimeInterval:TimerInterval
											  target:self
											selector:@selector(repeat)
											userInfo:nil
											 repeats:YES];
	[self.timer fire];
}

- (void)repeat
{
	self.ratesDownloader = [[REVRatesDownloader alloc] init];
	self.ratesDownloader.rateService = [[REVCurrencyRateAPIService alloc] init];
	__weak REVRatesDownloader *weakRatesDownloader = self.ratesDownloader;
	__weak typeof(self) weakSelf = self;
	self.ratesDownloader.completionBlock = ^{
		if (!weakRatesDownloader.cancelled) {
			dispatch_async(dispatch_get_main_queue(), ^{
				weakSelf.completion(weakRatesDownloader.rates, weakRatesDownloader.error);
			});
		}
	};
	[self.queue addOperation:self.ratesDownloader];
}

@end
