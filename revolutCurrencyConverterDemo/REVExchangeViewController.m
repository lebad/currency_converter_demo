//
//  REVExchaneViewController.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 17/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVExchangeViewController.h"
#import "REVCarouselScrollView.h"

static const CGFloat REVCurrencyLabelTop = 90.0;
static const CGFloat REVCurrencyLabelLeft = 30.0;
static const CGFloat REVCurrentMoneyLabelTop = 10.0;
static const CGFloat REVPageControllBottom = 30.0;
static const CGFloat REVPageControlHeight = 30.0;
static const CGFloat REVTextFieldLeft = 30.0;
static const CGFloat REVKeyBoardHeight = 216.0;

@interface REVExchangeViewController ()
<
REVCarouselScrollViewDataSource,
UITextFieldDelegate
>

@property (nonatomic, strong) REVCarouselScrollView *topCarouselView;
@property (nonatomic, strong) REVCarouselScrollView *bottomCarouselView;
@property (nonatomic, strong) UIPageControl *topPageControll;
@property (nonatomic, strong) UIPageControl *bottomPageControll;

@property (nonatomic, strong) NSMutableArray<UITextField *> *textFieldArray;
@property (nonatomic, strong) NSMutableArray<UILabel *> *textLabelArray;
@property (nonatomic, strong) NSMutableArray<UILabel *> *rateLabelArray;
@property (nonatomic, strong) NSMutableArray<UILabel *> *topWalletLabelArray;
@property (nonatomic, strong) NSMutableArray<UILabel *> *bottomWalletLabelArray;
@property (nonatomic, weak) UITextField *currentTextField;
@property (nonatomic, weak) UILabel *currentTextLabel;
@property (nonatomic, weak) UILabel *currentRateLabel;
@property (nonatomic, weak) UILabel *currentTopWalletLabel;
@property (nonatomic, weak) UILabel *currentBottomWalletLabel;

@property (nonatomic, strong) REVDeltaCurrency *deltaCurrency;

@end

@implementation REVExchangeViewController

- (void)dealloc
{
	[self.coreService removeObject:self];
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		_deltaCurrency = [REVDeltaCurrency new];
		_textFieldArray = [NSMutableArray new];
		_textLabelArray = [NSMutableArray new];
		_rateLabelArray = [NSMutableArray new];
		_topWalletLabelArray = [NSMutableArray new];
		_bottomWalletLabelArray = [NSMutableArray new];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self createExchageButton];
	[self createTopCarouselView];
	[self createBottomCarouselView];
	[self createTopPageControll];
	[self createBottomPageControll];
	
	[self.topCarouselView reloadData];
	[self.bottomCarouselView reloadData];
}

- (void)createExchageButton {
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Exchange"
																	style:UIBarButtonItemStylePlain
																   target:self
																   action:@selector(echangeAction:)];
	self.navigationItem.rightBarButtonItem = rightButton;
	self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)createTopCarouselView {
	self.topCarouselView = [[REVCarouselScrollView alloc] initWithFrame:CGRectZero];
	self.topCarouselView.dataSource = self;
	self.topCarouselView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
	[self.view addSubview:self.topCarouselView];
	
	id topLayoutGuide = self.topLayoutGuide;
	UIScrollView *scrollView = self.topCarouselView;
	CGFloat height = (CGRectGetHeight(self.view.bounds) - 64 - REVKeyBoardHeight)/2;
	NSArray *horConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"
												  options:0
												  metrics:nil
													views:NSDictionaryOfVariableBindings(scrollView)];
	NSArray *vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][scrollView(==height)]"
												   options:0
												   metrics:@{@"height": @(height)}
													 views:NSDictionaryOfVariableBindings(scrollView, topLayoutGuide)];
	[self.view addConstraints:horConstraints];
	[self.view addConstraints:vertConstraints];
	[self.topCarouselView layoutIfNeeded];
}

