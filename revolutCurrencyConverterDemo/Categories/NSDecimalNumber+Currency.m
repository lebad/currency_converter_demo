//
//  NSDecimalNumber+Currency.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "NSDecimalNumber+Currency.h"

@implementation NSDecimalNumber (Currency)

- (NSDecimalNumber *)currencyDecimalNumberBySubtractingBy:(NSDecimalNumber *)number {
	NSDecimalNumberHandler *roundUpHandler = [self roundHandler];
	NSDecimalNumber *moneyAmount = [self decimalNumberBySubtracting:number
													  withBehavior:roundUpHandler];
	return moneyAmount;
}

- (NSDecimalNumber *)currencyDecimalNumberByDividingBy:(NSDecimalNumber *)number {
	NSDecimalNumberHandler *roundUpHandler = [self roundHandler];
	NSDecimalNumber *moneyAmount = [self decimalNumberByDividingBy:number
													  withBehavior:roundUpHandler];
	return moneyAmount;
}

- (NSDecimalNumber *)currencyDecimalNumberByRate:(NSDecimalNumber *)rate {
	NSDecimalNumberHandler *roundUpHandler = [self roundHandler];
	NSDecimalNumber *moneyAmount = [self decimalNumberByMultiplyingBy:rate
														 withBehavior:roundUpHandler];
	return moneyAmount;
}

- (NSDecimalNumberHandler *)roundHandler {
	NSDecimalNumberHandler *roundUpHandler =
	[NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
														   scale:2
												raiseOnExactness:NO
												 raiseOnOverflow:NO
												raiseOnUnderflow:NO
											 raiseOnDivideByZero:YES];
	return roundUpHandler;
}

- (NSString *)stringForNumberWithCurrencyStyle {
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	numberFormatter.alwaysShowsDecimalSeparator = YES;
	numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
	numberFormatter.maximumFractionDigits = 2;
	numberFormatter.minimumFractionDigits = 2;
	
	return [numberFormatter stringFromNumber:self];
}

- (NSString *)stringForNumberWithRateStyle {
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	numberFormatter.alwaysShowsDecimalSeparator = YES;
	numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
	numberFormatter.maximumFractionDigits = 4;
	numberFormatter.minimumFractionDigits = 4;
	
	return [numberFormatter stringFromNumber:self];
}

@end
