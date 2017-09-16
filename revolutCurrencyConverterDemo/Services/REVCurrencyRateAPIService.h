//
//  REVCurrencyRateAPIService.h
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 16/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class REVRate;

typedef void(^REVCurrencyRateAPIServiceCompletion)(NSArray<REVRate *> *rates, NSError *error);

@interface REVCurrencyRateAPIService : NSObject

- (void)getRatesWithCompletion:(REVCurrencyRateAPIServiceCompletion)completion;

@end
