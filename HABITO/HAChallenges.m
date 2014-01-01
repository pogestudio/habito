//
//  HAChallenges.m
//  HABITO
//
//  Created by CAwesome on 2013-12-14.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HAChallenges.h"
#import "HAParseLoginSignupHandler.h"
#import "HAChallengeCell.h"
#import "HAViewChallenge.h"
#import "NSDate-Utilities.h"
#import "HAAppDelegate.h"
#import "HAChallengeRequestHandler.h"
#import "HATutorialVC.h"

@interface HAChallenges()
@property (nonatomic, retain) NSMutableDictionary *sections;
@property (nonatomic, retain) NSMutableDictionary *sectionToDateMap;
@property (nonatomic, retain) NSDateFormatter *sectionFormatter;
@end

@implementation HAChallenges


- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Challenge";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        self.objectsPerPage = 100;
        
        self.sections = [[NSMutableDictionary alloc] init];
        self.sectionToDateMap = [[NSMutableDictionary alloc] init];
        self.sectionFormatter = [[NSDateFormatter alloc] init];
        [self.sectionFormatter setDateFormat:@"dd-MM"];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    ((HAAppDelegate*)[UIApplication sharedApplication].delegate).challengeQueryTBVC = self;
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([HATutorialVC shouldShowTutorialView]) {
        HATutorialVC *tutVC = [self.storyboard instantiateViewControllerWithIdentifier:[HATutorialVC storyBoardId]];
        [self presentViewController:tutVC animated:YES completion:nil];
    } else {
        //do it with delay to handle unbalanced transitions.
        [[HAParseLoginSignupHandler sharedHandlerpresentFromView:self] performSelector:@selector(makeSureUserIsLoggedIn) withObject:Nil afterDelay:0.0];
    }
    if ([PFUser currentUser]) {
        [self.navigationItem setTitle:[PFUser currentUser].username];
    }
    //    [self performSelector:@selector(loadObjects) withObject:Nil afterDelay:0.5];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    [self loadObjects];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    //ask for challenge requests. placed here because it might be fired from different sources
    if ([PFUser currentUser]) {
        [[HAChallengeRequestHandler sharedHandler] loadRequestsAndPopInView];
    }
    
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    //NSLog(@"challenges did load.. %lu", (unsigned long)[self.objects count]);
    
    [self subscribeToAllOfUsersGoals];
    
    [self.sections removeAllObjects];
    [self.sectionToDateMap removeAllObjects];
    
    
    
    //update nextplanned date
    for (HAChallenge *object in self.objects) {
        
        [object updatePropertiesToMatchNextDueDate];
        
    }
    
    //sort according to next planned date
    self.challenges = [self.objects sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(PFObject*)a objectForKey:@"nextPlannedDay"];
        NSDate *second = [(PFObject*)b objectForKey:@"nextPlannedDay"];
        return [first compare:second];
    }];
    
    //handle sections!
    int section = 0;
    int rowIndex = 0;
    for (HAChallenge *object in self.challenges) {
        
        NSDate *date = [object objectForKey:@"nextPlannedDay"];
        date  = [date dateAtStartOfDay];
        NSMutableArray *objectsInSection = [self.sections objectForKey:date];
        if (!objectsInSection) {
            objectsInSection = [NSMutableArray array];
            
            // this is the first time we see this date - increment the section index
            [self.sectionToDateMap setObject:date forKey:[NSNumber numberWithInt:section++]];
        }
        
        [objectsInSection addObject:[NSNumber numberWithInt:rowIndex++]];
        [self.sections setObject:objectsInSection forKey:date];
    }
    [self.tableView reloadData];
}

-(void)subscribeToAllOfUsersGoals
{
    //SUBSCRIBE TO ALL OF YOUR GOALS!!
    //only saves when it needs to - if nothing new wont save.
    
    NSMutableArray *channelsUserShouldBeSubscribedTo = [NSMutableArray arrayWithCapacity:[self.challenges count]];
    for (HAChallenge *aChallenge in self.challenges) {
        [channelsUserShouldBeSubscribedTo addObject:[aChallenge channelName]];
    }
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObjectsFromArray:channelsUserShouldBeSubscribedTo forKey:@"channels"];
    [currentInstallation saveInBackground];
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    if (![PFUser currentUser]) {
        return [PFQuery queryWithClassName:@"LOLRANDOMSHIT"];
    }
    PFQuery *ownerQuery = [PFQuery queryWithClassName:self.parseClassName];
    [ownerQuery whereKey:@"owner" equalTo:[PFUser currentUser]];
    [ownerQuery whereKey:@"isActive" equalTo:@YES];
    
    PFQuery *challengedQuery = [PFQuery queryWithClassName:self.parseClassName];
    [challengedQuery whereKey:@"challenged" equalTo:[PFUser currentUser]];
    [challengedQuery whereKey:@"isActive" equalTo:@YES];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[ownerQuery,challengedQuery]];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"nextPlannedDay"];
    [query includeKey:@"challenged"];
    [query includeKey:@"owner"];
    
    return query;
}


// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"ChallengeCell";
    
    HAChallengeCell *cell = (HAChallengeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSAssert(cell != nil, @"cell is nill. wtf is up with sotryboarasdasdadsad lol");
    
    // Configure the cell
    HAChallenge *theChallenge = (HAChallenge*)object;
    [theChallenge updatePropertiesToMatchNextDueDate];
    [cell setUpForObject:theChallenge];
    
    return cell;
}


// Override if you need to change the ordering of objects in the table.
- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"indexpath: %@", indexPath);
    
    NSDate *date = [self dateForSection:indexPath.section];
    
    NSArray *rowIndecesInSection = [self.sections objectForKey:date];
    
    NSNumber *rowIndex = [rowIndecesInSection objectAtIndex:indexPath.row];
    return [self.challenges objectAtIndex:[rowIndex intValue]];
}


/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - UITableViewDataSource

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}


#pragma mark Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ViewChallenge"]) {
        
        HAChallenge *chosenObject = (HAChallenge*)[self objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        
        HAViewChallenge *viewChallengeVC = (HAViewChallenge*)segue.destinationViewController;
        viewChallengeVC.theChallenge = chosenObject;
    }
    
}

#pragma mark SECTIONS
- (NSDate *)dateForSection:(NSInteger)section {
    return [self.sectionToDateMap objectForKey:[NSNumber numberWithLong:section]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (![PFUser currentUser]) {
        return 0;
    }
    return self.sections.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDate *date = [self dateForSection:section];
    NSArray *rowIndecesInSection = [self.sections objectForKey:date];
    return rowIndecesInSection.count;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *theDate = [self dateForSection:section];
    NSString *sectionString;
    if([theDate isToday])
    {
        sectionString = @"Today";
    } else if([theDate isTomorrow])
    {
        sectionString = @"Tomorrow";
    } else {
        sectionString = [theDate descriptionOfDateAsMonthAndDay];
    }
    return sectionString;
}
@end