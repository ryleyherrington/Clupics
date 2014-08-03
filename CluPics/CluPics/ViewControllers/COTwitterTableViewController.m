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

//SSTwitter framework
#import "STTwitter.h"

@interface COTwitterTableViewController () <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableTweetView;
@property (strong, nonatomic) NSMutableArray *twitterFeed;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) RHDynamicTransition *transition;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (nonatomic, assign) NSInteger lastCount;
@property (nonatomic, assign) CGSize trueContentSize;

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
    [self.parentViewController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    
    self.navigationController.navigationBar.hidden = YES;
    self.searchBar.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self fetchTweets:self.searchBar.text];
    [self.searchBar resignFirstResponder];
}

-(void)fetchTweets:(NSString*)searchString{
    [self fetchTweets:searchString count:30];
}

#pragma mark - Data source retrieval and processing
-(void)fetchTweets:(NSString*)searchString count:(NSUInteger)count
{
    self.lastCount = count;
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey: @"k8WN0dn0q8bxXaBp7DMd4JPkQ" consumerSecret: @"XnUo0RaOM6h0Ut1RWc7eWYE147RdvDHEkSpII1ScB3G3Xk7cwS"];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *username)
     {
         
         [twitter getSearchTweetsWithQuery:searchString
                                   geocode:nil
                                      lang:nil
                                    locale:nil
                                resultType:nil
                                     count:[NSString stringWithFormat:@"%d", count]
                                     until:nil
                                   sinceID:@"421875429965053952"
                                     maxID:nil
                           includeEntities:@(YES)
                                  callback:nil
                              successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                                  
                                  self.twitterFeed = [NSMutableArray arrayWithArray:statuses];
                                  
                                  //reloading data
                                  [self.tableView reloadData];
                                  
                                  NSLog(@"Search data : %@",searchMetadata);
                                  NSLog(@"\n\n Status : %@",statuses);
                                  
                              } errorBlock:^(NSError *error) {
                                  
                                  NSLog(@"%@", error.debugDescription);
                                  
                              }];
         
     } errorBlock:^(NSError *error)
     {
         NSLog(@"%@", error.debugDescription);
     }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.twitterFeed.count){
        return self.twitterFeed.count;
    }
    if(self.searchBar.text.length > 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Tweets Found"
                                                        message:@"Looks like we couldn't find any tweets, try again!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //cell.textLabel.text = [NSString stringWithFormat:@"TableRow:%d, Section:%d", indexPath.row, indexPath.section];
    
    NSInteger idx = indexPath.row;
    NSDictionary *t = self.twitterFeed[idx];
    
    //TODO: Extract user name
    NSLog(@"USER FIELD: %@", t[@"user"]);
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [t[@"user"] objectForKey:@"name"]];
    cell.detailTextLabel.text = t[@"text"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80; //height
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(_twitterFeed.count == 0){
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        return footer;
    }
    /* Creating the footer */
    UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)]; //xpos, ypos, width, height
    footer.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    
    /* Creating button to search Twitter and centering it */
    UIButton *twitterSearch = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2 - 100 ), 15, 200, 50)];
    
    /* Setting button appearance */
    [twitterSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [twitterSearch setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [twitterSearch setTitle:@"Load More" forState:UIControlStateNormal];
    [twitterSearch setTitle:@"Load More" forState:UIControlStateHighlighted];
    
    /* Rounding the corners */
    twitterSearch.layer.cornerRadius = 10.0;
    twitterSearch.clipsToBounds = YES;
    
    //twitterSearch.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    twitterSearch.backgroundColor = [UIColor blueColor];
    
    /* Adding event handler */
    [twitterSearch  addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
    
    [footer addSubview:twitterSearch];
    
    return footer;
}
#pragma mark - Selectors

-(void)loadMore{
    NSLog(@"Load More with count:%d", self.lastCount);
    [self fetchTweets:self.searchBar.text count:self.lastCount+30];
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
