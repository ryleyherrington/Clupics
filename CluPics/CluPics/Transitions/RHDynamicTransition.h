//
//  RHDynamicTransition.h
//  CluPics
//
//  Created by Ryley Herrington on 2/28/14.
//  Copyright (c) 2014 Ryley Herrington. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "ECSlidingViewController.h"
#import "ECPercentDrivenInteractiveTransition.h"

@interface RHDynamicTransition : NSObject <UIViewControllerInteractiveTransitioning, UIDynamicAnimatorDelegate,ECSlidingViewControllerDelegate>

@property (nonatomic, assign) ECSlidingViewController *slidingViewController;

-(void)handlePanGesture:(UIPanGestureRecognizer*)recognizer;

@end