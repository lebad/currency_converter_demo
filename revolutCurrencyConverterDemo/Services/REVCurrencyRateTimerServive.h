//
//  REVCurrencyRateTimerServive.h
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 16/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REVCurrencyRateTimerServive : NSObject <REVCurrencyRateServiceProtocol>

@property (nonatomic, strong) id<REVCurrencyRateServiceProtocol> rateService;
+ (instancetype)shared;
- (void)cancel;

@end
