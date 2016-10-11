//
//  EVGeocoder.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVGeocoder.h"

@implementation EVGeocoder

+ (instancetype)shareInstace{
    static EVGeocoder *decoder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        decoder = [[self alloc] init];
    });
    return decoder;
}

- (void)decoderLocationWithLatitude:(double)latitude longitude:(double)longitude success:(void(^)(NSString *addressName))successBlock fail:(void(^)(NSError *error))failBlock{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [self reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if ( error && failBlock) {
            failBlock(error);
            return ;
        }
        CLPlacemark *mark = [placemarks lastObject];
        NSString *addressName = mark.name != nil ? mark.name : mark.administrativeArea;
        if ( successBlock ) {
            successBlock(addressName);
        }
    }];
    
}

@end
