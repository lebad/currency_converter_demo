//
//  REVEURMoney.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVEURMoney.h"

@implementation REVEURMoney

- (instancetype)initWithAmount:(NSDecimalNumber *)amount {
	self = [super init];
	if (self) {
		self.currency = [REVEURCurrency new];
		self.amount = amount;
	}
	return self;
}

@end
