//
//  REVConverterCoreService.h
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 17/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol REVConverterCoreServiceDelegate;

@interface REVConverterCoreService : NSObject

@property (nonatomic, weak) id<REVConverterCoreServiceDelegate> delegate;

- (void)start;

@end


@protocol REVConverterCoreServiceDelegate <NSObject>
- (void)receiveMoneyArray:(NSArray<REVMoney *> *)moneyArray;
@end
