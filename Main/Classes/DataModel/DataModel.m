//
//  DataModel.m
//  E-Report for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//

#import "Checklist.h"
#import "DataModel.h"
//#import "KKKeychain.h"



@implementation DataModel

@synthesize lists;


- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}
- (NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"iTracker.plist"];
            }
            - (void)saveChecklists
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:lists forKey:@"Checklists"];
        [archiver finishEncoding];
        [data writeToFile:[self dataFilePath] atomically:YES];
    }
            - (void)loadChecklists
    {
        NSString *path = [self dataFilePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSData *data = [[NSData alloc] initWithContentsOfFile:path];
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            lists = [unarchiver decodeObjectForKey:@"Checklists"];
            [unarchiver finishDecoding];
        } else {
            lists = [[NSMutableArray alloc] initWithCapacity:20];
        }
    }

- (void)registerDefaults
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:-1], @"ChecklistIndex",
                                [NSNumber numberWithBool:YES], @"FirstTime",
                                [NSNumber numberWithInt:0], @"ChecklistItemId",
                                nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}


- (void)handleFirstTime
{
    BOOL firstTime = [[NSUserDefaults standardUserDefaults] boolForKey:@"FirstTime"];
                      if (firstTime) {
                          Checklist *checklist = [[Checklist alloc] init];
                          checklist.LabName = @"Computer";
                          [lists addObject:checklist];
                          [self setIndexOfSelectedChecklist:0];
                          [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstTime"];
                          
                        
                      }
}
                      
- (id)init
{
    if ((self = [super init])) {
        [self loadChecklists];
        [self registerDefaults];
        [self handleFirstTime];
    }
    return self;
}


- (int)indexOfSelectedChecklist
{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ChecklistItem"];
}
- (void)setIndexOfSelectedChecklist:(int)index
{
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"ChecklistItem"];
}


- (void)sortChecklists
{
    [self.lists sortUsingSelector:@selector(compare:)];
}

+ (int)nextChecklistItemId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int itemId = (int)[userDefaults integerForKey:@"ChecklistItemId"];
    [userDefaults setInteger:itemId + 1 forKey:@"ChecklistItemId"];
    [userDefaults synchronize];
    return itemId;
}


@end
