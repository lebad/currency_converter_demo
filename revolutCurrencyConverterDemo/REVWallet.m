//
//  REVWallet.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVWallet.h"

@interface REVWallet ()

@property (nonatomic, strong) NSDictionary<NSString *, REVMoney *> *walletDictionary;
@property (nonatomic, weak) id<REVRateServiceProtocol> rateService;

@end

@implementation REVWallet

- (instancetype)initWithMoneyArray:(NSArray<REVMoney *> *)moneyArray
			   currencyRateService:(id<REVRateServiceProtocol>)rateService {
	self = [super init];
	if (self) {
		NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithCapacity:moneyArray.count];
		for (REVMoney *money in moneyArray) {
			mutDict[money.currency.code] = money;
		}
		_walletDictionary = [mutDict copy];
		_rateService = rateService;
	}
	return self;
}

- (REVMoney *)calculateRequest:(REVRequestMoney *)request {
	REVDeltaCurrency *deltaCurrency = [REVDeltaCurrency new];
	deltaCurrency.fromCurrency = request.removedMoney.currency;
	deltaCurrency.toCurrency = request.targetCurrency;
	NSDecimalNumber *rate = [self.rateService currencyRateForDelta:deltaCurrency];
	NSDecimalNumber *moneyAmount = [request.removedMoney.amount currencyDecimalNumberByRate:rate];
	REVMoney *calculatedMoney = [REVMoney moneyCurrency:request.targetCurrency amount:moneyAmount];
	return calculatedMoney;
}

@end
