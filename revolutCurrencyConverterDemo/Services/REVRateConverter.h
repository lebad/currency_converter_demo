//
//  REVRateConverter.h
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 23/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REVRateConverter : NSObject <REVRateServiceProtocol>

- (instancetype)initWithRates:(NSArray<REVRate *> *)rates;
- (REVRate *)calculateRateForDelta:(REVDeltaCurrency *)delta;

@end
