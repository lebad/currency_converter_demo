//
//  REVGBPCurrency.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVGBPCurrency.h"

@implementation REVGBPCurrency

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.sign = @"£";
		self.code = @"GBP";
		self.name = @"British pound";
	}
	return self;
}

@end
