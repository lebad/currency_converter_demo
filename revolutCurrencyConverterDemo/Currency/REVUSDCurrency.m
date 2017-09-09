//
//  REVUSDCurrency.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVUSDCurrency.h"

@implementation REVUSDCurrency

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.code = @"USD";
		self.name = @"American Dollar";
	}
	return self;
}

@end
