//
//  CHDStop.m
//  SchnellerVerkehr
//
//  Created by Michael Berg on 09.12.13.
//  Copyright (c) 2013 Couchfunk. All rights reserved.
//

#import "CHDStop.h"

@implementation CHDStop

- (instancetype)initWithCity:(NSString *)city {
    return [self initWithCity:city name:@"Hauptbahnhof"];
}

- (instancetype)initWithCity:(NSString *)city name:(NSString *)name {
    self = [super init];
    if (self) {
        _city = city;
        _name = name;
    }
    return self;
}

+ (void)findByName:(NSString *)name completion:(StopSearchCompletionBlock)completion {
#if DEBUG
    NSLog(@"Find %@", name);
#endif
    
    NSString        *url        = [NSString stringWithFormat:@"http://efa.vvo-online.de:8080/standard/XML_STOPFINDER_REQUEST?locationServerActive=1&outputFormat=JSON&type_sf=stop&name_sf=%@", name];
    
    NSURLSession    *session    = [NSURLSession sharedSession];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[session   dataTaskWithURL     :[NSURL URLWithString:url]
                completionHandler   : ^(NSData *data,
                                        NSURLResponse *response,
                                        NSError *error) {
                    // handle response
                    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
                    if (httpResp.statusCode == 200) {
                        NSError *jsonError;
                        
                        NSDictionary *JSON = [NSJSONSerialization   JSONObjectWithData  :data
                                                                    options             :NSJSONReadingAllowFragments
                                                                    error               :&jsonError];
                        
                        NSMutableArray *stops = [[NSMutableArray alloc] init];
                        
                        if (!jsonError) {
                            NSArray *stopList = JSON[@"stopFinder"];
                            
                            for (NSDictionary * stopDict in stopList) {
                                NSString *city = stopDict[@"ref.place"];
                                NSString *name = [[stopDict[@"name"] componentsSeparatedByString:@","] lastObject];
                                
                                [stops addObject:[[CHDStop alloc] initWithCity:city name:name]];
                            }
                            
                            NSLog(@"found %@", stops);
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                
                                if (completion) {
                                    completion(stops);
                                }
                            });
                        }
                    }
                }] resume];
}

+ (void)findByLatitude:(CGFloat)latitude longitude:(CGFloat)longitude completion:(StopSearchCompletionBlock)completion {
    static NSString *kURL = @"http://www.vvo-mobil.de/de/autocomplete/geolocation.do";
    
    NSString   *urlString = [kURL stringByAppendingFormat:@"?id=%f-%f", longitude, latitude];
    NSURL       *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler: ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

#ifdef DEBUG
        NSLog(@"GeoResolver Response:\n%@", response);
#endif

        if (completion) {
            NSError *error;
            NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

            if (error || [results count] < 2) {
                completion(nil);
                return;
            }

            NSMutableArray *stops = [NSMutableArray arrayWithCapacity:[results count] - 1];

            for (NSUInteger i = 1; i < [results count]; i++) {
                NSArray *components = [(NSString *)results[i] componentsSeparatedByString : @"|"];

                if ([components count] != 3) {
                    completion(nil);
                    return;
                }

                CHDStop *stop = [[CHDStop alloc] init];
                stop.ID = components[0];
                stop.name = components[1];
                stop.distance = [components[2] integerValue];

                [stops addObject:stop];
            }

            completion(stops);
        }
    }];
}

@end
