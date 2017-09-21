//
//  REVChooseCurrencyViewController.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 16/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVChooseCurrencyViewController.h"

const CGFloat REVPageControlHeight = 50.0;

@interface REVChooseCurrencyViewController () <REVConverterCoreServiceDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) REVConverterCoreService *coreService;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControll;
@property (nonatomic, strong) UIButton *exchangeButton;

@property (nonatomic, strong) NSArray<REVMoney *> *moneyArray;
@property (nonatomic, assign) NSUInteger currentPageMoney;

@end

@implementation REVChooseCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	[self createScrollView];
	[self createPageControll];
	[self createExchangeButton];
	
	self.coreService = [REVConverterCoreService new];
	[self.coreService addDelegate:self];
	[self.coreService start];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)createScrollView {
	self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
	self.scrollView.delegate = self;
	self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
	self.scrollView.pagingEnabled = YES;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	[self.view addSubview:self.scrollView];
	
	UIView *scrollView = self.scrollView;
	NSArray *horConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"
												  options:0
												  metrics:nil
													views:NSDictionaryOfVariableBindings(scrollView)];
	NSArray *vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|"
												   options:0
												   metrics:nil
													 views:NSDictionaryOfVariableBindings(scrollView)];
	[self.view addConstraints:horConstraints];
	[self.view addConstraints:vertConstraints];
	[self.scrollView layoutIfNeeded];
}

- (void)createPageControll {
	self.pageControll = [[UIPageControl alloc] initWithFrame:CGRectZero];
	self.pageControll.translatesAutoresizingMaskIntoConstraints = NO;
	self.pageControll.pageIndicatorTintColor = [UIColor grayColor];
	self.pageControll.currentPageIndicatorTintColor = [UIColor blackColor];
	[self.view addSubview:self.pageControll];
	
	UIView *pageControll = self.pageControll;
	NSArray *horConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageControll]|"
										  options:0
										  metrics:nil
											views:NSDictionaryOfVariableBindings(pageControll)];
	NSArray *verConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[pageControll(==height)]|"
										  options:0
										  metrics:@{@"height": @(REVPageControlHeight)}
											views:NSDictionaryOfVariableBindings(pageControll)];
	[self.view addConstraints:horConstraints];
	[self.view addConstraints:verConstraints];
}

- (void)createExchangeButton {
	self.exchangeButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.exchangeButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.exchangeButton.frame = CGRectZero;
	[self.exchangeButton setTitle:@"Exchange" forState:UIControlStateNormal];
	[self.exchangeButton addTarget:self action:@selector(exchangeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.exchangeButton];
	
	NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.exchangeButton
											   attribute:NSLayoutAttributeCenterX
											   relatedBy:NSLayoutRelationEqual
												  toItem:self.view
											   attribute:NSLayoutAttributeCenterX
											  multiplier:1.f constant:0.f];
	NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.exchangeButton
										   attribute:NSLayoutAttributeCenterY
										   relatedBy:NSLayoutRelationEqual
											  toItem:self.view
										   attribute:NSLayoutAttributeCenterY
										  multiplier:1.f constant:150.f];
	[self.view addConstraints:@[centerX, centerY]];
}

#pragma mark - Actions

- (void)exchangeButtonAction:(UIButton *)sender {
	[self.coreService didSelectMoney:self.moneyArray[self.currentPageMoney]];
	
	REVExchaneViewController *exchangeVC = [[REVExchaneViewController alloc] init];
	[self.navigationController pushViewController:exchangeVC animated:YES];
}

#pragma mark - REVConverterCoreServiceDelegate

- (void)receiveMoneyArray:(NSArray<REVMoney *> *)moneyArray {
	self.moneyArray = moneyArray;
	CGFloat scrollViewWidth = CGRectGetWidth(self.scrollView.frame);
	CGFloat scrollViewHeight = CGRectGetHeight(self.scrollView.frame);
	NSUInteger count = 0;
	
	REVMoney *lastMoney = self.moneyArray.lastObject;
	UIView *lastMoneyView = [self viewFromMoney:lastMoney count:0];
	[self.scrollView addSubview:lastMoneyView];
	
	for (NSInteger i=0; i<self.moneyArray.count; i++) {
		REVMoney *money = self.moneyArray[i];
		UIView *moneyView = [self viewFromMoney:money count:i+1];
		[self.scrollView addSubview:moneyView];
		count ++;
	}
	REVMoney *firstMoney = self.moneyArray.firstObject;
	UIView *firstMoneyView = [self viewFromMoney:firstMoney count:count+1];
	[self.scrollView addSubview:firstMoneyView];
	
	self.scrollView.contentSize = CGSizeMake(scrollViewWidth*(count+2), scrollViewHeight);
	self.pageControll.numberOfPages = count;
}

#pragma mark - Views

- (UIView *)viewFromMoney:(REVMoney *)money count:(NSInteger)i {
	CGFloat yOrigin = 0;
	CGFloat scrollViewWidth = CGRectGetWidth(self.scrollView.frame);
	CGFloat scrollViewHeight = CGRectGetHeight(self.scrollView.frame);
	CGRect containerFrame = CGRectMake(scrollViewWidth*i, yOrigin, scrollViewWidth, scrollViewHeight);
	UIView *moneyContainer = [[UIView alloc] initWithFrame:containerFrame];
	UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	moneyLabel.text = [NSString stringWithFormat:@"%@ %@", money.currency.sign, [money.amount stringForNumberWithCurrencyStyle]];
	moneyLabel.textColor = [UIColor blackColor];
	moneyLabel.font = [UIFont systemFontOfSize:70.0];
	moneyLabel.textAlignment = NSTextAlignmentCenter;
	[moneyLabel sizeToFit];
	moneyLabel.center = CGPointMake(containerFrame.size.width/2, (containerFrame.size.height/2)-100.0);
	[moneyContainer addSubview:moneyLabel];
	UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	descriptionLabel.text = [NSString stringWithFormat:@"%@ - %@", money.currency.code, money.currency.name];
	descriptionLabel.textColor = [UIColor blackColor];
	descriptionLabel.font = [UIFont systemFontOfSize:20.0];
	descriptionLabel.textAlignment = NSTextAlignmentCenter;
	[descriptionLabel sizeToFit];
	descriptionLabel.center = CGPointMake(containerFrame.size.width/2, moneyLabel.center.y+70.0);
	[moneyContainer addSubview:descriptionLabel];
	return moneyContainer;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat scrollViewWidth = CGRectGetWidth(self.scrollView.frame);
	CGFloat scrollViewHeight = CGRectGetHeight(self.scrollView.frame);
	
	int currentPage = floor((self.scrollView.contentOffset.x - self.scrollView.frame.size.width / ([self.moneyArray count]+2)) / self.scrollView.frame.size.width) + 1;
	if (currentPage==0) {
		//go last but 1 page
		[self.scrollView scrollRectToVisible:CGRectMake(scrollViewWidth * [self.moneyArray count],0,scrollViewWidth,scrollViewHeight) animated:NO];
	} else if (currentPage==([self.moneyArray count]+1)) {
		[self.scrollView scrollRectToVisible:CGRectMake(scrollViewWidth,0,scrollViewWidth,scrollViewHeight) animated:NO];
	}
	
	CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
	int currentPageForControll = floor((self.scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
	self.currentPageMoney = currentPageForControll==3 ? 0 : currentPageForControll;
	self.pageControll.currentPage = self.currentPageMoney;
}

@end
