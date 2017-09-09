//
//  REVMoney.m
//  revolutCurrencyConverterDemo
//
//  Created by AndreyLebedev on 07/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVMoney.h"

@implementation REVMoney

+ (instancetype)moneyCurrency:(REVCurrency *)currency amountString:(NSString *)amountString {
	NSDecimalNumber *amountNumber = [NSDecimalNumber decimalNumberWithString:amountString];
	return [self moneyCurrency:currency amount:amountNumber];
}

+ (instancetype)moneyCurrency:(REVCurrency *)currency amount:(NSDecimalNumber *)amount {
	if ([currency isMemberOfClass:[REVUSDCurrency class]])
		return [REVUSDMoney moneyAmount:amount];
	if ([currency isMemberOfClass:[REVEURCurrency class]])
		return [REVEURMoney moneyAmount:amount];
	if ([currency isMemberOfClass:[REVGBPCurrency class]])
		return [REVGBPMoney moneyAmount:amount];
	return [self moneyAmount:amount];
}

+ (instancetype)moneyAmountString:(NSString *)amountString {
	NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:amountString];
	return [self moneyAmount:amountDecimal];
}

+ (instancetype)moneyAmount:(NSDecimalNumber *)amount {
	return [[self alloc] initWithAmount:amount];
}

- (instancetype)initWithAmount:(NSDecimalNumber *)amount {
	self = [super init];
	if (self) {
		_currency = [REVCurrency new];
		_amount = amount;
	}
	return self;
}

- (BOOL)isEqual:(id)object {
	if (object == self)
		return YES;
	if (!object || ![object isMemberOfClass:[self class]])
		return NO;
	return [self isEqualToMoney:object];
}

- (BOOL)isEqualToMoney:(REVMoney *)money {
	if (self == money)
		return YES;
	if (![self.currency isEqual:money.currency])
		return NO;
	if ([self.amount compare:money.amount] != NSOrderedSame)
		return NO;
	return YES;
}

@end
