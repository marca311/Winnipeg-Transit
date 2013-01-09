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
}

@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, retain) NSMutableArray *savedLocations;
@property (nonatomic, retain) NSMutableArray *previousLocations;

-(IBAction)editTable;

#pragma mark - File Handling methods

-(void)saveFile;
-(void)addLocation:(NSString *)locationName :(NSString *)locationKey;
-(void)removeLocation:(NSIndexPath *)index;
-(void)moveEntry:(NSIndexPath *)currentIndex :(NSIndexPath *)proposedIndex;
-(void)changeSavedName:(NSString *)index :(NSString *)newName;
//Static method for adding entries
+(void)addEntryToFile:(NSString *)locationName :(NSString *)locationKey;
//Static method to create a blank file on first run
+(void)createBlankFile;

@end
