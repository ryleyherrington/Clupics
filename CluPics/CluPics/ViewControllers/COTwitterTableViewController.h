//
//  COTwitterTableViewController.h
//  CluPics
//
//  Created by Hung  On on 6/29/14.
//  Copyright (c) 2014 Ryley Herrington. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface COTwitterTableViewController : UITableViewController

@property NSArray *tweets;

-(void)fetchTweets;

@end
