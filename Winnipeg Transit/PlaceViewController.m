//
//  PlaceViewController.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-12-01.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "PlaceViewController.h"
#import "MSUtilities.h"
#import "AnimationInstructionSheet.h"

@interface PlaceViewController ()

@end

@implementation PlaceViewController

- (void)loadPlaceDictionary:(UIView *)superView {
    
}

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
    fileExists = [MSUtilities fileExists:@"SearchHistory.plist"];
    if (fileExists) {
        //Load Dictionary
        NSDictionary *theFile = [MSUtilities loadDictionaryWithName:@"SearchHistory"];
        //Convert NSData in dictionary into the NSArray filled with MSLocations
        NSData *savedData = [theFile objectForKey:@"SavedLocations"];
        savedLocations = [NSKeyedUnarchiver unarchiveObjectWithData:savedData];
        //Ditto
        NSData *previousData = [theFile objectForKey:@"PreviousLocations"];
        previousLocations = [NSKeyedUnarchiver unarchiveObjectWithData:previousData];
        previousLocations = [PlaceViewController checkNumberOfEntries:previousLocations];
        [self saveFile];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 2; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Saved Locations";
    } else {
        return @"Location History";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if ([savedLocations count] == 0) return @"No saved locations";
    } else {
        if ([previousLocations count] == 0) return @"No history";
    }
    return NULL;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self moveEntry:sourceIndexPath :destinationIndexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (fileExists) {
        if (section == 0) {
            return [savedLocations count];
        } else if (section == 1) {
            return [previousLocations count];
        }
    } else return 1;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        cell.showsReorderControl = true;
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        MSLocation *currentLocation = [savedLocations objectAtIndex:row];
        cell.textLabel.text = [currentLocation getHumanReadable];
    } else if (section == 1) {
        MSLocation *currentLocation = [previousLocations objectAtIndex:row];
        cell.textLabel.text = [currentLocation getHumanReadable];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeLocation:indexPath];
        
        if ([tableView numberOfRowsInSection:indexPath.section] == 1) {
            [tableView reloadData];
            [tableView setEditing:false animated:true];
            [editButton setTitle:@"Edit"];
            [editButton setStyle:UIBarButtonItemStyleBordered];
        } else [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Load the parent view controller with compatability
    navigoViewController *theParentViewController;
    if ([MSUtilities firmwareIsHigherThanFour]) {
        theParentViewController = ((navigoViewController *)self.presentingViewController);
    } else {
        theParentViewController = ((navigoViewController *)self.parentViewController);
    }
    //Get info from correct array
    MSLocation *currentLocation;
    if (indexPath.section == 0) {
        currentLocation = [savedLocations objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        currentLocation = [previousLocations objectAtIndex:indexPath.row];
    }
    int stage = [theParentViewController.submitButton checkCurrentLocation];
    if (stage == 1) {
        //Part of old structure, needs to be replaced
        //[queriedDictionary setObject:chosenArray forKey:@"origin"];
        [theParentViewController.originLabel setTitle:[currentLocation getHumanReadable] forState:UIControlStateNormal];
    } else if (stage == 2) {
        //Part of old structure, needs to be replaced
        //[queriedDictionary setObject:chosenArray forKey:@"destination"];
        [theParentViewController.destinationLabel setTitle:[currentLocation getHumanReadable] forState:UIControlStateNormal];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        //[theParentViewController fieldChecker];
        [AnimationInstructionSheet toNextStage:theParentViewController];
    });
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)editTable {
    if (theTableView.editing == false) {
        [theTableView setEditing:true animated:true];
        [editButton setTitle:@"Done"];
        [editButton setStyle:UIBarButtonItemStyleDone];
    } else {
        [theTableView setEditing:false animated:true];
        [editButton setTitle:@"Edit"];
        [editButton setStyle:UIBarButtonItemStyleBordered];
        [self saveFile];
    }
}

#pragma mark - File handling methods

-(void)saveFile {
    NSMutableDictionary *theDictionary = [[NSMutableDictionary alloc]init];
    NSData *saved = [NSKeyedArchiver archivedDataWithRootObject:savedLocations];
    [theDictionary setObject:saved forKey:@"SavedLocations"];
    NSData *previous = [NSKeyedArchiver archivedDataWithRootObject:previousLocations];
    [theDictionary setObject:previous forKey:@"PreviousLocations"];
    [MSUtilities saveDictionaryToFile:theDictionary FileName:@"SearchHistory"];
}
-(void)addLocation:(NSString *)locationName :(NSString *)locationKey {
    
}
-(void)removeLocation:(NSIndexPath *)index {
    NSInteger section = index.section;
    NSInteger row = index.row;
    switch (section) {
        case 0:
            [savedLocations removeObjectAtIndex:row];
            break;
        case 1:
            [previousLocations removeObjectAtIndex:row];
            break;
    }
}

