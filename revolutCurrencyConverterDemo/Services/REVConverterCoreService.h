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

- (void)addDelegate:(id<REVConverterCoreServiceDelegate>)delegate;
- (void)removeObject:(id<REVConverterCoreServiceDelegate>)delegate;
- (void)setDeltaCurrency:(REVDeltaCurrency *)deltaCurrency;
- (void)start;

@end


@protocol REVConverterCoreServiceDelegate <NSObject>
- (void)receiveMoneyArray:(NSArray<REVMoney *> *)moneyArray;
- (void)showAlertWithText:(NSString *)text;
- (void)showDirectRateText:(NSString *)text;
- (void)showInversRateText:(NSString *)text;
@end
