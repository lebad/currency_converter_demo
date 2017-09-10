//
//  REVWallet.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVWallet.h"

NSString *const REVWalletErrorDomain = @"com.revolutcurrencyconverterdemo.wallet";

@interface REVWallet ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, REVMoney *> *walletDictionary;
@property (nonatomic, weak) id<REVRateServiceProtocol> rateService;

@property (nonatomic, strong) REVRequestMoney *currentRequestMoney;
@property (nonatomic, strong) REVMoney *calculatedMoney;
@property (nonatomic, strong) NSDecimalNumber *moneyAfterSubtracting;

@end

@implementation REVWallet

- (instancetype)initWithMoneyArray:(NSArray<REVMoney *> *)moneyArray
			   currencyRateService:(id<REVRateServiceProtocol>)rateService {
	self = [super init];
	if (self) {
		_walletDictionary = [NSMutableDictionary dictionaryWithCapacity:moneyArray.count];
		for (REVMoney *money in moneyArray) {
			_walletDictionary[money.currency.code] = money;
		}
		_rateService = rateService;
	}
	return self;
}

- (REVMoney *)calculateRequest:(REVRequestMoney *)request {
	self.currentRequestMoney = request;
	[self calculateRequest];
	if ([self isNotEnoughMoney:self.currentRequestMoney.removedMoney]) {
		[self sendError];
	}
	return self.calculatedMoney;
}

- (REVMoney *)moneyForCurrency:(REVCurrency *)currency {
	return self.walletDictionary[currency.code];
}

- (void)exchangeLastCalculating {
	if ([self isNotEnoughMoney:self.currentRequestMoney.removedMoney]) {
		return;
	}
	[self substractMoney:self.currentRequestMoney.removedMoney];
	[self substractMoney:self.calculatedMoney];
}

#pragma mark - Private

- (void)calculateRequest {
	REVDeltaCurrency *deltaCurrency = [REVDeltaCurrency new];
	deltaCurrency.fromCurrency = self.currentRequestMoney.removedMoney.currency;
	deltaCurrency.toCurrency = self.currentRequestMoney.targetCurrency;
	NSDecimalNumber *rate = [self.rateService currencyRateForDelta:deltaCurrency];
	NSDecimalNumber *moneyAmount = [self.currentRequestMoney.removedMoney.amount currencyDecimalNumberByRate:rate];
	self.calculatedMoney = [REVMoney moneyCurrency:self.currentRequestMoney.targetCurrency amount:moneyAmount];
}

- (BOOL)isNotEnoughMoney:(REVMoney *)money {
	REVMoney *currentMoneyInWallet = self.walletDictionary[money.currency.code];
	self.moneyAfterSubtracting = [currentMoneyInWallet.amount currencyDecimalNumberBySubtractingBy:money.amount];
	return self.moneyAfterSubtracting.integerValue < 0;
}

- (void)sendError {
	NSError *error = [NSError errorWithDomain:REVWalletErrorDomain
								code:REVWalletErrorCodeNotEnoughMoney
							userInfo:nil];
	[self.delegate errorOccurred:error];
}

- (void)substractMoney:(REVMoney *)money {
	REVMoney *currentMoneyInWallet = self.walletDictionary[money.currency.code];
	NSDecimalNumber *newAmount = [currentMoneyInWallet.amount currencyDecimalNumberBySubtractingBy:money.amount];
	REVMoney *moneyAfterRemoving = [[currentMoneyInWallet class] moneyAmount:newAmount];
	self.walletDictionary[money.currency.code] = moneyAfterRemoving;
}

@end
