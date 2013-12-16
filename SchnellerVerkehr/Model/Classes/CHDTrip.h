#import "_CHDTrip.h"

typedef void (^TripSearchCompletionBlock)(NSArray *trips);

@class CHDStation;

@interface CHDTrip : _CHDTrip {}

+ (instancetype)tripWithDuration:(NSTimeInterval)duration interchanges:(NSUInteger)interchanges legs:(NSArray *)legs;

+ (void)findTripWithOrigin  :(CHDStation *)origin
        destination         :(CHDStation *)destination
        calcNumberOfTrips   :(NSUInteger)calcNumberOfTrips
        completion          :(TripSearchCompletionBlock)completion;

@end
