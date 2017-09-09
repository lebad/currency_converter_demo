//
//  REVWallet.h
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "REVRateServiceProtocol.h"

@class REVMoney, REVRequestMoney;

@interface REVWallet : NSObject

- (instancetype)initWithMoneyArray:(NSArray<REVMoney *> *)moneyArray
			   currencyRateService:(id<REVRateServiceProtocol>)rateService;
- (REVMoney *)calculateRequest:(REVRequestMoney *)request;

@end
