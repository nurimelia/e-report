//
//  DataModel.h
//  E-Report for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic, strong) NSMutableArray *lists;

- (void)saveChecklists;

- (int)indexOfSelectedChecklist;
- (void)setIndexOfSelectedChecklist:(int)index;

- (void)sortChecklists;


+ (int)nextChecklistItemId;


@end
