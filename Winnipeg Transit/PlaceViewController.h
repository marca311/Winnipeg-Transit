//
//  PlaceViewController.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-12-01.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversalViewController.h"

@interface PlaceViewController : UniversalViewController <UITableViewDataSource,UITableViewDelegate> {
    UITableView *theTableView;
    UIBarButtonItem *editButton;
    NSMutableArray *savedLocations;
    NSMutableArray *previousLocations;
    BOOL fileExists;
}

-(IBAction)editTable;

#pragma mark - File Handling methods

-(void)saveFile;
-(void)addLocation:(NSString *)locationName :(NSString *)locationKey;
-(void)removeLocation:(NSIndexPath *)index;
+(void)clearLocations;
-(void)moveEntry:(NSIndexPath *)currentIndex :(NSIndexPath *)proposedIndex;
-(void)changeSavedName:(NSString *)index :(NSString *)newName;
//Static method for adding entries
+(void)addEntryToFile:(NSArray *)item;
+(NSMutableArray *)checkNumberOfEntries:(NSArray *)theArray;

@end
