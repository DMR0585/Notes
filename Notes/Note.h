//
//  Note.h
//  Notes
//
//  Created by Dan Reife on 3/27/13.
//  Copyright (c) 2013 Dan Reife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSNumber * hasLocation;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * title;

@end
