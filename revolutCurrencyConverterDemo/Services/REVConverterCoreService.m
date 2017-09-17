//
//  REVConverterCoreService.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 17/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVConverterCoreService.h"

@implementation REVConverterCoreService

- (void)start {
	NSDecimalNumber *amountMoney = [NSDecimalNumber decimalNumberWithString:@"100.00"];
	NSArray<REVMoney *> *moneyArray = @[
										[REVUSDMoney moneyAmount:amountMoney],
										[REVEURMoney moneyAmount:amountMoney],
										[REVGBPMoney moneyAmount:amountMoney]
										];
	[self.delegate receiveMoneyArray:moneyArray];
}

@end
