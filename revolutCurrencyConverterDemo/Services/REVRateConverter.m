//
//  REVRateConverter.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 23/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVRateConverter.h"

@interface REVRateConverter ()
@property (nonatomic, strong) NSArray<REVRate *> *rates;
@end

@implementation REVRateConverter

- (instancetype)initWithRates:(NSArray<REVRate *> *)rates {
	self = [super init];
	if (self) {
		_rates = rates;
	}
	return self;
}

- (REVRate *)calculateRateForDelta:(REVDeltaCurrency *)delta {
	NSDecimalNumber *fromCurrencyRate = [NSDecimalNumber decimalNumberWithString:@""];
	NSDecimalNumber *toCurrencyRate = [NSDecimalNumber decimalNumberWithString:@""];
	for (REVRate *rate in self.rates) {
		if ([rate.deltaCurrency.toCurrency isEqualToCurrency:delta.fromCurrency]) {
			fromCurrencyRate = rate.rate;
		}
		if ([rate.deltaCurrency.toCurrency isEqualToCurrency:delta.toCurrency]) {
			toCurrencyRate = rate.rate;
		}
	}
	NSDecimalNumber *calculatedRateDecimalNumber = [toCurrencyRate currencyDecimalNumberByDividingBy:fromCurrencyRate];
	REVRate *calculatedRate = [REVRate new];
	calculatedRate.deltaCurrency = delta;
	calculatedRate.rate = calculatedRateDecimalNumber;
	return calculatedRate;
}

@end
