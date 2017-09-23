//
//  REVChooseCurrencyViewController.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 16/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVChooseCurrencyViewController.h"
#import "REVCarouselScrollView.h"

static const CGFloat REVPageControlHeight = 50.0;

@interface REVChooseCurrencyViewController ()
<
REVConverterCoreServiceDelegate,
UIScrollViewDelegate,
REVCarouselScrollViewDataSource
>

@property (nonatomic, strong) REVConverterCoreService *coreService;

@property (nonatomic, strong) REVCarouselScrollView *carouselView;
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
	self.carouselView = [[REVCarouselScrollView alloc] initWithFrame:CGRectZero];
	self.carouselView.dataSource = self;
	[self.view addSubview:self.carouselView];
	
	UIView *scrollView = self.carouselView;
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
	[self.carouselView layoutIfNeeded];
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
	
	REVExchangeViewController *exchangeVC = [[REVExchangeViewController alloc] init];
	exchangeVC.moneyArray = self.moneyArray;
	[self.coreService addDelegate:exchangeVC];
	[self.navigationController pushViewController:exchangeVC animated:YES];
}

#pragma mark - REVConverterCoreServiceDelegate

- (void)receiveMoneyArray:(NSArray<REVMoney *> *)moneyArray {
	self.moneyArray = moneyArray;
	self.pageControll.numberOfPages = self.moneyArray.count;
	[self.carouselView reloadData];
}

- (void)showAlertWithText:(NSString *)text {
	
}

#pragma mark - REVCarouselScrollViewDataSource

- (NSUInteger)numberOfItemsForCarouselView:(REVCarouselScrollView *)carouselView {
	return self.moneyArray.count;
}

- (UIView *)objectAtIndex:(NSUInteger)objectIndex
			  viewAtIndex:(NSUInteger)viewIndex
			 carouselView:(REVCarouselScrollView *)carouselView {
	REVMoney *money = self.moneyArray[objectIndex];
	CGFloat yOrigin = 0;
	CGFloat scrollViewWidth = CGRectGetWidth(self.carouselView.frame);
	CGFloat scrollViewHeight = CGRectGetHeight(self.carouselView.frame);
	CGRect containerFrame = CGRectMake(scrollViewWidth*viewIndex, yOrigin, scrollViewWidth, scrollViewHeight);
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

- (void)didPageAtIndex:(NSUInteger)index carouselView:(REVCarouselScrollView *)carouselView {
	self.pageControll.currentPage = index;
}

@end
