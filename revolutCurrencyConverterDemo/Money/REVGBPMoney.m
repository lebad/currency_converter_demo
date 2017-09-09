//
//  REVGBPMoney.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVGBPMoney.h"

@implementation REVGBPMoney

- (instancetype)initWithAmount:(NSDecimalNumber *)amount {
	self = [super init];
	if (self) {
		self.currency = [REVGBPCurrency new];
		self.amount = amount;
	}
	return self;
}

@end
