//
//  PlanDisplayTableViewController.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-09-27.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "VariationDisplayTableViewController.h"

@interface VariationDisplayTableViewController ()

@end

@implementation VariationDisplayTableViewController

@synthesize currentArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCorrectFrame:(MSVariation *)theVariation
{
    self = [[VariationDisplayTableViewController alloc]init];
    CGRect theFrame;
    theFrame.origin.x = 20;
    theFrame.origin.y = 104;
    theFrame.size.width = 280;
    theFrame.size.height = 336;
    self.tableView = [self.tableView init];
    self.tableView.frame = theFrame;
    self.tableView.rowHeight = 68;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = nil;

    variationData = theVariation;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    return self;
}//initAndShowWithCorrectFrame

-(void)showTable:(UIView *)theView
{
    [theView addSubview:self.tableView];
}//showTable

-(void)changeTablePlan:(MSVariation *)theVariation
{
    variationData = theVariation;
    [self.tableView reloadData];
}//changeTablePlan

-(UIImage *)useCorrectImage:(NSArray *)theArray {
    NSString *segmentType = [theArray objectAtIndex:0];
    if ([segmentType isEqualToString:@"ride"]) {
        UIImage *result = [[UIImage alloc]initWithContentsOfFile:@"ride.png"];
        return result;
    } else if ([segmentType isEqualToString:@"monument"]) {
        UIImage *result = [[UIImage alloc]initWithContentsOfFile:@"monument.gif"];
        return result;
    } else if ([segmentType isEqualToString:@"stop"]) {
        UIImage *result = [[UIImage alloc]initWithContentsOfFile:@"stop.png"];
        return result;
    } else if ([segmentType isEqualToString:@"transfer"]) {
        UIImage *result = [[UIImage alloc]initWithContentsOfFile:@"transfer.png"];
        return result;
    } else {
        return NULL;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
} */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [currentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    MSSegment *segmentData = [variationData getSegmentAtIndex:[indexPath row]];
    NSString *uniqueIdentifier = @"CellIdentifier";
    MSTableViewCell *cell = nil;
    cell = (MSTableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    if(cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"MSTableViewCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects) {
            if([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (MSTableViewCell *)currentObject;
                break;
            }
        }
    }
    
    cell.textView.backgroundColor = [UIColor clearColor];
    cell.textView.opaque = NO;
    
    cell.textView.text = [segmentData getHumanReadable];
    cell.time.text = [segmentData get];
    cell.image.image = [self useCorrectImage:contentForThisRow];
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
