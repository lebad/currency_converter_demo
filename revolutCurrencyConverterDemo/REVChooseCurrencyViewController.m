//
//  REVChooseCurrencyViewController.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 16/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVChooseCurrencyViewController.h"
#import "REVCurrencyRateAPIService.h"

@interface REVChooseCurrencyViewController ()

@property (nonatomic, strong) REVCurrencyRateAPIService *APIAervice;

@end

@implementation REVChooseCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.APIAervice = [REVCurrencyRateAPIService new];
	[self.APIAervice getRatesWithCompletion:^(NSArray<REVRate *> *rates, NSError *error) {
		
	}];
}

@end