- (void)createBottomCarouselView {
	self.bottomCarouselView = [[REVCarouselScrollView alloc] initWithFrame:CGRectZero];
	self.bottomCarouselView.dataSource = self;
	self.bottomCarouselView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.15];
	[self.view addSubview:self.bottomCarouselView];
	
	UIScrollView *topScrollView = self.topCarouselView;
	UIScrollView *scrollView = self.bottomCarouselView;
	CGFloat height = (CGRectGetHeight(self.view.bounds) - 64 - REVKeyBoardHeight)/2;
	NSArray *horConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"
												  options:0
												  metrics:nil
													views:NSDictionaryOfVariableBindings(scrollView)];
	NSArray *vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topScrollView][scrollView(==height)]"
													   options:0
													   metrics:@{@"height": @(height)}
														 views:NSDictionaryOfVariableBindings(scrollView, topScrollView)];
	[self.view addConstraints:horConstraints];
	[self.view addConstraints:vertConstraints];
	[self.bottomCarouselView layoutIfNeeded];
}

- (void)createTopPageControll {
	self.topPageControll = [[UIPageControl alloc] initWithFrame:CGRectZero];
	self.topPageControll.translatesAutoresizingMaskIntoConstraints = NO;
	self.topPageControll.pageIndicatorTintColor = [UIColor grayColor];
	self.topPageControll.currentPageIndicatorTintColor = [UIColor blackColor];
	[self.view addSubview:self.topPageControll];
	
	id topLayoutGuide = self.topLayoutGuide;
	UIView *pageControll = self.topPageControll;
	CGFloat yOrigin = CGRectGetHeight(self.topCarouselView.frame) - REVPageControllBottom;
	NSArray *horConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageControll]|"
										  options:0
										  metrics:nil
											views:NSDictionaryOfVariableBindings(pageControll)];
	NSArray *verConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-yOrigin-[pageControll(==height)]"
										  options:0
										  metrics:@{
													@"height": @(REVPageControlHeight),
													@"yOrigin": @(yOrigin)
													}
											views:NSDictionaryOfVariableBindings(pageControll, topLayoutGuide)];
	[self.view addConstraints:horConstraints];
	[self.view addConstraints:verConstraints];
	self.topPageControll.numberOfPages = self.coreService.moneyArray.count;
}

- (void)createBottomPageControll {
	self.bottomPageControll = [[UIPageControl alloc] initWithFrame:CGRectZero];
	self.bottomPageControll.translatesAutoresizingMaskIntoConstraints = NO;
	self.bottomPageControll.pageIndicatorTintColor = [UIColor grayColor];
	self.bottomPageControll.currentPageIndicatorTintColor = [UIColor blackColor];
	[self.view addSubview:self.bottomPageControll];
	
	id topLayoutGuide = self.topLayoutGuide;
	UIView *pageControll = self.bottomPageControll;
	CGFloat yOrigin =
	CGRectGetHeight(self.topCarouselView.frame) + CGRectGetHeight(self.bottomCarouselView.frame) - REVPageControllBottom;
	NSArray *horConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageControll]|"
												  options:0
												  metrics:nil
													views:NSDictionaryOfVariableBindings(pageControll)];
	NSArray *verConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-yOrigin-[pageControll(==height)]"
												  options:0
												  metrics:@{
															@"height": @(REVPageControlHeight),
															@"yOrigin": @(yOrigin)
															}
													views:NSDictionaryOfVariableBindings(pageControll, topLayoutGuide)];
	[self.view addConstraints:horConstraints];
	[self.view addConstraints:verConstraints];
	self.bottomPageControll.numberOfPages = self.coreService.moneyArray.count;
}

#pragma mark - Actions

