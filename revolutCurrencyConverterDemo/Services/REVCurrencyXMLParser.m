//
//  REVCurrencyXMLParser.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 10/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVCurrencyXMLParser.h"

@interface REVCurrencyXMLParser () <NSXMLParserDelegate>

@property (nonatomic, strong) REVExchangeCurrencyAPIServiceCompletion completion;

@property (nonatomic, strong) NSXMLParser *XMLParser;
@property (nonatomic, strong) NSMutableArray *currencyArray;
@property (nonatomic, strong) NSMutableDictionary *dictTempDataStorage;
@property (nonatomic, strong) NSMutableString *foundValue;
@property (nonatomic, strong) NSString *currentElement;

@end

@implementation REVCurrencyXMLParser

- (instancetype)init
{
	self = [super init];
	if (self) {
		_foundValue = [NSMutableString string];
	}
	return self;
}

- (void)parseXMLData:(NSData *)XMLData completion:(REVExchangeCurrencyAPIServiceCompletion)completion {
	if (!completion || !XMLData) {
		return;
	}
	self.completion = completion;
	
	self.XMLParser = [[NSXMLParser alloc] initWithData:XMLData];
	self.XMLParser.delegate = self;
	[self.XMLParser parse];
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	self.currencyArray = [NSMutableArray array];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	self.currencyArray = nil;
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
		
	}
}

@end
