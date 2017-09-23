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

@property (nonatomic, strong) NSHashTable<id<REVConverterCoreServiceDelegate> > *delegates;
@property (nonatomic, strong) REVMoney *selectedMoney;
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

- (void)didSelectMoney:(REVMoney *)money {
	self.selectedMoney = money;
}

- (void)start {
	[self receiveMoney];
	
	[self checkReachabilityAndDoSomething];
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
		}
	}];
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

- (void)receiveMoney {
	NSDecimalNumber *amountMoney = [NSDecimalNumber decimalNumberWithString:@"100.00"];
	NSArray<REVMoney *> *moneyArray = @[
										[REVUSDMoney moneyAmount:amountMoney],
										[REVEURMoney moneyAmount:amountMoney],
										[REVGBPMoney moneyAmount:amountMoney]
										];
	self.wallet = [[REVWallet alloc] initWithMoneyArray:moneyArray
									currencyRateService:nil];
	for (id<REVConverterCoreServiceDelegate> delegate in self.delegates.allObjects) {
		[delegate receiveMoneyArray:moneyArray];
	}
}

@end
