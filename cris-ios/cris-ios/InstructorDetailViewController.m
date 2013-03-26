//
//  InstructorDetailViewController.m
//  cris-ios
//
//  Created by ian on 2013-03-25.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "InstructorDetailViewController.h"
#import "AppDelegate.h"
#import "Course.h"

@interface InstructorDetailViewController ()

@property (nonatomic, strong) NSMutableData *responseData;
@end

@implementation InstructorDetailViewController
@synthesize instructor;
@synthesize courses;
@synthesize responseData;
@synthesize instructorLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [self.instructorLabel setText: instructor];
    self.courses = [NSMutableArray array];
    self.responseData = [NSMutableData data];
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];

    NSString *urlString = [NSString stringWithFormat:@"%@courses/_query_by_instructor?key=%@", appDel.baseURL, instructor];
    NSLog(@"%@", urlString);
    NSString* encodedUrl =[urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"%@", encodedUrl);
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:encodedUrl]];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
    //NSLog(@"Loaded Course List Table");
    static NSString *CellIdentifier = @"InstructorCourseCell";
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
        NSLog(course.cid);
        [self.courses addObject:course];
        
    }
    
    [self.instructorsTableView reloadData];
    
}


@end
