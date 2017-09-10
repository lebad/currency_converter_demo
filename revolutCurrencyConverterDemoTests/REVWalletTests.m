//
//  REVWalletTests.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 09/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "REVRateServiceProtocol.h"

@interface REVWalletDelegateMock: NSObject <REVWalletDelegate>
@property (nonatomic, strong) NSError *error;
@end
@implementation REVWalletDelegateMock
- (void)errorOccurred:(NSError *)error {
	self.error = error;
}
@end

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
@property (nonatomic, strong) REVWalletDelegateMock *walletDelegateMock;

@end

@implementation REVWalletTests

- (void)setUp {
    [super setUp];
	NSDecimalNumber *amountMoney = [NSDecimalNumber decimalNumberWithString:@"100.00"];
	NSArray<REVMoney *> *moneyArray = @[
										[REVUSDMoney moneyAmount:amountMoney],
										[REVEURMoney moneyAmount:amountMoney],
										[REVGBPMoney moneyAmount:amountMoney]
										];
	self.rateServiceStub = [REVCurrencyRateServiceStub new];
	self.walletDelegateMock = [REVWalletDelegateMock new];
	self.wallet = [[REVWallet alloc] initWithMoneyArray:moneyArray currencyRateService:self.rateServiceStub];
	self.wallet.delegate = self.walletDelegateMock;
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
	XCTAssertNil(self.walletDelegateMock.error);
	
	self.rateServiceStub.currentRate = [NSDecimalNumber decimalNumberWithString:@"0.91268"];
	requestMoney = [REVRequestMoney requestWith:[REVEURMoney moneyAmountString:@"12.45"]
								 targetCurrency:[REVGBPCurrency new]];
	money = [self.wallet calculateRequest:requestMoney];
	XCTAssertEqualObjects(money, [REVGBPMoney moneyAmountString:@"11.36"]);
	XCTAssertNil(self.walletDelegateMock.error);
	
	self.rateServiceStub.currentRate = [NSDecimalNumber decimalNumberWithString:@"0.830856"];
	requestMoney = [REVRequestMoney requestWith:[REVUSDMoney moneyAmountString:@"1.23"]
								 targetCurrency:[REVEURCurrency new]];
	money = [self.wallet calculateRequest:requestMoney];
	XCTAssertEqualObjects(money, [REVEURMoney moneyAmountString:@"1.02"]);
	XCTAssertNil(self.walletDelegateMock.error);
}

- (void)testNotEnoughMoney {
	self.rateServiceStub.currentRate = [NSDecimalNumber decimalNumberWithString:@"0.830856"];
	REVRequestMoney *requestMoney = [REVRequestMoney requestWith:[REVUSDMoney moneyAmountString:@"1327367.23"]
												  targetCurrency:[REVEURCurrency new]];
	REVMoney *money = [self.wallet calculateRequest:requestMoney];
	XCTAssertEqualObjects(money, [REVEURMoney moneyAmountString:@"1102851.03"]);
	XCTAssertNotNil(self.walletDelegateMock.error);
}

- (void)testExchangeGBPMoneyToUSD {
	self.rateServiceStub.currentRate = [NSDecimalNumber decimalNumberWithString:@"1.32"];
	REVRequestMoney *requestMoney = [REVRequestMoney requestWith:[REVGBPMoney moneyAmountString:@"51"]
												  targetCurrency:[REVUSDCurrency new]];
	[self.wallet calculateRequest:requestMoney];
	[self.wallet exchangeLastCalculating];
	
	[self expectMoney:[REVGBPMoney moneyAmountString:@"49"]];
	[self expectMoney:[REVUSDMoney moneyAmountString:@"32.68"]];
}

- (void)testExchangeEURMoneyToGPP {
	self.rateServiceStub.currentRate = [NSDecimalNumber decimalNumberWithString:@"0.91268"];
	REVRequestMoney *requestMoney = [REVRequestMoney requestWith:[REVEURMoney moneyAmountString:@"12.45"]
												  targetCurrency:[REVGBPCurrency new]];
	[self.wallet calculateRequest:requestMoney];
	[self.wallet exchangeLastCalculating];
	
	[self expectMoney:[REVEURMoney moneyAmountString:@"87.55"]];
	[self expectMoney:[REVGBPMoney moneyAmountString:@"88.64"]];
}

- (void)testExchangeUSDMoneyToEUR {
	self.rateServiceStub.currentRate = [NSDecimalNumber decimalNumberWithString:@"0.83089"];
	REVRequestMoney *requestMoney = [REVRequestMoney requestWith:[REVEURMoney moneyAmountString:@"87.34"]
												  targetCurrency:[REVGBPCurrency new]];
	[self.wallet calculateRequest:requestMoney];
	[self.wallet exchangeLastCalculating];
	
	[self expectMoney:[REVEURMoney moneyAmountString:@"12.66"]];
	[self expectMoney:[REVGBPMoney moneyAmountString:@"27.43"]];
}

- (void)testExchangeToDoNothingBecauseNotEnoughMoneyAndNotSendErrorTwice {
	self.rateServiceStub.currentRate = [NSDecimalNumber decimalNumberWithString:@"0.830856"];
	REVRequestMoney *requestMoney = [REVRequestMoney requestWith:[REVUSDMoney moneyAmountString:@"1327367.23"]
												  targetCurrency:[REVEURCurrency new]];
	[self.wallet calculateRequest:requestMoney];
	self.walletDelegateMock.error = nil;
	[self.wallet exchangeLastCalculating];
	
	[self expectMoney:[REVUSDMoney moneyAmountString:@"100"]];
	[self expectMoney:[REVEURMoney moneyAmountString:@"100"]];
	XCTAssertNil(self.walletDelegateMock.error);
}

#pragma mark - Helpers

- (void)expectMoney:(REVMoney *)money {
	REVMoney *expectedMoneyInWallet = money;
	REVMoney *realMoneyInWallet = [self.wallet moneyForCurrency:expectedMoneyInWallet.currency];
	XCTAssertEqualObjects(expectedMoneyInWallet, realMoneyInWallet);
}

@end
