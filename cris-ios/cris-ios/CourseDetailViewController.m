//
//  CourseDetailViewController.m
//  cris-ios
//
//  Created by Osemekhian Abulu on 2013-03-10.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "Review.h"

@interface CourseDetailViewController ()
@property (nonatomic, strong) NSMutableArray *reviews;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation CourseDetailViewController

@synthesize courseIdLabel, courseNameLabel, courseDescriptionLabel, averageRatingLabel, facultyLabel, course;

@synthesize reviewList;
@synthesize reviews;
@synthesize responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //courseNameLabel =
        //courseDescriptionLabel.text=
        //averageRatingLabel.text=
        //facultyLabel.text=
    }
    return self;
}

- (void)viewDidLoad
{
    self.reviewList.delegate = self;
    self.reviewList.dataSource = self;
	self.courseIdLabel.text= self.course.cid;
    self.courseNameLabel.text = self.course.cname;
    self.courseDescriptionLabel.text = self.course.cdesc;
    self.facultyLabel.text = self.course.cflty;
    
    self.reviews = [NSMutableArray array];
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString: [NSString stringWithFormat: @"http://cris-release-env-przrapykha.elasticbeanstalk.com/reviews/_query_by_course?key=%@", self.course.cid]]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ReviewSegue"]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *ip = [self.reviewList indexPathForCell:cell];
        Review *r = [self.reviews objectAtIndex:ip.row];
        
        ReviewViewController *rvc = (ReviewViewController *) segue.destinationViewController;
        rvc.review = r;
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.reviews count];
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
    NSLog(@"Loading cell");
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    //Course *c = [self.reviews objectAtIndex:indexPath.row];
    
    Review *r = [self.reviews objectAtIndex:indexPath.row];
    
    NSRange textRange = [r.username rangeOfString:@"null"];
    if (textRange.location != NSNotFound)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"N/A"];
    }
    
    else
    {
        cell.textLabel.text = r.username;
    }
    
    cell.detailTextLabel.text = r.rdesc;
    cell.imageView.image = [self imageForRating:r.rscr.intValue];
    //cell.textLabel.text = [self.reviews objectAtIndex:indexPath.row];
    //cell.textLabel.font = [UIFont fontWithName: @"Arial" size: 14.0];
    
    
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
    
    NSArray *jsonCourses = [res objectForKey:@"reviews"];
    
    // get each courses attributes and place them into the array of strings
    for (NSDictionary *result in jsonCourses)
    {
        //Course *course = [[Course alloc] initWithCid:[NSString stringWithFormat:@"%@",[result objectForKey:@"cid"]] cname:[NSString stringWithFormat:@"%@",[result objectForKey:@"cname"]] cdesc:[NSString stringWithFormat:@"%@",[result objectForKey:@"cdesc"]] cflty:[NSString stringWithFormat:@"%@",[result objectForKey:@"cflty"]]];
        Review *review = [[Review alloc] initWithCid: [NSString stringWithFormat:@"%@", [result objectForKey:@"cid"]] username: [NSString stringWithFormat:@"%@", [result objectForKey:@"username"]] rdesc: [NSString stringWithFormat:@"%@", [result objectForKey:@"rdesc"]] rscr: [NSString stringWithFormat:@"%@", [result objectForKey:@"rscr"]]];
        
        //NSString *review = [NSString stringWithFormat:@"%@ (%@)", [result objectForKey:@"rdesc"], [result objectForKey:(@"rscr")]];
        
        [self.reviews addObject:review];
        
    }
    
    
    [self.reviewList reloadData];
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)seeReviewButton:(id)sender {
}

- (IBAction)createReviewButton:(id)sender {
}
@end
