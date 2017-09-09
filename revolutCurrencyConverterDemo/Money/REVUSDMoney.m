//
//  REVUSDMoney.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVUSDMoney.h"

@implementation REVUSDMoney

- (instancetype)initWithAmount:(NSDecimalNumber *)amount {
	self = [super init];
	if (self) {
		self.currency = [REVUSDCurrency new];
		self.amount = amount;
	}
	return self;
}

@end
