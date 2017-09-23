//
//  REVExchaneViewController.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 17/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVExchangeViewController.h"
#import "REVCarouselScrollView.h"

static const CGFloat REVCurrencyLabelLeft = 30.0;
static const CGFloat REVCurrentMoneyLabelTop = 10.0;
static const CGFloat REVPageControllBottom = 30.0;
static const CGFloat REVPageControlHeight = 30.0;
static const CGFloat REVTextFieldLeft = 30.0;
static const CGFloat REVKeyBoardHeight = 216.0;

@interface REVExchangeViewController ()
<
REVCarouselScrollViewDataSource
>

@property (nonatomic, strong) REVCarouselScrollView *topCarouselView;
@property (nonatomic, strong) REVCarouselScrollView *bottomCarouselView;
@property (nonatomic, strong) UIPageControl *topPageControll;
@property (nonatomic, strong) UIPageControl *bottomPageControll;

@property (nonatomic, copy) NSMutableArray<UITextField *> *textFieldArray;
@property (nonatomic, copy) NSMutableArray<UILabel *> *textLabelArray;
@property (nonatomic, copy) NSMutableArray<UILabel *> *rateLabelArray;

@end

@implementation REVExchangeViewController

- (instancetype)init
{
	self = [super init];
	if (self) {
		_textFieldArray = [NSMutableArray new];
		_textLabelArray = [NSMutableArray new];
		_rateLabelArray = [NSMutableArray new];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
	[textField becomeFirstResponder];
	
	[self createTopCarouselView];
	[self createBottomCarouselView];
	[self createTopPageControll];
	[self createBottomPageControll];
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
	
	[self.topCarouselView reloadData];
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
	
	[self.bottomCarouselView reloadData];
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
	self.topPageControll.numberOfPages = self.moneyArray.count;
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
	self.bottomPageControll.numberOfPages = self.moneyArray.count;
	self.bottomPageControll.currentPage = 1;
}

#pragma mark - REVConverterCoreServiceDelegate


#pragma mark - REVCarouselScrollViewDataSource

- (NSUInteger)numberOfItemsForCarouselView:(REVCarouselScrollView *)carouselView {
	return self.moneyArray.count;
}

- (UIView *)objectAtIndex:(NSUInteger)objectIndex
			  viewAtIndex:(NSUInteger)viewIndex
			 carouselView:(REVCarouselScrollView *)carouselView {
	REVMoney *money = self.moneyArray[objectIndex];
	if ([carouselView isEqual:self.bottomCarouselView]) {
		money = self.moneyArray[objectIndex == self.moneyArray.count-1 ? 0 : objectIndex+1];
	}
	
	CGFloat yOrigin = 0;
	CGFloat scrollViewWidth = CGRectGetWidth(carouselView.frame);
	CGFloat scrollViewHeight = CGRectGetHeight(carouselView.frame);
	CGRect containerFrame = CGRectMake(scrollViewWidth*viewIndex, yOrigin, scrollViewWidth, scrollViewHeight);
	UIView *moneyContainer = [[UIView alloc] initWithFrame:containerFrame];
	
	CGRect currencyLabelRect = CGRectMake(REVCurrencyLabelLeft, 0, 0, 0);
	UILabel *currencyLabel = [[UILabel alloc] initWithFrame:currencyLabelRect];
	currencyLabel.text = money.currency.code;
	currencyLabel.textColor = [UIColor blackColor];
	currencyLabel.font = [UIFont systemFontOfSize:40.0];
	currencyLabel.textAlignment = NSTextAlignmentCenter;
	[currencyLabel sizeToFit];
	currencyLabel.center = CGPointMake(CGRectGetMidX(currencyLabel.frame), containerFrame.size.height/2);
	
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
		CGFloat textFieldWidth = scrollViewWidth - CGRectGetMaxX(currencyLabel.frame) - REVTextFieldLeft;
		CGRect textFieldRect =
		CGRectMake(CGRectGetMaxX(currencyLabel.frame), 0, textFieldWidth, CGRectGetHeight(currencyLabel.frame));
		UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];
		textField.textAlignment = NSTextAlignmentRight;
		textField.font = [UIFont systemFontOfSize:40.0];
		textField.keyboardType = UIKeyboardTypeDecimalPad;
		textField.center = CGPointMake(CGRectGetMidX(textFieldRect), scrollViewHeight/2);
		[moneyContainer addSubview:textField];
		[self.textFieldArray addObject:textField];
	} else {
		CGFloat textLabelWidth = scrollViewWidth - CGRectGetMaxX(currencyLabel.frame) - REVTextFieldLeft;
		CGRect textLabelRect =
		CGRectMake(CGRectGetMaxX(currencyLabel.frame), 0, textLabelWidth, CGRectGetHeight(currencyLabel.frame));
		UILabel *textLabel = [[UILabel alloc] initWithFrame:textLabelRect];
		textLabel.textAlignment = NSTextAlignmentRight;
		textLabel.font = [UIFont systemFontOfSize:40.0];
		textLabel.center = CGPointMake(CGRectGetMidX(textLabelRect), scrollViewHeight/2);
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
	}
	if ([carouselView isEqual:self.bottomCarouselView]) {
		NSInteger currentPage = (index == self.moneyArray.count-1 ? 0: index+1);
		self.bottomPageControll.currentPage = currentPage;
	}
//	if (index == 0) {
		UITextField *firstTextField = self.textFieldArray[index];
		[firstTextField becomeFirstResponder];
//	}
}

@end
