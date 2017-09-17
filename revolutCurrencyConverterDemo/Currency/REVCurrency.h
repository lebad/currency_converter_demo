//
//  REVCurrency.h
//  revolutCurrencyConverterDemo
//
//  Created by AndreyLebedev on 07/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REVCurrency : NSObject

@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;

+ (instancetype)currencyWithCode:(NSString *)code;

- (BOOL)isEqualToCurrency:(REVCurrency *)currency;

@end
