//
//  RHFeedViewController.m
//  CluPics
//
//  Created by Ryley Herrington on 3/2/14.
//  Copyright (c) 2014 Ryley Herrington. All rights reserved.
//

#import "RHFeedViewController.h"
#import "RHFeed.h"

@interface RHFeedViewController ()

@end

@implementation RHFeedViewController

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

    [self parseJson];
}

-(NSArray *)parseFeed{
   
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=jadoon88"]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell setTitle:@"HEY"];
    return cell;
}

/*
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}
*/

@end
