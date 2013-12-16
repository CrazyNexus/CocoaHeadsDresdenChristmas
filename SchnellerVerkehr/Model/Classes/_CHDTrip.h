// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CHDTrip.h instead.

#import <CoreData/CoreData.h>


extern const struct CHDTripAttributes {
	__unsafe_unretained NSString *duration;
	__unsafe_unretained NSString *interchanges;
} CHDTripAttributes;

extern const struct CHDTripRelationships {
	__unsafe_unretained NSString *legs;
} CHDTripRelationships;

extern const struct CHDTripFetchedProperties {
} CHDTripFetchedProperties;

@class CHDLeg;




@interface CHDTripID : NSManagedObjectID {}
@end

@interface _CHDTrip : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CHDTripID*)objectID;





@property (nonatomic, strong) NSNumber* duration;



@property int64_t durationValue;
- (int64_t)durationValue;
- (void)setDurationValue:(int64_t)value_;

//- (BOOL)validateDuration:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* interchanges;



@property int16_t interchangesValue;
- (int16_t)interchangesValue;
- (void)setInterchangesValue:(int16_t)value_;

//- (BOOL)validateInterchanges:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *legs;

- (NSMutableOrderedSet*)legsSet;





@end

@interface _CHDTrip (CoreDataGeneratedAccessors)

- (void)addLegs:(NSOrderedSet*)value_;
- (void)removeLegs:(NSOrderedSet*)value_;
- (void)addLegsObject:(CHDLeg*)value_;
- (void)removeLegsObject:(CHDLeg*)value_;

@end

@interface _CHDTrip (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveDuration;
- (void)setPrimitiveDuration:(NSNumber*)value;

- (int64_t)primitiveDurationValue;
- (void)setPrimitiveDurationValue:(int64_t)value_;




- (NSNumber*)primitiveInterchanges;
- (void)setPrimitiveInterchanges:(NSNumber*)value;

- (int16_t)primitiveInterchangesValue;
- (void)setPrimitiveInterchangesValue:(int16_t)value_;





- (NSMutableOrderedSet*)primitiveLegs;
- (void)setPrimitiveLegs:(NSMutableOrderedSet*)value;


@end
