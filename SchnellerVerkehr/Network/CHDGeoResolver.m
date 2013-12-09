//
//  CHDGeoResolver.m
//  SchnellerVerkehr
//
//  Created by Steffen on 09.12.13.
//  Copyright (c) 2013 Couchfunk. All rights reserved.
//

#import "CHDGeoResolver.h"

@implementation CHDGeoResolver {
    id <CHDGeoResolverDelegate> _delegate;
    NSMutableData               *_httpData;
    NSURLConnection             *_connection;
}

static NSString *kURL = @"http://www.vvo-mobil.de/de/autocomplete/geolocation.do";

- (void)resolveGPSToStopWithLatitude:(double)latittude longitude:(double)longitude delegate:(id <CHDGeoResolverDelegate> )delegate {
    NSString            *urlString;
    NSURL               *url;
    NSMutableURLRequest *request;

    _delegate   = delegate;
    urlString   = [kURL stringByAppendingFormat:@"?id=%f-%f", longitude, latittude];
    url         = [NSURL URLWithString:urlString];

    request     = [NSMutableURLRequest requestWithURL:url];

    if (_connection)
        [_connection cancel];

    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    _httpData   = [NSMutableData data];

    if (_connection) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if ([connection isEqual:_connection]) {
        [_httpData appendData:data];
    }
}

- (void)cancelConnection {
    [_connection cancel];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

#ifdef DEBUG
    NSLog(@"GeoResolver Response:\n%@", [[NSString alloc] initWithData:_httpData encoding:NSUTF8StringEncoding]);
#endif
}

@end
