//
//  REVExchaneViewController.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 17/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVExchangeViewController.h"
#import "REVCarouselScrollView.h"

const CGFloat REVCarouselViewHeight = 150.0;

@interface REVExchangeViewController ()
<
REVCarouselScrollViewDataSource
>

@property (nonatomic, strong) REVCarouselScrollView *topCarouselView;
@property (nonatomic, strong) REVCarouselScrollView *bottomCarouselView;

@end

@implementation REVExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	[self createTopCarouselView];
	[self createBottomCarouselView];
}

- (void)createTopCarouselView {
	self.topCarouselView = [[REVCarouselScrollView alloc] initWithFrame:CGRectZero];
	self.topCarouselView.dataSource = self;
	self.topCarouselView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
	[self.view addSubview:self.topCarouselView];
	
	id topLayoutGuide = self.topLayoutGuide;
	UIScrollView *scrollView = self.topCarouselView;
	NSArray *horConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"
												  options:0
												  metrics:nil
													views:NSDictionaryOfVariableBindings(scrollView)];
	NSArray *vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][scrollView(==height)]"
												   options:0
												   metrics:@{@"height": @(REVCarouselViewHeight)}
													 views:NSDictionaryOfVariableBindings(scrollView, topLayoutGuide)];
	[self.view addConstraints:horConstraints];
	[self.view addConstraints:vertConstraints];
	[self.topCarouselView layoutIfNeeded];
}

- (void)createBottomCarouselView {
	self.bottomCarouselView = [[REVCarouselScrollView alloc] initWithFrame:CGRectZero];
	self.bottomCarouselView.dataSource = self;
	self.bottomCarouselView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
	[self.view addSubview:self.bottomCarouselView];
	
	UIScrollView *topScrollView = self.topCarouselView;
	UIScrollView *scrollView = self.bottomCarouselView;
	NSArray *horConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"
												  options:0
												  metrics:nil
													views:NSDictionaryOfVariableBindings(scrollView)];
	NSArray *vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topScrollView][scrollView(==height)]"
													   options:0
													   metrics:@{@"height": @(REVCarouselViewHeight)}
														 views:NSDictionaryOfVariableBindings(scrollView, topScrollView)];
	[self.view addConstraints:horConstraints];
	[self.view addConstraints:vertConstraints];
	[self.topCarouselView layoutIfNeeded];
}

#pragma mark - REVCarouselScrollViewDataSource

- (NSUInteger)numberOfItemsForCarouselView:(REVCarouselScrollView *)carouselView {
	return 1;
}

- (UIView *)objectAtIndex:(NSUInteger)objectIndex
			  viewAtIndex:(NSUInteger)viewIndex
			 carouselView:(REVCarouselScrollView *)carouselView {
	CGFloat scrollViewWidth = CGRectGetWidth(self.topCarouselView.bounds);
	CGFloat scrollViewHeight = CGRectGetHeight(self.topCarouselView.bounds);
	CGRect innerViewRect = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight);
	UIView *innerView = [[UIView alloc] initWithFrame:innerViewRect];
	return innerView;
}

- (void)didPageAtIndex:(NSUInteger)index carouselView:(REVCarouselScrollView *)carouselView {
	
}

@end
