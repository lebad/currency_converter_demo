//
//  REVEURCurrency.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVEURCurrency.h"

@implementation REVEURCurrency

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.sign = @"€";
		self.code = @"EUR";
		self.name = @"Euro";
	}
	return self;
}

@end
