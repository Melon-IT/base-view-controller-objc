//
//  MTPContentPageViewController.m
//  MTPPageController
//
//  Created by Tomasz Popis on 10/07/15.
//  Copyright (c) 2015 Melon IT. All rights reserved.
//

#import "MBFContentPageViewController.h"

@interface MBFContentPageViewController ()

@end

@implementation MBFContentPageViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (BOOL)prefersStatusBarHidden{
  return YES;
}

- (void)didScrollOutOfScreenWithOffset:(CGFloat)offset
                          andDirection:(ScrollDirectionType)scrollDirectionType {}

- (void)didScrollOnScreenWithOffset:(CGFloat)offset
                       andDirection:(ScrollDirectionType)scrollDirectionType {}

@end
