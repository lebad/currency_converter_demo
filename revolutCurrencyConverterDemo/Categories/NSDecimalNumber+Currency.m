//
//  NSDecimalNumber+Currency.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "NSDecimalNumber+Currency.h"

@implementation NSDecimalNumber (Currency)

- (NSDecimalNumber *)currencyDecimalNumberByRate:(NSDecimalNumber *)rate {
	NSDecimalNumberHandler *roundUpHandler =
	[NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
														   scale:2
												raiseOnExactness:NO
												 raiseOnOverflow:NO
												raiseOnUnderflow:NO
											 raiseOnDivideByZero:YES];
	NSDecimalNumber *moneyAmount = [self decimalNumberByMultiplyingBy:rate
														 withBehavior:roundUpHandler];
	return moneyAmount;
}

@end
