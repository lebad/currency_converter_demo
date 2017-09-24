//
//  REVConverterCoreService.h
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 17/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol REVConverterCoreServiceDelegate;

@interface REVConverterCoreService : NSObject

@property (nonatomic, strong) NSArray<REVMoney *> *moneyArray;
@property (nonatomic, assign) NSUInteger selectedIndex;

- (void)addDelegate:(id<REVConverterCoreServiceDelegate>)delegate;
- (void)removeObject:(id<REVConverterCoreServiceDelegate>)delegate;
- (void)calculateDeltaCurrency:(REVDeltaCurrency *)deltaCurrency;
- (void)calculateConvertedMoney:(REVMoney *)money;
- (void)start;
- (void)exchange;

@end


@protocol REVConverterCoreServiceDelegate <NSObject>
- (void)receiveMoneyArray:(NSArray<REVMoney *> *)moneyArray;
- (void)showAlertWithText:(NSString *)text;
- (void)showDirectRateText:(NSString *)text;
- (void)showInversRateText:(NSString *)text;
- (void)showCalculatedMoneyText:(NSString *)text;
- (void)showFromMoneyBalanceText:(NSString *)text;
- (void)showToMoneyBalanceText:(NSString *)text;
- (void)showNotEnoughBalance;
@end