+(void)clearLocations {
    NSArray *savedLocationsList = [[NSArray alloc]init];
    NSArray *previousLocationsList = [[NSArray alloc]init];
    if ([MSUtilities fileExists:@"SearchHistory.plist"]) {
        NSDictionary *file = [[NSDictionary alloc]init];
        file = [MSUtilities loadDictionaryWithName:@"SearchHistory"];
        savedLocationsList = [file objectForKey:@"SavedLocations"];
    }
    NSMutableDictionary *saver = [[NSMutableDictionary alloc]init];
    [saver setObject:savedLocationsList forKey:@"SavedLocations"];
    [saver setObject:previousLocationsList forKey:@"PreviousLocations"];
    [MSUtilities saveDictionaryToFile:saver FileName:@"SearchHistory"];
}
-(void)moveEntry:(NSIndexPath *)currentIndex :(NSIndexPath *)proposedIndex {
    NSInteger firstSection = currentIndex.section;
    NSInteger firstRow = currentIndex.row;
    NSInteger secondSection = proposedIndex.section;
    NSInteger secondRow = proposedIndex.row;
    if (firstSection == 0) {
        if (secondSection == 0) {
            NSArray *currentItem = [savedLocations objectAtIndex:firstRow];
            [savedLocations removeObjectAtIndex:firstRow];
            if ([savedLocations count] == 0) {
                savedLocations = [[NSMutableArray alloc]initWithObjects:currentItem, nil];
            } else [savedLocations insertObject:currentItem atIndex:secondRow];
        } else if (secondSection == 1) {
            NSArray *currentItem = [savedLocations objectAtIndex:firstRow];
            [savedLocations removeObjectAtIndex:firstRow];
            if ([previousLocations count] == 0) {
                previousLocations = [[NSMutableArray alloc]initWithObjects:currentItem, nil];
            } else [previousLocations insertObject:currentItem atIndex:secondRow];
        }
    } else if (firstSection == 1) {
        if (secondSection == 0) {
            NSArray *currentItem = [previousLocations objectAtIndex:firstRow];
            [previousLocations removeObjectAtIndex:firstRow];
            if ([savedLocations count] == 0) {
                savedLocations = [[NSMutableArray alloc]initWithObjects:currentItem, nil];
            } else [savedLocations insertObject:currentItem atIndex:secondRow];
        } else if (secondSection == 1) {
            NSArray *currentItem = [previousLocations objectAtIndex:firstRow];
            [previousLocations removeObjectAtIndex:firstRow];
            if ([previousLocations count] == 0) {
                previousLocations = [[NSMutableArray alloc]initWithObjects:currentItem, nil];
            } else [previousLocations insertObject:currentItem atIndex:secondRow];
        }
    }
    [theTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
    [self saveFile];
}
-(void)changeSavedName:(NSIndexPath *)index :(NSString *)newName {
    
}

#pragma mark - Static methods
//Static method for adding entries
+(void)addEntryToFile:(MSLocation *)item {
    NSArray *savedLocationsList = [[NSArray alloc]init];
    NSMutableArray *previousLocationsList = [[NSMutableArray alloc]init];
    if ([MSUtilities fileExists:@"SearchHistory.plist"]) {
        NSDictionary *file = [[NSDictionary alloc]init];
        file = [MSUtilities loadDictionaryWithName:@"SearchHistory"];
        savedLocationsList = [file objectForKey:@"SavedLocations"];
        previousLocationsList = [file objectForKey:@"PreviousLocations"];
    }
    
    //Checks for duplicate entries
    BOOL placed = NO;
    NSString *key = [item getKey];
    for (MSLocation * location in savedLocationsList) {
        //This system uses keys to check for dupes
        NSString *checkKey = [location getKey];
        //Check if location is currently saved locations list
        if ([key isEqualToString:checkKey]) {
            //If it is, remove all occurances from previous locations (if any)
            [previousLocationsList removeObject:item];
            [previousLocationsList removeObject:location];
            //If previous locations list is empty, make it and add the item as the first entry
            if ([previousLocationsList count] == 0) {
                previousLocationsList = [[NSMutableArray alloc]initWithObjects:item, nil];
            } else {
                //If previous locations list exists, just put the entry at the top of the previous locations list
                [previousLocationsList insertObject:item atIndex:0];
            }
            placed = YES;
        }
    }
    for (MSLocation * location  in previousLocationsList) {
        NSString *checkKey = [location getKey];
        if ([key isEqualToString:checkKey]) {
            [previousLocationsList removeObject:item];
            [previousLocationsList insertObject:item atIndex:0];
            placed = YES;
        }
    }
    
    //If the location was not in location history at all (placed == NO), then add it to the list
    if (!placed) {
        if ([previousLocationsList count] == 0) {
            //Make previous locations list if it does not exist
            previousLocationsList = [[NSMutableArray alloc]initWithObjects:item, nil];
        } else {
            //Just add it if the list does exist
            [previousLocationsList insertObject:item atIndex:0];
        }
    }
    
    //Makes sure there are 20 or fewer entries in the previous locations list
    previousLocationsList = [PlaceViewController checkNumberOfEntries:previousLocationsList];
    NSMutableDictionary *saver = [[NSMutableDictionary alloc]init];
    //Converts array of MSLocations to data file
    NSData *saved = [NSKeyedArchiver archivedDataWithRootObject:savedLocationsList];
    [saver setObject:saved forKey:@"SavedLocations"];
    //Ditto
    NSData *previous = [NSKeyedArchiver archivedDataWithRootObject:previousLocationsList];
    [saver setObject:previous forKey:@"PreviousLocations"];
    [MSUtilities saveDictionaryToFile:saver FileName:@"SearchHistory"];
}
//Checks to see if there are over 20 entries in search history, if there are, it removes extras.
+(NSMutableArray *)checkNumberOfEntries:(NSMutableArray *)theArray {
    if ([theArray count] > 20) {
        for (int i = ([theArray count]-1); i > 19; i--) {
            [theArray removeObjectAtIndex:i];
        }
    }
    return theArray;
}

@end
