//
//  REVExchangeCurrencyAPIServiceProtocol.h
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 10/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^REVExchangeCurrencyAPIServiceCompletion)(NSDecimalNumber *rate, NSError *error);

@protocol REVExchangeCurrencyAPIServiceProtocol <NSObject>

- (void)retrieveRateDataForCurrency:(REVCurrency *)currency completion:(REVExchangeCurrencyAPIServiceCompletion)completion;

@end
