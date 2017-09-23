//
//  REVConverterCoreService.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 17/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVConverterCoreService.h"
#import "REVReachabilityService.h"
#import "REVCurrencyRateTimerServive.h"
#import "REVRateConverter.h"

@interface REVConverterCoreService ()

@property (nonatomic, strong) REVWallet *wallet;
@property (nonatomic, strong) REVReachabilityService *reachabilityService;
@property (nonatomic, strong) NSArray<REVMoney *> *moneyArray;

@property (nonatomic, strong) NSHashTable<id<REVConverterCoreServiceDelegate> > *delegates;
@property (nonatomic, strong) REVDeltaCurrency *directDeltaCurrency;
@property (nonatomic, strong) REVMoney *convertedMoney;
@property (nonatomic, strong) REVRateConverter *rateConverter;

@end

@implementation REVConverterCoreService

- (instancetype)init
{
	self = [super init];
	if (self) {
		_reachabilityService = [[REVReachabilityService alloc] init];
		_delegates = [NSHashTable weakObjectsHashTable];
	}
	return self;
}

- (void)addDelegate:(id<REVConverterCoreServiceDelegate>)delegate {
	[self.delegates addObject:delegate];
}

- (void)removeObject:(id<REVConverterCoreServiceDelegate>)delegate {
	[self.delegates removeObject:delegate];
}

- (void)calculateDeltaCurrency:(REVDeltaCurrency *)deltaCurrency {
	self.directDeltaCurrency = deltaCurrency;
	
	[self calculateRateAndShow];
}

- (void)calculateConvertedMoney:(REVMoney *)money {
	self.convertedMoney = money;
	
	[self calculateWalletAndShow];
}

- (void)resignCalculatedMoney {
	self.convertedMoney = nil;
}

- (void)start {
	[self receiveMoney];
	
	[self checkReachabilityAndDoSomething];
}

- (void)receiveMoney {
	NSDecimalNumber *amountMoney = [NSDecimalNumber decimalNumberWithString:@"100.00"];
	NSArray<REVMoney *> *moneyArray = @[
										[REVUSDMoney moneyAmount:amountMoney],
										[REVEURMoney moneyAmount:amountMoney],
										[REVGBPMoney moneyAmount:amountMoney]
										];
	self.moneyArray = moneyArray;
	for (id<REVConverterCoreServiceDelegate> delegate in self.delegates.allObjects) {
		[delegate receiveMoneyArray:self.moneyArray];
	}
}

- (void)checkReachabilityAndDoSomething {
	[self.reachabilityService checkReachability:^(BOOL isReachable) {
		if (isReachable) {
			[self getRemoteRate];
		} else {
			[self showNotReachableAlert];
		}
	}];
}

- (void)getRemoteRate {
	[[REVCurrencyRateTimerServive shared] getRatesWithCompletion:^(NSArray<REVRate *> *rates, NSError *error) {
		if (error) {
			[self showAlertWithText:@"The error occured while receiving data"];
		} else {
			self.rateConverter = [[REVRateConverter alloc] initWithRates:rates];
			[self calculateRateAndShow];
			self.wallet = [[REVWallet alloc] initWithMoneyArray:self.moneyArray
											currencyRateService:self.rateConverter];
			[self calculateWalletAndShow];
		}
	}];
}

- (void)calculateWalletAndShow {
	if (!self.wallet || !self.rateConverter || !self.directDeltaCurrency || !self.convertedMoney) {
		return;
	}
	if (!self.convertedMoney) {
		for (id<REVConverterCoreServiceDelegate> delegate in self.delegates.allObjects) {
			[delegate showCalculatedMoneyText:@""];
		}
	}
	
	REVRequestMoney *request = [REVRequestMoney requestWith:self.convertedMoney targetCurrency:self.directDeltaCurrency.toCurrency];
	REVMoney *money = [self.wallet calculateRequest:request];
	NSString *moneyText = [NSString stringWithFormat:@"+%@", [money.amount stringForNumberWithCurrencyStyle]];
	for (id<REVConverterCoreServiceDelegate> delegate in self.delegates.allObjects) {
		[delegate showCalculatedMoneyText:moneyText];
	}
}

- (void)calculateRateAndShow {
	if (!self.rateConverter || !self.directDeltaCurrency) {
		return;
	}
	
	REVRate *directRate = [self.rateConverter calculateRateForDelta:self.directDeltaCurrency];
	NSString *directRectString = [directRate.rate stringForNumberWithRateStyle];
	NSString *directRectStringToShow = [NSString stringWithFormat:@"%@1=%@%@",
									   self.directDeltaCurrency.fromCurrency.sign,
									   self.directDeltaCurrency.toCurrency.sign,
									   directRectString];
	REVDeltaCurrency *inverseCurrency = [self.directDeltaCurrency inverseDelta];
	REVRate *inverseRate = [self.rateConverter calculateRateForDelta:inverseCurrency];
	NSString *inverseString = [inverseRate.rate stringForNumberWithRateStyle];
	NSString *inverseRectStringToShow = [NSString stringWithFormat:@"%@1=%@%@",
										self.directDeltaCurrency.toCurrency.sign,
										 self.directDeltaCurrency.fromCurrency.sign,
										inverseString];
	
	for (id<REVConverterCoreServiceDelegate> delegate in self.delegates.allObjects) {
		[delegate showDirectRateText:directRectStringToShow];
		[delegate showInversRateText:inverseRectStringToShow];
	}
	
	NSLog(@"Show Rate!");
}

- (void)showNotReachableAlert {
	if (!self.rateConverter) {
		[self showAlertWithText:@"We don't have rate data."];
	} else {
		[self showAlertWithText:@"We have insufficient rate. Be carefull."];
	}
}

- (void)showAlertWithText:(NSString *)text {
	for (id<REVConverterCoreServiceDelegate> delegate in self.delegates.allObjects) {
		[delegate showAlertWithText:text];
	}
}

@end
