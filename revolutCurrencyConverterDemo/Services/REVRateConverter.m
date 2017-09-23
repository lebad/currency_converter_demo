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
	REVRate *calculatedRate = [REVRate new];
	calculatedRate.deltaCurrency = delta;
	
	if ([delta.fromCurrency isEqualToCurrency:delta.toCurrency]) {
		calculatedRate.rate = [NSDecimalNumber decimalNumberWithString:@"1"];
		return calculatedRate;
	}
	
	for (REVRate *rate in self.rates) {
		if ([rate.deltaCurrency.fromCurrency isEqualToCurrency:delta.fromCurrency]
			&& [rate.deltaCurrency.toCurrency isEqualToCurrency:delta.toCurrency]) {
			calculatedRate.rate = rate.rate;
			return calculatedRate;
		}
	}
	
	NSDecimalNumber *fromCurrencyRate = [NSDecimalNumber decimalNumberWithString:@""];
	NSDecimalNumber *toCurrencyRate = [NSDecimalNumber decimalNumberWithString:@""];
	for (REVRate *rate in self.rates) {
		if ([rate.deltaCurrency.toCurrency isEqualToCurrency:delta.fromCurrency]) {
			fromCurrencyRate = rate.rate;
		}
		if ([rate.deltaCurrency.toCurrency isEqualToCurrency:delta.toCurrency]) {
			toCurrencyRate = rate.rate;
		}
		
		if ([rate.deltaCurrency.fromCurrency isEqualToCurrency:delta.toCurrency]
			&& [rate.deltaCurrency.toCurrency isEqualToCurrency:delta.fromCurrency]) {
			fromCurrencyRate = rate.rate;
			toCurrencyRate = [NSDecimalNumber decimalNumberWithString:@"1"];
		}
	}
	NSDecimalNumber *calculatedRateDecimalNumber = [toCurrencyRate currencyDecimalNumberByDividingBy:fromCurrencyRate];
	calculatedRate.rate = calculatedRateDecimalNumber;
	return calculatedRate;
}

#pragma mark - REVRateServiceProtocol

- (NSDecimalNumber *)currencyRateForDelta:(REVDeltaCurrency *)delta {
	REVRate *rate = [self calculateRateForDelta:delta];
	return rate.rate;
}

@end
