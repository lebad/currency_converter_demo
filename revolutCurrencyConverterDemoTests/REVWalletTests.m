//
//  REVWalletTests.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "REVRateServiceProtocol.h"

@interface REVCurrencyRateServiceStub: NSObject <REVRateServiceProtocol>
@property (nonatomic, strong) NSDecimalNumber *currentRate;
@end
@implementation REVCurrencyRateServiceStub
- (NSDecimalNumber *)currencyRateForDelta:(REVDeltaCurrency *)delta {
	return self.currentRate;
}
@end

@interface REVWalletTests : XCTestCase

@property (nonatomic, strong) REVWallet *wallet;
@property (nonatomic, strong) REVCurrencyRateServiceStub *rateServiceStub;

@end

@implementation REVWalletTests

- (void)setUp {
    [super setUp];
	NSDecimalNumber *amountMoney = [NSDecimalNumber decimalNumberWithString:@"100.00"];
	NSArray<REVMoney *> *moneyArray = @[
									   [REVUSDMoney moneyAmount:amountMoney],
									   [REVUSDMoney moneyAmount:amountMoney],
									   [REVGBPMoney moneyAmount:amountMoney]
									  ];
	self.rateServiceStub = [REVCurrencyRateServiceStub new];
	self.wallet = [[REVWallet alloc] initWithMoneyArray:moneyArray currencyRateService:self.rateServiceStub];
}

- (void)tearDown {
	self.wallet = nil;
	self.rateServiceStub = nil;
    [super tearDown];
}

- (void)testCalculateRequestMoneyWithDifferentMoney {
	self.rateServiceStub.currentRate = [NSDecimalNumber decimalNumberWithString:@"1.32"];
	REVRequestMoney *requestMoney = [REVRequestMoney requestWith:[REVGBPMoney moneyAmountString:@"50"]
												  targetCurrency:[REVUSDCurrency new]];
	REVMoney *money = [self.wallet calculateRequest:requestMoney];
	XCTAssertEqualObjects(money, [REVUSDMoney moneyAmountString:@"66"]);
	
	self.rateServiceStub.currentRate = [NSDecimalNumber decimalNumberWithString:@"0.91268"];
	requestMoney = [REVRequestMoney requestWith:[REVEURMoney moneyAmountString:@"12.45"]
								 targetCurrency:[REVGBPCurrency new]];
	money = [self.wallet calculateRequest:requestMoney];
	XCTAssertEqualObjects(money, [REVGBPMoney moneyAmountString:@"11.36"]);
	
	self.rateServiceStub.currentRate = [NSDecimalNumber decimalNumberWithString:@"0.830856"];
	requestMoney = [REVRequestMoney requestWith:[REVUSDMoney moneyAmountString:@"1327367.23"]
								 targetCurrency:[REVEURCurrency new]];
	money = [self.wallet calculateRequest:requestMoney];
	XCTAssertEqualObjects(money, [REVEURMoney moneyAmountString:@"1102851.03"]);
}

#pragma mark - Helpers

@end
