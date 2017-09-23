//
//  REVDeltaCurrency.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVDeltaCurrency.h"

@implementation REVDeltaCurrency

- (REVDeltaCurrency *)inverseDelta {
	REVDeltaCurrency *delta = [REVDeltaCurrency new];
	delta.fromCurrency = self.toCurrency;
	delta.toCurrency = self.fromCurrency;
	return delta;
}

- (BOOL)isValid {
	return self.fromCurrency != nil && self.toCurrency != nil;
}

@end
