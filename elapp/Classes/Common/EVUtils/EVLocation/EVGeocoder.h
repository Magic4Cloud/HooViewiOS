//
//  EVGeocoder.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface EVGeocoder : CLGeocoder

+ (instancetype)shareInstace;

- (void)decoderLocationWithLatitude:(double)latitude longitude:(double)longitude success:(void(^)(NSString *addressName))successBlock fail:(void(^)(NSError *error))failBlock;

@end
