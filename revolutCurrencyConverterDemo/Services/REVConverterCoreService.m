//
//  REVConverterCoreService.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 17/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVConverterCoreService.h"

@interface REVConverterCoreService ()

@property (nonatomic, strong) NSHashTable<id<REVConverterCoreServiceDelegate> > *delegates;
@property (nonatomic, strong) REVMoney *selectedMoney;

@end

@implementation REVConverterCoreService

- (instancetype)init
{
	self = [super init];
	if (self) {
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
	NSDecimalNumber *amountMoney = [NSDecimalNumber decimalNumberWithString:@"100.00"];
	NSArray<REVMoney *> *moneyArray = @[
										[REVUSDMoney moneyAmount:amountMoney],
										[REVEURMoney moneyAmount:amountMoney],
										[REVGBPMoney moneyAmount:amountMoney]
										];
	for (id<REVConverterCoreServiceDelegate> delegate in self.delegates.allObjects) {
		[delegate receiveMoneyArray:moneyArray];
	}
}

@end
