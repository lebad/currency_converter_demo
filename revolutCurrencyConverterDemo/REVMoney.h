//
//  REVMoney.h
//  revolutCurrencyConverterDemo
//
//  Created by AndreyLebedev on 07/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class REVCurrency;

@interface REVMoney : NSObject

@property (nonatomic, strong) REVCurrency *currency;
@property (nonatomic, strong) NSDecimalNumber *amount;

@end
