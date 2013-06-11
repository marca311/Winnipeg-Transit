//
//  MSSavedTrip.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSQuery.h"
#import "apiKeys.h"
#import "PlaceViewController.h"

@implementation MSQuery

-(void)setOrigin:(MSLocation *)input {
    origin = input;
}
-(void)setDestination:(MSLocation *)input {
    destination = input;
}
-(void)setDate:(NSDate *)input {
    date = input;
}
-(void)setMode:(NSString *)input {
    mode = input;
}
-(void)setEasyAccess:(NSString *)input {
    easyAccess = input;
}
-(void)setWalkSpeed:(NSString *)input {
    walkSpeed = input;
}
-(void)setMaxWalkTime:(NSString *)input {
    maxWalkTime = input;
}
-(void)setMinTransferWaitTime:(NSString *)input {
    minTransferWaitTime = input;
}
-(void)setMaxTransferWaitTime:(NSString *)input {
    maxTransferWaitTime = input;
}
-(void)setMaxTransfers:(NSString *)input {
    maxTransfers = input;
}

-(NSString *)getOriginString {
    return [origin getHumanReadable];
}
-(NSString *)getDestinationString {
    return [destination getHumanReadable];
}

//Adds origin and destination entries to Search History
-(void)addEntriesToHistory {
    [PlaceViewController addEntryToFile: origin];
    [PlaceViewController addEntryToFile: destination];
}

-(MSRoute *)getRoute {
    //Finish this method
    NSString *time = [date]
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://api.winnipegtransit.com/trip-planner?origin=%@&destination=%@&time=%@&date=%@&mode=%@&easy-access=%@&walk-speed=%@&max-walk-time=%@&min-transfer-wait=%@&max-transfer-wait=%@&api-key=%@",origin,destination,time,date,mode,easyAccess,walkSpeed,maxWalkTime,minTransferWaitTime,maxTransferWaitTime,transitAPIKey];
    NSURL *queryURL = [[NSURL alloc]initWithString:urlString];
    return NULL;
}


@end
