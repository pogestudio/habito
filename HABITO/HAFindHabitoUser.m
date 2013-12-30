//
//  HAFindHabitoUser.m
//  HABITO
//
//  Created by CAwesome on 2013-12-15.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#define kSearchDeay 0.05

#import "HAFindHabitoUser.h"

@implementation HAFindHabitoUser

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom the table
        self.searchText = @"";
        
        // The className to query on
        self.parseClassName = @"_User";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"username";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 30;
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
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //SHOWING ACTIVITY INDICATOR
    self.searchActivitySpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //set frame for activity indicator
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
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    [self.searchActivitySpinner removeFromSuperview];
    [self.searchActivitySpinner stopAnimating];
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    
    NSString *lowerCase = [self.searchText lowercaseString];
    NSString *predicateString = [NSString stringWithFormat:@"username BEGINSWITH '%@' OR search_username BEGINSWITH '%@'", self.searchText, lowerCase];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: predicateString];
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName predicate:predicate];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    
    [query orderByDescending:@"createdAt"];
    
    
    return query;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX([self.objects count], 1);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *objectForCell = nil;
    if ([self.objects count] > 0) {
        objectForCell = [self objectAtIndexPath:indexPath];
    }
    return [self tableView:tableView cellForRowAtIndexPath:indexPath object:objectForCell];
}


// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    if ([self.objects count] > 0) {
        cell.textLabel.text = [object objectForKey:self.textKey];
    } else {
        cell.textLabel.text = @"No user found";
    }
    
    return cell;
}


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */


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
    
    NSAssert([[self objectAtIndexPath:indexPath] isKindOfClass:[PFUser class]],@"Wrong kind of class, expected user in find user!");
    PFUser *chosenUser = (PFUser*)[self objectAtIndexPath:indexPath];
    [self.objectThatWantUser selectedUser:chosenUser];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Search Bar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if ([searchText isEqualToString:@""]) {
        return; //bail out, and dont search, if string is empty
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fetchDataAccordingToSearchInput:) object:searchBar];
    [self performSelector:@selector(fetchDataAccordingToSearchInput:) withObject:searchBar afterDelay:kSearchDeay];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fetchDataAccordingToSearchInput:) object:searchBar];
    [self performSelector:@selector(fetchDataAccordingToSearchInput:) withObject:searchBar afterDelay:kSearchDeay];
    
}


#pragma mark -
#pragma mark Fetching more data to table view
-(void)fetchDataAccordingToSearchInput:(id)sender
{
    NSAssert1([sender isKindOfClass:[UISearchBar class]],@"Something other than searchbar was sent with search",nil);
    UISearchBar *searchBar = (UISearchBar*)sender;
    self.searchText = searchBar.text;
    NSLog(@"will search for username:: %@", self.searchText);
    [searchBar addSubview:self.searchActivitySpinner];
    [self positionActivitySpinner:self.searchActivitySpinner inSearchBar:searchBar];
    [self.searchActivitySpinner startAnimating];
    [self loadObjects];
}

-(void)positionActivitySpinner:(UIActivityIndicatorView*)spinner inSearchBar:(UISearchBar*)searchBar
{
    CGFloat SEARCH_BAR_SPINNER_WIDTH_INDENTATION = 40;
    //get the uiview of the searchbar
    CGSize searchBarSize = searchBar.frame.size;
    //get the height and width of the spinner
    CGSize spinnerSize = spinner.frame.size;
    
    //put it at the right edge fo the searchbar
    CGFloat spinnerX;
    CGFloat spinnerY;
    
    spinnerX = searchBarSize.width;
    
    //indent it X width, plus the width fo the spinner
    
    spinnerX-= spinnerSize.width;
    spinnerX-= SEARCH_BAR_SPINNER_WIDTH_INDENTATION;
    
    //put it in the middle of the searchbar
    
    spinnerY = (searchBarSize.height - spinnerSize.height)/2.0;
    
    //Create new frame!
    CGRect newSpinnerFrame = CGRectMake(spinnerX, spinnerY, spinnerSize.width, spinnerSize.height);
    spinner.frame = newSpinnerFrame;
}

@end