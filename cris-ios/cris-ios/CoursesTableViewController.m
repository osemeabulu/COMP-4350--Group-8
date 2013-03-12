//
//  CoursesTableViewController.m
//  cris-ios
//
//  Created by Rory Finnegan on 2013-03-09.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "CoursesTableViewController.h"
#import "Course.h"

@interface CoursesTableViewController ()

@property (nonatomic, strong) NSMutableArray *courses;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation CoursesTableViewController

@synthesize courses;
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
    NSLog(@"viewdidload");
    self.courses = [NSMutableArray array];
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"http://dev-umhofers-env-nmsgwpcvru.elasticbeanstalk.com/courses/_query?key="]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [super viewDidLoad];
    /*
    self.courses = @[@"Comp4350 - Software Engineering 2",
                     @"Comp3430 - Operating Systems 1",
                     @"Comp4380 - Database Implementation",
                     @"Comp2150 - Object Orientation"];
     */
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"CourseDetailSegue"]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *ip = [self.tableView indexPathForCell:cell];
        Course *c = [self.courses objectAtIndex:ip.row];
        
        CourseDetailViewController *cdv = (CourseDetailViewController *) segue.destinationViewController;
        cdv.course = c;
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }

    Course *c = [self.courses objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", c.cid, c.cname];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.textLabel.text = [self.courses objectAtIndex:indexPath.row];
    
       
    return cell;
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
    
     //CourseDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseDetailViewController"];
    //[[CourseDetailViewController alloc] initWithNibName:@"detailViewController" bundle:[NSBundle mainBundle]];
     // ...
     // Pass the selected object to the new view controller.
     //[self presentViewController:detailViewController animated:YES completion:nil];
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
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
    
    NSArray *jsonCourses = [res objectForKey:@"courses"];
    
    // get each courses attributes and place them into the array of strings
    for (NSDictionary *result in jsonCourses)
    {
        Course *course = [[Course alloc] initWithCid:[NSString stringWithFormat:@"%@",[result objectForKey:@"cid"]] cname:[NSString stringWithFormat:@"%@",[result objectForKey:@"cname"]] cdesc:[NSString stringWithFormat:@"%@",[result objectForKey:@"cdesc"]] cflty:[NSString stringWithFormat:@"%@",[result objectForKey:@"cflty"]]];
        //NSString *course = [NSString stringWithFormat:@"%@ - %@", [result objectForKey:@"cid"], [result objectForKey:@"cname"]];
        
        [self.courses addObject:course];
        
    }
    
    
    [self.tableView reloadData];
}
@end
