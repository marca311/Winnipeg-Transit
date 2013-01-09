//
//  MSUtilities.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-19.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSUtilities : NSObject

+(void)saveMutableDictionaryToFile:(NSMutableDictionary *)savedDictionary:(NSString *)fileName;

+(void)saveDictionaryToFile:(NSDictionary *)savedDictionary:(NSString *)fileName;

+(void)saveMutableArrayToFile:(NSMutableArray *)savedArray:(NSString *)fileName;

+(void)saveArrayToFile:(NSArray *)savedArray:(NSString *)fileName;

+(BOOL)fileExists:(NSString *)fileName;

+(NSArray *)getHumanArray;

+(NSDictionary *)loadDictionaryWithName:(NSString *)fileName;

+(void)generateCacheDB;

+(void)checkCacheAge;

+(void)deleteOldSavedRoutes;

+(NSString *)getFirmwareVersion;

+(BOOL)firmwareIsHigherThanFour;

+(BOOL)hasInternet;

+(BOOL)isQueryBlank:(NSString *)query;

@end
