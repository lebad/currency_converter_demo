//
//  REVCurrency.m
//  revolutCurrencyConverterDemo
//
//  Created by AndreyLebedev on 07/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVCurrency.h"

@implementation REVCurrency

- (BOOL)isEqual:(id)object {
	if (object == self)
		return YES;
	if (!object || ![object isMemberOfClass:[self class]])
		return NO;
	return [self isEqualToCurrency:object];
}

- (BOOL)isEqualToCurrency:(REVCurrency *)currency {
	if (self == currency)
		return YES;
	if (![self.code isEqualToString:currency.code])
		return NO;
	if (![self.name isEqualToString:currency.name])
		return NO;
	return YES;
}

@end
