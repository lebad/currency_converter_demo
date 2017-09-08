//
//  REVRateServiceProtocol.h
//  revolutCurrencyConverterDemo
//
//  Created by AndreyLebedev on 07/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class REVCurrency;

@protocol REVRateServiceProtocol <NSObject>
- (void)requestCurrentRateForCurrency:(REVCurrency *)currency;
- (NSDecimalNumber *)receiveCurrentRate;
@end
