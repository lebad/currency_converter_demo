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

@end

@implementation REVChooseCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	[self createScrollView];
	[self createPageControll];
	[self createExchangeButton];
	
	self.coreService = [REVConverterCoreService new];
	self.coreService.delegate = self;
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
	
}

#pragma mark - REVConverterCoreServiceDelegate

- (void)receiveMoneyArray:(NSArray<REVMoney *> *)moneyArray
{
	CGFloat yOrigin = 0;
	CGFloat scrollViewWidth = CGRectGetWidth(self.scrollView.frame);
	CGFloat scrollViewHeight = CGRectGetHeight(self.scrollView.frame);
	NSUInteger count = 0;
	for (NSInteger i=0; i<moneyArray.count; i++) {
		REVMoney *money = moneyArray[i];
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
		[self.scrollView addSubview:moneyContainer];
		count ++;
	}
	self.scrollView.contentSize = CGSizeMake(scrollViewWidth*count, scrollViewHeight);
	self.pageControll.numberOfPages = count;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
	CGFloat currentPage = floor((self.scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
	self.pageControll.currentPage = (NSInteger)currentPage;
}

@end
