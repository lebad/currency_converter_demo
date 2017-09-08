//
//  REVCurrencyConverterTests.m
//  revolutCurrencyConverterDemo
//
//  Created by AndreyLebedev on 07/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "REVCurrencyConverter.h"
#import "REVMoney.h"
#import "REVCurrency.h"

@interface REVCurrencyConverterReceiverMock: NSObject <REVCurrencyConverterReceiver>
@property (nonatomic, strong) REVMoney *receivedMoney;
@end
@implementation REVCurrencyConverterReceiverMock

- (void)receiveConvertedMoney:(REVMoney *)money {
	self.receivedMoney = money;
}
@end

@interface REVRateServiceStub: NSObject <REVRateServiceProtocol>
@property (nonatomic, strong) NSDecimalNumber *currentRate;
@end
@implementation REVRateServiceStub
- (void)requestCurrentRateForCurrency:(REVCurrency *)currency {
	
}
- (NSDecimalNumber *)receiveCurrentRate {
	return self.currentRate;
}
@end

@interface REVCurrencyConverterTests : XCTestCase

@property (nonatomic, strong) REVCurrencyConverter *currencyConverter;
@property (nonatomic, strong) REVCurrencyConverterReceiverMock *receiverMock;

@end

@implementation REVCurrencyConverterTests

- (void)setUp {
    [super setUp];
	self.currencyConverter = [REVCurrencyConverter new];
	self.receiverMock = [REVCurrencyConverterReceiverMock new];
	self.currencyConverter.receiver = self.receiverMock;
}

- (void)tearDown {
	self.currencyConverter = nil;
	self.receiverMock = nil;
    [super tearDown];
}

- (void)testConvertMoney {
	REVMoney *money = [REVMoney new];
	REVCurrency *currency = [REVCurrency new];
	currency.type = REVCurrencyTypeUSD;
	currency.code = @"USD";
	currency.name = @"American Dollar";
	money.currency = currency;
	money.amount = [NSDecimalNumber decimalNumberWithString:@"54.78"];
	
	REVRateServiceStub *rateServiceStub = [REVRateServiceStub new];
	rateServiceStub.currentRate = [NSDecimalNumber decimalNumberWithString:@""];
	
	
	[self.currencyConverter convertMoney:money];
	
	XCTAssertEqual(<#expression1#>, <#expression2, ...#>)
}

@end
