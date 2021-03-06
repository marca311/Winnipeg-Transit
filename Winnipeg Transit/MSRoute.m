//
//  MSTrip.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-01-29.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSRoute.h"
#import "XMLParser.h"

@implementation MSRoute

-(id)initWithData:(NSData *)theData andOrigin:(MSLocation *)theOrigin andDestination:(MSLocation *)theDestination {
    rootData = theData;
    origin = theOrigin;
    destination = theDestination;
    TBXML *xmlFile = [XMLParser loadXmlDocumentFromData:rootData];
    rootElement = [xmlFile rootXMLElement];
    [self setDate];
    [self setNumberOfVariations];
    [self setVariationArray];
    //[self saveToFile];
    return self;
}

#pragma mark - NSCoding section
-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        origin = [aDecoder decodeObjectForKey:@"origin"];
        destination = [aDecoder decodeObjectForKey:@"destination"];
        date = [aDecoder decodeObjectForKey:@"date"];
        numberOfVariations = [aDecoder decodeIntegerForKey:@"numberOfVariations"];
        variationArray = [aDecoder decodeObjectForKey:@"variationArray"];
        rootData = [aDecoder decodeObjectForKey:@"rootElement"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:origin forKey:@"origin"];
    [aCoder encodeObject:destination forKey:@"destination"];
    [aCoder encodeObject:date forKey:@"date"];
    [aCoder encodeInteger:numberOfVariations forKey:@"numberOfVariations"];
    [aCoder encodeObject:variationArray forKey:@"variationArray"];
    [aCoder encodeObject:rootData forKey:@"variationArray"];
}
#pragma mark -

-(void)setDate {
    date = [NSDate date];
}

-(void)setNumberOfVariations {
    TBXMLElement *theElement = rootElement;
    theElement = [XMLParser extractUnknownChildElement:theElement];
    NSUInteger variations = 1;
    while ((theElement = theElement->nextSibling)) {
        variations++;
    }
    numberOfVariations = variations;
    
}

-(void)setVariationArray {
    TBXMLElement *theElement = rootElement;
    theElement = [XMLParser extractUnknownChildElement:theElement];
    NSMutableArray *variations = [[NSMutableArray alloc]init];
    for (int i=0; i < numberOfVariations; i++) {
        MSVariation *variation = [[MSVariation alloc]initWithElement:theElement];
        variation = [self checkIfWalkRoute:variation];
        [variations addObject:variation];
        if (i < numberOfVariations) theElement = theElement->nextSibling;
    }
    variationArray = variations;
}

-(MSVariation *)checkIfWalkRoute:(MSVariation *)variation {
    int totalTime = [[variation getTotalTime]intValue];
    int walkingTime = [[variation getWalkingTime]intValue];
    if (totalTime == walkingTime) {
        //Get the single segment in the walking route
        NSMutableArray *segmentArray = (NSMutableArray *)[variation getSegmentArray];
        MSSegment *segment = [segmentArray objectAtIndex:0];
        [segment setFromLocation:origin];
        [segment setToLocation:destination];
        [segmentArray setObject:segment atIndexedSubscript:0];
        [variation setSegmentArray:segmentArray];
        return variation;
    }
    return variation;
}

-(void)saveToFile {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"y-MM-dd-hh:mm:ss"];
    NSString *entryTime = [dateFormat stringFromDate:date];
    NSString *fileName = [NSString stringWithFormat:@"ROUTE_%@.route",entryTime];
    NSData *route = [NSKeyedArchiver archivedDataWithRootObject:self];
    [route writeToFile:fileName atomically:NO];
}

-(NSUInteger)getNumberOfVariations {
    return numberOfVariations;
}

-(NSArray *)getVariations {
    return variationArray;
}

-(MSVariation *)getVariationFromIndex:(NSUInteger)index {
    return [variationArray objectAtIndex:index];
}

@end
