//
//  REVMoney.h
//  revolutCurrencyConverterDemo
//
//  Created by AndreyLebedev on 07/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class REVCurrency;

@interface REVMoney : NSObject

@property (nonatomic, strong) REVCurrency *currency;
@property (nonatomic, strong) NSDecimalNumber *amount;

+ (instancetype)moneyCurrency:(REVCurrency *)currency amountString:(NSString *)amountString;
+ (instancetype)moneyCurrency:(REVCurrency *)currency amount:(NSDecimalNumber *)amount;
+ (instancetype)moneyAmountString:(NSString *)amountString;
+ (instancetype)moneyAmount:(NSDecimalNumber *)amount;
- (instancetype)initWithAmount:(NSDecimalNumber *)amount;

- (BOOL)isEqualToMoney:(REVMoney *)money;

@end