- (void)echangeAction:(UIBarButtonItem *)item {
	[self.coreService exchange];
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - REVCarouselScrollViewDataSource

- (NSUInteger)numberOfItemsForCarouselView:(REVCarouselScrollView *)carouselView {
	return self.coreService.moneyArray.count;
}

- (UIView *)objectAtIndex:(NSUInteger)objectIndex carouselView:(REVCarouselScrollView *)carouselView {
	REVMoney *money = self.coreService.moneyArray[objectIndex];
	
	CGFloat scrollViewWidth = CGRectGetWidth(carouselView.frame);
	
	UIView *moneyContainer = [[UIView alloc] initWithFrame:CGRectZero];
	
	CGRect currencyLabelRect = CGRectMake(REVCurrencyLabelLeft, 0, 0, 0);
	UILabel *currencyLabel = [[UILabel alloc] initWithFrame:currencyLabelRect];
	currencyLabel.text = money.currency.code;
	currencyLabel.textColor = [UIColor blackColor];
	currencyLabel.font = [UIFont systemFontOfSize:40.0];
	currencyLabel.textAlignment = NSTextAlignmentCenter;
	[currencyLabel sizeToFit];
	currencyLabel.center = CGPointMake(CGRectGetMidX(currencyLabel.frame), REVCurrencyLabelTop);
	
	CGRect currentMoneyLabelRect = CGRectMake(REVCurrencyLabelLeft, 0, 0, 0);
	UILabel *currentMoneyLabel = [[UILabel alloc] initWithFrame:currentMoneyLabelRect];
	currentMoneyLabel.text =
	[NSString stringWithFormat:@"You have %@%@", money.currency.sign, [money.amount stringForNumberWithCurrencyStyle]];
	currentMoneyLabel.textColor = [UIColor blackColor];
	currentMoneyLabel.font = [UIFont systemFontOfSize:15.0];
	currentMoneyLabel.textAlignment = NSTextAlignmentCenter;
	[currentMoneyLabel sizeToFit];
	currentMoneyLabel.center =
	CGPointMake(CGRectGetMidX(currentMoneyLabel.frame), CGRectGetMaxY(currencyLabel.frame)+REVCurrentMoneyLabelTop);
	[moneyContainer addSubview:currentMoneyLabel];
	if ([carouselView isEqual:self.topCarouselView]) {
		[self.topWalletLabelArray addObject:currentMoneyLabel];
	} else {
		[self.bottomWalletLabelArray addObject:currentMoneyLabel];
	}
	
	if ([carouselView isEqual:self.topCarouselView]) {
		CGFloat textFieldWidth = scrollViewWidth - CGRectGetMaxX(currencyLabel.frame) - REVTextFieldLeft;
		CGRect textFieldRect =
		CGRectMake(CGRectGetMaxX(currencyLabel.frame), CGRectGetMinY(currencyLabel.frame),
				   textFieldWidth, CGRectGetHeight(currencyLabel.frame));
		UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];
		textField.textAlignment = NSTextAlignmentRight;
		textField.font = [UIFont systemFontOfSize:40.0];
		textField.keyboardType = UIKeyboardTypeDecimalPad;
		textField.delegate = self;
		[moneyContainer addSubview:textField];
		[self.textFieldArray addObject:textField];
	} else {
		CGFloat textLabelWidth = scrollViewWidth - CGRectGetMaxX(currencyLabel.frame) - REVTextFieldLeft;
		CGRect textLabelRect =
		CGRectMake(CGRectGetMaxX(currencyLabel.frame), CGRectGetMinY(currencyLabel.frame), textLabelWidth, CGRectGetHeight(currencyLabel.frame));
		UILabel *textLabel = [[UILabel alloc] initWithFrame:textLabelRect];
		textLabel.textAlignment = NSTextAlignmentRight;
		textLabel.font = [UIFont systemFontOfSize:40.0];
		[moneyContainer addSubview:textLabel];
		[self.textLabelArray addObject:textLabel];
		
		CGFloat yRateLabelOrigin = CGRectGetMinY(currentMoneyLabel.frame);
		CGRect rateLabelRect =
		CGRectMake(CGRectGetMinX(textLabel.frame), yRateLabelOrigin,
				   CGRectGetWidth(textLabel.frame), CGRectGetHeight(currentMoneyLabel.frame));
		UILabel *rateLabel = [[UILabel alloc] initWithFrame:rateLabelRect];
		textLabel.textAlignment = NSTextAlignmentRight;
		rateLabel.font = [UIFont systemFontOfSize:15.0];
		[moneyContainer addSubview:rateLabel];
		[self.rateLabelArray addObject:rateLabel];
	}
	
	[moneyContainer addSubview:currencyLabel];
	
	return moneyContainer;
}

