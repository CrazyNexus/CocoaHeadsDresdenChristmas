// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CHDLeg.h instead.

#import <CoreData/CoreData.h>


extern const struct CHDLegAttributes {
	__unsafe_unretained NSString *destination;
	__unsafe_unretained NSString *lineNumber;
	__unsafe_unretained NSString *name;
} CHDLegAttributes;

extern const struct CHDLegRelationships {
	__unsafe_unretained NSString *carType;
	__unsafe_unretained NSString *stops;
	__unsafe_unretained NSString *trip;
} CHDLegRelationships;

extern const struct CHDLegFetchedProperties {
} CHDLegFetchedProperties;

@class CHDCarType;
@class CHDStop;
@class CHDTrip;





@interface CHDLegID : NSManagedObjectID {}
@end

@interface _CHDLeg : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CHDLegID*)objectID;





@property (nonatomic, strong) NSString* destination;



//- (BOOL)validateDestination:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lineNumber;



//- (BOOL)validateLineNumber:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) CHDCarType *carType;

//- (BOOL)validateCarType:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *stops;

- (NSMutableSet*)stopsSet;




@property (nonatomic, strong) CHDTrip *trip;

//- (BOOL)validateTrip:(id*)value_ error:(NSError**)error_;





@end

@interface _CHDLeg (CoreDataGeneratedAccessors)

- (void)addStops:(NSSet*)value_;
- (void)removeStops:(NSSet*)value_;
- (void)addStopsObject:(CHDStop*)value_;
- (void)removeStopsObject:(CHDStop*)value_;

@end

@interface _CHDLeg (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDestination;
- (void)setPrimitiveDestination:(NSString*)value;




- (NSString*)primitiveLineNumber;
- (void)setPrimitiveLineNumber:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (CHDCarType*)primitiveCarType;
- (void)setPrimitiveCarType:(CHDCarType*)value;



- (NSMutableSet*)primitiveStops;
- (void)setPrimitiveStops:(NSMutableSet*)value;



- (CHDTrip*)primitiveTrip;
- (void)setPrimitiveTrip:(CHDTrip*)value;


@end
