//
//  REVCurrencyXMLParser.h
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 10/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "REVExchangeCurrencyAPIServiceProtocol.h"

@interface REVCurrencyXMLParser : NSObject

- (void)parseXMLData:(NSData *)XMLData completion:(REVExchangeCurrencyAPIServiceCompletion)completion;

@end
