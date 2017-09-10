//
//  REVWallet.h
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "REVRateServiceProtocol.h"

extern NSString *const REVWalletErrorDomain;

typedef NS_ENUM(NSUInteger, REVWalletErrorCode) {
	REVWalletErrorCodeUndefined = -1,
	REVWalletErrorCodeNotEnoughMoney = 0
};

@protocol REVWalletDelegate <NSObject>
- (void)errorOccurred:(NSError *)error;
@end

@class REVMoney, REVRequestMoney;

@interface REVWallet : NSObject

@property (nonatomic, weak) id<REVWalletDelegate> delegate;

- (instancetype)initWithMoneyArray:(NSArray<REVMoney *> *)moneyArray
			   currencyRateService:(id<REVRateServiceProtocol>)rateService;
- (REVMoney *)calculateRequest:(REVRequestMoney *)request;
- (REVMoney *)moneyForCurrency:(REVCurrency *)currency;
- (void)exchangeLastCalculating;

@end
