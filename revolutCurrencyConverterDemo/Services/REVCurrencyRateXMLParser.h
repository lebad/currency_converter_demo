//
//  REVCurrencyRateXMLParser.h
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 16/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "REVCurrencyRateAPIService.h"

@interface REVCurrencyRateXMLParser : NSObject

- (void)parseData:(NSData *)data withCompletion:(REVCurrencyRateAPIServiceCompletion)completion;

@end
