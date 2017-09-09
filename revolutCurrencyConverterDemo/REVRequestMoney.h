//
//  REVDeltaMoney.h
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REVRequestMoney : NSObject

@property (nonatomic, readonly, strong) REVMoney *removedMoney;
@property (nonatomic, readonly, strong) REVCurrency *targetCurrency;

+ (instancetype)requestWith:(REVMoney *)removedMoney targetCurrency:(REVCurrency *)targetCarrency;
- (instancetype)initWithRemovedMoney:(REVMoney *)removedMoney targetCurrency:(REVCurrency *)targetCarrency;

@end
