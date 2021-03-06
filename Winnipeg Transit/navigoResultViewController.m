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
#import "VariationSelectorTableVew.h"

NSDictionary *resultDictionary;

@implementation navigoResultViewController

@synthesize currentFile;
@synthesize resultsTable;
@synthesize planButton;

-(id)initWithMSRoute:(MSRoute *)route {
    routeData = route;
    self = [super initWithNibName:@"NavigoResults_iPhone" bundle:[NSBundle mainBundle]];
    return self;
}

-(void)setRoute:(MSRoute *)theRoute {
    routeData = theRoute;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentVariation = 0;
    variationData = [routeData getVariationFromIndex:currentVariation];
    //planList = [navigoInterpreter planListMaker:resultDictionary];
    self.buses.text = [variationData getBuses];
    self.startTime.text = [variationData getStartTime];
    self.endTime.text = [variationData getEndTime];
    
    //Add plan table to view
    variationTable = [[VariationDisplayTableViewController alloc]initWithCorrectFrame:variationData];
    [variationTable showTable:self.view];
}

-(IBAction)planButtonPress
{
    if ([variationSelectorTable.tableView isUserInteractionEnabled] == NO) {
        variationSelectorTable = [[VariationSelectorTableVew alloc]initWithFrameFromButton:planButton];
        variationSelectorTable.tableView.delegate = self;
        [variationSelectorTable showAndAnimate:self.view Route:routeData];
    } else {
        [variationSelectorTable closeAndAnimate];
        variationSelectorTable = nil;
    }
}

-(IBAction)closePlans
{
    if (variationSelectorTable != nil) {
        [variationSelectorTable closeAndAnimate];
        variationSelectorTable = nil;
    }
}

-(void)changePlanSelectorArray:(int)arrayNumber
{
    variationData = [routeData getVariationFromIndex:currentVariation];
    self.buses.text = [variationData getBuses];
    self.startTime.text = [variationData getStartTime];
    self.endTime.text = [variationData getEndTime];
}//changePlanSelectorArray

- (void)viewDidUnload
{
    currentFile = NULL;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentVariation = indexPath.row;
    [self changePlanSelectorArray:currentVariation];
    [variationTable changeTableVariation:variationData];
    [variationSelectorTable.tableView removeFromSuperview];
    variationSelectorTable = nil;
    NSIndexPath *topIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [variationTable.tableView scrollToRowAtIndexPath:topIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    else return NO;
    //TODO: Add call to work with iOS6 and orientations
}

@end
