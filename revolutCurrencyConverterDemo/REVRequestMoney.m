//
//  REVDeltaMoney.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVRequestMoney.h"

@implementation REVRequestMoney

+ (instancetype)requestWith:(REVMoney *)removedMoney targetCurrency:(REVCurrency *)targetCarrency {
	return [[self alloc] initWithRemovedMoney:removedMoney targetCurrency:targetCarrency];
}

- (instancetype)initWithRemovedMoney:(REVMoney *)removedMoney targetCurrency:(REVCurrency *)targetCarrency {
	self = [super init];
	if (self) {
		_removedMoney = removedMoney;
		_targetCurrency = targetCarrency;
	}
	return self;
}

@end
