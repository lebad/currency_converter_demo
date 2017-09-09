//
//  REVRateServiceProtocol.h
//  revolutCurrencyConverterDemo
//
//  Created by AndreyLebedev on 07/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class REVDeltaCurrency;

@protocol REVRateServiceProtocol <NSObject>
- (NSDecimalNumber *)currencyRateForDelta:(REVDeltaCurrency *)delta;
@end
