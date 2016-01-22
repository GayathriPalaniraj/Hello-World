//
//  Task.h
//  DemoCore
//
//  Created by GAYATHRI_P on 12/01/16.
//  Copyright (c) 2016 GAYATHRI_P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class List;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSNumber * starred;
@property (nonatomic, retain) NSString * task;
@property (nonatomic, retain) List *list;

@end