- (void)didPageAtIndex:(NSUInteger)index carouselView:(REVCarouselScrollView *)carouselView {
	if ([carouselView isEqual:self.topCarouselView]) {
		self.topPageControll.currentPage = index;
		
		self.deltaCurrency.fromCurrency = self.coreService.moneyArray[index].currency;
		
		self.coreService.selectedIndex = index;
	}
	if ([carouselView isEqual:self.bottomCarouselView]) {
		self.bottomPageControll.currentPage = index;
		
		self.deltaCurrency.toCurrency = self.coreService.moneyArray[index].currency;
	}
	
	if ([self.deltaCurrency isValid]) {
		[self.coreService calculateDeltaCurrency:self.deltaCurrency];
	}
	
	REVMoney *currentWalletMoney = self.coreService.moneyArray[self.topPageControll.currentPage];
	REVMoney *convertedMoney = [REVMoney moneyCurrency:currentWalletMoney.currency amountString:@"0"];
	[self.coreService calculateConvertedMoney:convertedMoney];
	
	if ([self.coreService.moneyArray[self.topPageControll.currentPage]
			 isEqualToMoney:self.coreService.moneyArray[self.bottomPageControll.currentPage]]) {
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
}

- (void)didViewAtIndex:(NSUInteger)index carouselView:(REVCarouselScrollView *)carouselView {
	if ([carouselView isEqual:self.topCarouselView]) {
		self.currentTextField = self.textFieldArray[index];
		self.currentTopWalletLabel = self.topWalletLabelArray[index];
		[self.currentTextField becomeFirstResponder];
	}
	if ([carouselView isEqual:self.bottomCarouselView]) {
		self.currentTextLabel = self.textLabelArray[index];
		self.currentRateLabel = self.rateLabelArray[index];
		self.currentBottomWalletLabel = self.bottomWalletLabelArray[index];
	}
	[self clearUI];
}

- (void)clearUI {
	for (UITextField *textField in self.textFieldArray) {
		textField.text = nil;
	}
	for (UILabel *label in self.textLabelArray) {
		label.text = nil;
	}
}

- (void)dataIsLoadedForCarouselView:(REVCarouselScrollView *)carouselView {
	if ([carouselView isEqual:self.topCarouselView]) {
		[self.topCarouselView scrollToPage:self.coreService.selectedIndex];
	}
	
	if ([carouselView isEqual:self.bottomCarouselView]) {
		[self.bottomCarouselView scrollToPage:self.coreService.selectedIndex+1];
	}
}

#pragma mark - REVConverterCoreServiceDelegate

- (void)showAlertWithText:(NSString *)text {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
																			 message:text
																	  preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK"
														  style:UIAlertActionStyleDefault
														handler:nil];
	[alertController addAction:alertAction];
	
	[self presentViewController:alertController animated:YES completion:nil];
}

- (void)showDirectRateText:(NSString *)text {
	self.navigationItem.title = text;
}

- (void)showInversRateText:(NSString *)text {
	self.currentRateLabel.textAlignment = NSTextAlignmentRight;
	self.currentRateLabel.text = text;
}

- (void)showCalculatedMoneyText:(NSString *)text {
	self.currentTextLabel.text = text;
}

- (void)showFromMoneyBalanceText:(NSString *)text {
	self.currentTopWalletLabel.textColor = [UIColor blackColor];
	self.currentTopWalletLabel.text = text;
}

- (void)showToMoneyBalanceText:(NSString *)text {
	self.currentBottomWalletLabel.text = text;
}

- (void)showNotEnoughBalance {
	self.currentTopWalletLabel.textColor = [UIColor redColor];
	self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSString *newString = @"";
	newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
	
	newString = [newString stringByReplacingOccurrencesOfString:@"-" withString:@""];
	
	REVMoney *currentWalletMoney = self.coreService.moneyArray[self.topPageControll.currentPage];
	REVMoney *convertedMoney = [REVMoney moneyCurrency:currentWalletMoney.currency amountString:@"0"];
	if (newString.length) {
		convertedMoney = [REVMoney moneyCurrency:currentWalletMoney.currency amountString:newString];
	}
	
	if (newString.length) {
		self.navigationItem.rightBarButtonItem.enabled = YES;
	} else {
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
	if ([self.coreService.moneyArray[self.topPageControll.currentPage]
		 isEqualToMoney:self.coreService.moneyArray[self.bottomPageControll.currentPage]]) {
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
	
	
	[self.coreService calculateConvertedMoney:convertedMoney];
	
	if (newString.length) {
		newString = [@"-" stringByAppendingString:newString];
	}
	
	textField.text = newString;
	
	return NO;
}

@end
