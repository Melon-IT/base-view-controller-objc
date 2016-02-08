//
//  MTPPageViewController.m
//  MTPPageController
//
//  Created by Tomek Popis on 10/5/13.
//  Copyright (c) 2013 Melon IT. All rights reserved.
//

#import "MBFPageViewController.h"
#import "MBFContentPageViewController.h"

@interface MBFPageViewController ()

@end

@implementation MBFPageViewController {
  __weak MBFContentPageViewController* nextViewController;
  
  BOOL rightDirection;
  BOOL leftDirection;
  BOOL nonDirection;
}

- (BOOL)nextPageExist {
  
  return self.currentPageIndex + 1 < self.numberOfPages;
}

- (BOOL)previousPageExist {
  
  return self.currentPageIndex - 1 >= 0;
}

- (NSInteger)numberOfPages {
  
  return 0;
}


#pragma mark UIViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  
  pageViewController =
  [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                  navigationOrientation:_navigationOrientation
                                                options:nil];
  pageViewController.dataSource = self;
  pageViewController.delegate = self;
  
  for (UIView* view in [pageViewController.view subviews]) {
    if ([view  isKindOfClass:[UIScrollView class]]) {
      ((UIScrollView*)view).delegate = self;
      break;
    }
  }
  
  if(self.contentViewControllerIdentifier != nil) {
    
    UIViewController* startingViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:self.contentViewControllerIdentifier];
    
    startingViewController.view.tag = self.currentPageIndex;
    self->_currentViewController = (MBFContentPageViewController*)startingViewController;
    self->_currentViewController.pageViewController = self;
    
    [pageViewController setViewControllers:@[startingViewController]
                                 direction:UIPageViewControllerNavigationDirectionForward
                                  animated:YES
                                completion:nil];
    
    pageViewController.view.frame = self.contentRect;
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    
    [pageViewController didMoveToParentViewController:self];
    
  }
}

#pragma mark UIPageViewControllerDataSource
- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController
     viewControllerBeforeViewController:(UIViewController*)viewController {
  
  UIViewController* resultViewController = nil;
  self->_currentViewController = (MBFContentPageViewController*)viewController;
  
  self.currentPageIndex = viewController.view.tag;
  
  if(self.previousPageExist == YES) {
    
    self->_nextPageIndex = viewController.view.tag - 1;
    resultViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:self.contentViewControllerIdentifier];
    resultViewController.view.tag = self.nextPageIndex;
    
  } else if(self.continuousMode == YES) {
    
    self->_nextPageIndex = self.numberOfPages - 1;
    resultViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:self.contentViewControllerIdentifier];
    resultViewController.view.tag = self->_nextPageIndex;
    
  }
  
  return resultViewController;
}

- (void)moveToViewControllerAtIndex:(NSUInteger)index withDirection:(UIPageViewControllerNavigationDirection)direction {
  self.currentPageIndex = index;
  self->_nextPageIndex = index;
  if(self.contentViewControllerIdentifier != nil) {
    
    UIViewController* startingViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:self.contentViewControllerIdentifier];
    
    startingViewController.view.tag = self.currentPageIndex;
    self->_currentViewController = (MBFContentPageViewController*)startingViewController;
    self->_currentViewController.pageViewController = self;
    
    [pageViewController setViewControllers:@[startingViewController]
                                 direction:direction
                                  animated:YES
                                completion:nil];
    
  }
  
}
#pragma mark Page trigger
- (void)pageWillChangeFromViewController:(UIViewController*)fromViewController
                        toViewController:(UIViewController*)viewController {}

- (void)pageDidChange {}

#pragma mark UIPageViewControllerDelegate
- (UIViewController *)pageViewController:(UIPageViewController*)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
  
  UIViewController* resultViewController = nil;
  self->_currentViewController = (MBFContentPageViewController*)viewController;
  self->_currentViewController.pageViewController = self;
  
  self.currentPageIndex = viewController.view.tag;
  
  if(self.nextPageExist == YES) {
    
    self->_nextPageIndex = viewController.view.tag + 1;
    resultViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:self.contentViewControllerIdentifier];
    resultViewController.view.tag = self->_nextPageIndex;
    
  } else if(self.continuousMode == YES) {
    
    self->_nextPageIndex = 0;
    resultViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:self.contentViewControllerIdentifier];
    resultViewController.view.tag = self->_nextPageIndex;
    
  }
  
  return resultViewController;
}

- (void)setContentViewAtIndex:(NSUInteger)index {
  self->_nextPageIndex = index;
  
  UIViewController* startingViewController =
  [self.storyboard instantiateViewControllerWithIdentifier:self.contentViewControllerIdentifier];
  
  startingViewController.view.tag = index;
  
  self->_currentViewController = (MBFContentPageViewController*)startingViewController;
  self->_currentViewController.pageViewController = self;
  
  [pageViewController setViewControllers:@[startingViewController]
                               direction:UIPageViewControllerNavigationDirectionForward
                                animated:YES
                              completion:nil];
}

#pragma mark UIPageViewControllerDelegate
-(void)pageViewController:(UIPageViewController*)pageViewController
willTransitionToViewControllers:(NSArray*)pendingViewControllers {
  
  self->nextViewController = [pendingViewControllers lastObject];
  self->nextViewController.pageViewController = self;
  
  [self pageWillChangeFromViewController:self->_currentViewController
                        toViewController:[pendingViewControllers lastObject]];
}

- (void)pageViewController:(UIPageViewController*)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {
  
  self.currentPageIndex = self->nextViewController.view.tag;
  [self pageDidChange];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
  
  CGFloat refference = [UIScreen mainScreen].bounds.size.width;
  CGFloat xOffset = scrollView.contentOffset.x;
  
  ScrollDirectionType scrollDirectionType;
  
  if(refference - xOffset > 0.1) {
    rightDirection = YES;
    scrollDirectionType = ScrollDirectionTypeRight;
  } else if(refference - xOffset < -0.1) {
    rightDirection = NO;
    scrollDirectionType = ScrollDirectionTypeLeft;
  } else {
    if(rightDirection == YES) {
      scrollDirectionType = ScrollDirectionTypeRight;
    } else {
      scrollDirectionType = ScrollDirectionTypeLeft;
    }
  }
  
  CGFloat offsetOut = 1 - (fabs(xOffset - refference))/refference;
  CGFloat offsetOn = (fabs(xOffset - refference))/refference;
  
  [self->_currentViewController didScrollOutOfScreenWithOffset:offsetOut andDirection:scrollDirectionType];
  [self->nextViewController didScrollOnScreenWithOffset:offsetOn andDirection:scrollDirectionType];
}

@end
