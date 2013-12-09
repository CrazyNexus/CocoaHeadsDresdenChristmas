//
//  CHDStop.m
//  SchnellerVerkehr
//
//  Created by Michael Berg on 09.12.13.
//  Copyright (c) 2013 Couchfunk. All rights reserved.
//

#import "CHDStop.h"

@implementation CHDStop

+ (void)findByLatitude:(CGFloat)latittude logitude:(CGFloat)longitude completion:(StopSearchCompletionBlock)completion {
    static NSString *kURL = @"http://www.vvo-mobil.de/de/autocomplete/geolocation.do";
    
    NSString   *urlString = [kURL stringByAppendingFormat:@"?id=%f-%f", longitude, latittude];
    NSURL       *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
#ifdef DEBUG
        NSLog(@"GeoResolver Response:\n%@", response);
#endif
        
        if (completion) {
            completion([NSArray array]);
        }
    }];
}

@end
