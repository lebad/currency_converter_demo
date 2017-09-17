//
//  REVRate.h
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 16/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REVRate : NSObject

@property (nonatomic, strong) REVDeltaCurrency *deltaCurrency;
@property (nonatomic, strong) NSDecimalNumber *rate;

@end
