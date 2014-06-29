//
//  COTwitterTableViewController.m
//  CluPics
//
//  Created by Hung  On on 6/29/14.
//  Copyright (c) 2014 Ryley Herrington. All rights reserved.
//

#import "COTwitterTableViewController.h"

//UIButton graphics
#import <QuartzCore/QuartzCore.h>

//Menu and Transitions
#import "UIViewController+ECSlidingViewController.h"
#import "RHDynamicTransition.h"

@interface COTwitterTableViewController ()

@property (nonatomic, strong) RHDynamicTransition *transition;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;



@end

@implementation COTwitterTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //configure the transition for swipe menu
    self.transition = [[RHDynamicTransition alloc] init];
    self.transition.slidingViewController = self.slidingViewController;
    
    self.slidingViewController.delegate = self.transition;
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
    self.slidingViewController.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
    [self.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    
    self.navigationController.navigationBar.hidden = YES;
    
    //Fetching tweets
    [self fetchTweets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data source retrieval and processing
-(void)fetchTweets
{
    //https://api.twitter.com/1.1/search/tweets.json?q=%23rymee2014&src=typd
    
    //Require auth to use the request
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),
    //               ^{
    //                   NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:<#(NSString *)#>]]
    //
    //               });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"TableRow:%d, Section:%d", indexPath.row, indexPath.section];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80; //height
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    /* Creating the footer */
    UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)]; //xpos, ypos, width, height
    footer.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    
    /* Creating button to search Twitter and centering it */
    UIButton *twitterSearch = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2 - 100 ), 15, 200, 50)];
   
    /* Setting button appearance */
    [twitterSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [twitterSearch setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [twitterSearch setTitle:@"Search Twitter" forState:UIControlStateNormal];
    [twitterSearch setTitle:@"Search Twitter" forState:UIControlStateHighlighted];
    
    /* Rounding the corners */
    twitterSearch.layer.cornerRadius = 10.0;
    twitterSearch.clipsToBounds = YES;
    
    //twitterSearch.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    twitterSearch.backgroundColor = [UIColor blueColor];
    
    /* Adding event handler */
    [twitterSearch  addTarget:self action:@selector(twitterTouched) forControlEvents:UIControlEventTouchUpInside];
    
    [footer addSubview:twitterSearch];
    
    return footer;
}
#pragma mark - Selectors

-(void)twitterTouched{
    NSLog(@"TOUCHED");
}

#pragma mark - Tranistion Stuff
- (UIPanGestureRecognizer *)dynamicTransitionPanGesture {
    if (_dynamicTransitionPanGesture) return _dynamicTransitionPanGesture;
    
    _dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.transition action:@selector(handlePanGesture:)];
    
    return _dynamicTransitionPanGesture;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
