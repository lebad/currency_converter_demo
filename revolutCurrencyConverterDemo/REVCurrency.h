//
//  REVCurrency.h
//  revolutCurrencyConverterDemo
//
//  Created by AndreyLebedev on 07/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, REVCurrencyType) {
	REVCurrencyTypeUndefined = 0,
	REVCurrencyTypeEUR,
	REVCurrencyTypeUSD,
	REVCurrencyTypeGBP
};

@interface REVCurrency : NSObject

@property (nonatomic, assign) REVCurrencyType type;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;

@end
