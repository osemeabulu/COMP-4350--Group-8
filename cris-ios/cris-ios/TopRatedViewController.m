//
//  TopRatedViewController.m
//  cris-ios
//
//  Created by Osemekhian Abulu on 2013-03-09.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "AppDelegate.h"
#import "TopRatedViewController.h"
#import "Course.h"
#import "CoursesTableViewController.h"

@interface TopRatedViewController ()

@property (nonatomic,strong) NSMutableArray *topRatedCourses;
@property (nonatomic, strong) NSMutableData *responseData;


@end


@implementation TopRatedViewController

@synthesize topRatedCourses;
@synthesize responseData = _responseData;

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
    
    /*self.topRatedCourses = [NSMutableArray array];
    self.responseData = [NSMutableData data];
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    NSString *urlString = [NSString stringWithFormat:@"%@courses/_top_query", appDel.baseURL];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    //NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"http://dev-umhofers-env-nmsgwpcvru.elasticbeanstalk.com/courses/_top_query?key="]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;*/
}

- (void)viewDidAppear:(BOOL)animated
{
    self.topRatedCourses = [NSMutableArray array];
    self.responseData = [NSMutableData data];
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    NSString *urlString = [NSString stringWithFormat:@"%@courses/_top_query", appDel.baseURL];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    //NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"http://dev-umhofers-env-nmsgwpcvru.elasticbeanstalk.com/courses/_top_query?key="]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
    return self.topRatedCourses.count;
}
- (UIImage *)imageForRating:(int)rating
{
	switch (rating)
	{
		case 1: return [UIImage imageNamed:@"1StarSmall.png"];
		case 2: return [UIImage imageNamed:@"2StarsSmall.png"];
		case 3: return [UIImage imageNamed:@"3StarsSmall.png"];
		case 4: return [UIImage imageNamed:@"4StarsSmall.png"];
		case 5: return [UIImage imageNamed:@"5StarsSmall.png"];
	}
	return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"MainCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRcell"];

    
    //if (cell == nil){
      //  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
    //}
    
    // Configure the cell...
    
    Course *c = [self.topRatedCourses  objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@: %@ star ", c.cid, c.cname, c.cavg];
    
    //cell.textLabel.text = [topRatedCourses objectAtIndex:indexPath.row];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.textLabel.textColor = [UIColor redColor];
    
    UILabel *cidLabel = (UILabel *)[cell viewWithTag:100];
	cidLabel.text = [NSString stringWithFormat:@"%@ - %@", c.cid, c.cname];
	//UILabel *descLabel = (UILabel *)[cell viewWithTag:101];
	//descLabel.text = c.cname;
	UIImageView * ratingImageView = (UIImageView *)
    [cell viewWithTag:102];
	ratingImageView.image = [self imageForRating:c.cavg.intValue];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"TrSegue"]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *ip = [self.tableView indexPathForCell:cell];
        Course *c = [self.topRatedCourses objectAtIndex:ip.row];
        
        CourseDetailViewController *cdv = (CourseDetailViewController *) segue.destinationViewController;
        cdv.course = c;
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse top");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data", [self.responseData length]);
    
    //convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    NSArray *jsonTRCourses = [res objectForKey:@"courses"];
    
    // get each instructors attributes and place them into the array of strings
    for (NSDictionary *result in jsonTRCourses)
    {
        Course *TRcourse = [[Course alloc] initWithCid:[NSString stringWithFormat:@"%@",[result objectForKey:@"cid"]] cname:[NSString stringWithFormat:@"%@",[result objectForKey:@"cname"]] cdesc:[NSString stringWithFormat:@"%@",[result objectForKey:@"cdesc"]] cflty:[NSString stringWithFormat:@"%@",[result objectForKey:@"cflty"]]];
        //NSString *TRcourse = [NSString stringWithFormat:@"%@ - %@", [result objectForKey:@"cid"], [result objectForKey:@"cname"]];
        
        //NSLog([NSString stringWithFormat:@"%@", [result objectForKey:@"avg"]]);
        [TRcourse addAVG:([NSString stringWithFormat:@"%@", [result objectForKey:@"avg"]])];
        
        [self.topRatedCourses addObject:TRcourse];
        
    }
    
    [self.tableView reloadData];
}


@end
