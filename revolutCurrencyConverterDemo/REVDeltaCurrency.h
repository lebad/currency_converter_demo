//
//  REVDeltaCurrency.h
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REVDeltaCurrency : NSObject

@property (nonatomic, strong) REVCurrency *fromCurrency;
@property (nonatomic, strong) REVCurrency *toCurrency;

@end
