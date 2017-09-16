//
//  REVRatesDownloader.h
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 16/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REVRatesDownloader : NSOperation

@property (nonatomic, strong) id<REVCurrencyRateServiceProtocol> rateService;
@property (nonatomic, strong) NSArray<REVRate *> *rates;
@property (nonatomic, strong) NSError *error;

@end
