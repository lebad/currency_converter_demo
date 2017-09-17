//
//  REVCurrencyRateXMLParser.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 16/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVCurrencyRateXMLParser.h"

@interface REVCurrencyRateXMLParser () <NSXMLParserDelegate>

@property (nonatomic, strong) REVCurrencyRateAPIServiceCompletion completion;
@property (nonatomic, strong) NSXMLParser *XMLParser;
@property (nonatomic, strong) NSMutableArray<REVRate *> *rateArray;
@end

@implementation REVCurrencyRateXMLParser

- (void)parseData:(NSData *)data withCompletion:(REVCurrencyRateAPIServiceCompletion)completion {
	if (!completion) {
		return;
	}
	self.completion = completion;
	self.XMLParser = [[NSXMLParser alloc] initWithData:data];
	self.XMLParser.delegate = self;
	[self.XMLParser parse];
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	self.rateArray = [NSMutableArray array];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	if (self.rateArray.count == 0) {
		NSError *error = [NSError errorWithDomain:@"com.nodata"
											 code:0
										 userInfo:nil];
		self.completion(nil, error);
	} else {
		self.completion(self.rateArray, nil);
	}
	self.rateArray = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	self.completion(nil, parseError);
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(nullable NSString *)namespaceURI
 qualifiedName:(nullable NSString *)qName
	attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
	
	if ([elementName isEqualToString:@"Cube"]) {
		NSString *currencyName = attributeDict[@"currency"];
		NSString *rateValue = attributeDict[@"rate"];
		if (currencyName && rateValue) {
			if ([currencyName isEqualToString:@"USD"] || [currencyName isEqualToString:@"GBP"]) {
				REVCurrency *currency = [REVCurrency currencyWithCode:currencyName];
				REVDeltaCurrency *deltaCurrency = [REVDeltaCurrency new];
				deltaCurrency.fromCurrency = [REVEURCurrency new];
				deltaCurrency.toCurrency = currency;
				REVRate *rate = [REVRate new];
				rate.deltaCurrency = deltaCurrency;
				rate.rate = [NSDecimalNumber decimalNumberWithString:rateValue];
				[self.rateArray addObject:rate];
			}
		}
	}
}

@end
