// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CHDStop.h instead.

#import <CoreData/CoreData.h>


extern const struct CHDStopAttributes {
	__unsafe_unretained NSString *arrivalDate;
	__unsafe_unretained NSString *departureDate;
} CHDStopAttributes;

extern const struct CHDStopRelationships {
	__unsafe_unretained NSString *leg;
	__unsafe_unretained NSString *station;
} CHDStopRelationships;

extern const struct CHDStopFetchedProperties {
} CHDStopFetchedProperties;

@class CHDLeg;
@class CHDStation;




@interface CHDStopID : NSManagedObjectID {}
@end

@interface _CHDStop : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CHDStopID*)objectID;





@property (nonatomic, strong) NSDate* arrivalDate;



//- (BOOL)validateArrivalDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* departureDate;



//- (BOOL)validateDepartureDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) CHDLeg *leg;

//- (BOOL)validateLeg:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) CHDStation *station;

//- (BOOL)validateStation:(id*)value_ error:(NSError**)error_;





@end

@interface _CHDStop (CoreDataGeneratedAccessors)

@end

@interface _CHDStop (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveArrivalDate;
- (void)setPrimitiveArrivalDate:(NSDate*)value;




- (NSDate*)primitiveDepartureDate;
- (void)setPrimitiveDepartureDate:(NSDate*)value;





- (CHDLeg*)primitiveLeg;
- (void)setPrimitiveLeg:(CHDLeg*)value;



- (CHDStation*)primitiveStation;
- (void)setPrimitiveStation:(CHDStation*)value;


@end
