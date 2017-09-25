//
//  REVExchaneViewController.h
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 17/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REVConverterCoreService.h"

@interface REVExchangeViewController : UIViewController
<REVConverterCoreServiceDelegateShowable, REVConverterCoreServiceDelegateAlertable>

@property (nonatomic, strong) REVConverterCoreService *coreService;

@end
