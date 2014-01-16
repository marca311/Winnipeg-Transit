//
//  PlaceViewController.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-12-01.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLocation.h"

@protocol SearchHistoryDelegate

-(void)userDidSelectLocation:(MSLocation *)location;

@end

@interface SearchHistoryView : UIView {
    __weak id <SearchHistoryDelegate> delegate;
}

@property (nonatomic, weak) id <SearchHistoryDelegate> delegate;

-(IBAction)editTable;

#pragma mark - File Handling methods

-(void)saveFile;
-(void)addLocation:(NSString *)locationName :(NSString *)locationKey;
-(void)removeLocation:(NSIndexPath *)index;
+(void)clearLocations;
-(void)moveEntry:(NSIndexPath *)currentIndex :(NSIndexPath *)proposedIndex;
-(void)changeSavedName:(NSString *)index :(NSString *)newName;
//Static method for adding entries
+(void)addEntryToFile:(MSLocation *)item;
+(NSMutableArray *)checkNumberOfEntries:(NSArray *)theArray;

@end
