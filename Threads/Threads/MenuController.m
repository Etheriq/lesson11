//
//  MenuControllerTableViewController.m
//  Threads
//
//  Created by Yuriy T on 30.01.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "MenuController.h"
#import "PushTransitionAnimator.h"

@interface MenuController ()

@end

@implementation MenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    self.navigationItem.title = @"Menu";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush)
        return [[PushTransitionAnimator alloc] init];
    
//    if (operation == UINavigationControllerOperationPop)
//        return [[PopAnimator alloc] init];
    
    return nil;
}

@end
