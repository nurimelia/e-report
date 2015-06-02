//
//  Checklist.h
//  E-Report for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Checklist : NSObject <NSCoding>


//@property (nonatomic, copy) NSString *category;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSString *notes;
//@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, strong) PFFile *iconName;

- (int)countUncheckedItems;


@end
