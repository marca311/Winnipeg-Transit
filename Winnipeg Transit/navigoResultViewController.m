//
//  navigoResultViewController.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-30.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "navigoResultViewController.h"
#import "MSUtilities.h"
#import "MSTableViewCell.h"
#import "navigoViewLibrary.h"
#import "PlanSelectorTableVew.h"
#import "navigoInterpreter.h"

NSDictionary *resultDictionary;

@implementation navigoResultViewController

@synthesize resultsTable;
@synthesize planButton;
@synthesize resultsArray, planArray;
@synthesize planField,numPlans,planSelectorTable;

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
    [super viewDidLoad];
    resultDictionary = [MSUtilities loadDictionaryWithName:currentFile];
    planArray = [navigoInterpreter makeHumanReadableResults:resultDictionary];;
    resultsArray = [planArray objectAtIndex:0];
    numPlans.text = [NSString stringWithFormat:@"%i",[planArray count]];
	//put in the table loading methods and data loading too.
    
    //PlanSelectorTableVew *tester = [[PlanSelectorTableVew alloc]init];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resultsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *contentForThisRow = [[self resultsArray] objectAtIndex:[indexPath row]];
    NSString *uniqueIdentifier = @"CellIdentifier";
    MSTableViewCell *cell = nil;
    cell = (MSTableViewCell *) [self.resultsTable dequeueReusableCellWithIdentifier:uniqueIdentifier];
    if(cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"MSTableViewCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (MSTableViewCell *)currentObject;
                break;
            }
        }
    }
        
    cell.textView.text = [contentForThisRow objectAtIndex:1];
    cell.time.text = [navigoViewLibrary sendTime:contentForThisRow];

    return cell;
}

- (void)tableView:(UITableView *)tableView:didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"Clicked table entry");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //textField = planField;
    if (![planField.text isEqual:@""]) {
        resultsArray = [planArray objectAtIndex:([planField.text intValue] - 1)];
        [resultsTable reloadData];
        NSLog(planField.text);
    }
}

-(IBAction)reloadTable
{
    [self resignFirstResponder];
    resultsArray = [planArray objectAtIndex:[planField.text intValue]];
    [resultsTable reloadData];
    NSLog(planField.text);
}

-(IBAction)planButtonPress
{
    if ([planSelectorTable isUserInteractionEnabled] == NO) {
        [planSelectorTable setDataSourceArray:resultDictionary];
        planSelectorTable = [[PlanSelectorTableVew alloc]initWithFrameFromButton:planButton];
        [planSelectorTable showAndAnimate:self.view:resultDictionary];
    }
}

-(IBAction)closePlans
{
    if (planSelectorTable != nil) {
        [planSelectorTable removeFromSuperview];
        planSelectorTable = nil;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
