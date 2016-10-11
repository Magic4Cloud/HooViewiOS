//
//  EVLocationViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVViewController.h"
#import <MapKit/MapKit.h>

@protocol LocationViewDelegate <NSObject>

-(void)sendLocationLatitude:(double)latitude
                  longitude:(double)longitude
                 andAddress:(NSString *)address;
@end

@interface EVLocationViewController : EVViewController

@property (nonatomic, weak) id<LocationViewDelegate> delegate;

@property (nonatomic,copy) NSString *mytitle;

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate;

@end
