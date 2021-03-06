//
//  NSDecimalNumber+Currency.h
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (Currency)

- (NSDecimalNumber *)currencyDecimalNumberByRate:(NSDecimalNumber *)rate;
- (NSDecimalNumber *)currencyDecimalNumberByAddingBy:(NSDecimalNumber *)number;
- (NSDecimalNumber *)currencyDecimalNumberBySubtractingBy:(NSDecimalNumber *)number;
- (NSDecimalNumber *)currencyDecimalNumberByDividingBy:(NSDecimalNumber *)number;
- (NSString *)stringForNumberWithCurrencyStyle;
- (NSString *)stringForNumberWithRateStyle;

@end
