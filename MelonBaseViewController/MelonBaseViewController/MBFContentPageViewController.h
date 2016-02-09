//
//  MTPContentPageViewController.h
//  MTPPageController
//
//  Created by Tomasz Popis on 10/07/15.
//  Copyright (c) 2015 Melon IT. All rights reserved.
//

#import "MBFBaseViewController.h"

typedef NS_ENUM(NSUInteger, ScrollDirectionType) {
  ScrollDirectionTypeLeft,
  ScrollDirectionTypeRight
};

@interface MBFContentPageViewController : MBFBaseViewController

@property (nonatomic, weak) UIViewController* pageViewController;

- (void)didScrollOutOfScreenWithOffset:(CGFloat)offset
                          andDirection:(ScrollDirectionType)scrollDirectionType;

- (void)didScrollOnScreenWithOffset:(CGFloat)offset
                       andDirection:(ScrollDirectionType)scrollDirectionType;

@end