//
//  REVCurrencyConverter.h
//  revolutCurrencyConverterDemo
//
//  Created by AndreyLebedev on 07/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "REVRateServiceProtocol.h"

@class REVMoney;

@protocol REVCurrencyConverterReceiver <NSObject>
- (void)receiveConvertedMoney:(REVMoney *)money;
@end

@interface REVCurrencyConverter : NSObject

@property (nonatomic, weak) id<REVCurrencyConverterReceiver> receiver;
- (void)convertMoney:(REVMoney *)money;

@end
