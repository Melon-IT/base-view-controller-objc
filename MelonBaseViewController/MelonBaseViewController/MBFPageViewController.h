//
//  MTPPageViewController.h
//  MTPPageController
//
//  Created by Tomek Popis on 10/5/13.
//  Copyright (c) 2013 Melon IT. All rights reserved.
//


#import <UIKit/UIKit.h>

@class MBFContentPageViewController;

@interface MBFPageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate> {
  
@protected
  UIPageViewController* pageViewController;
}

@property (nonatomic, weak, readonly) MBFContentPageViewController* currentViewController;

@property (nonatomic, readonly) BOOL nextPageExist;
@property (nonatomic, readonly) BOOL previousPageExist;
@property (nonatomic, readonly) NSInteger nextPageIndex;

@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic, readonly) NSInteger numberOfPages;

@property (nonatomic) BOOL continuousMode;

@property (nonatomic) UIPageViewControllerNavigationOrientation navigationOrientation;

@property (nonatomic) NSString* contentViewControllerIdentifier;
@property (nonatomic) CGRect contentRect;

- (void)moveToViewControllerAtIndex:(NSUInteger)index
                      withDirection:(UIPageViewControllerNavigationDirection)direction;

- (void)pageWillChangeFromViewController:(UIViewController*)fromViewController
                        toViewController:(UIViewController*)viewController;

- (void)setContentViewAtIndex:(NSUInteger)index;

- (void)pageDidChange;

@end
