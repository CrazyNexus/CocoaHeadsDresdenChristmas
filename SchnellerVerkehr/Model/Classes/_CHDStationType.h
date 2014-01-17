// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CHDStationType.h instead.

#import <CoreData/CoreData.h>


extern const struct CHDStationTypeAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *searchType;
} CHDStationTypeAttributes;

extern const struct CHDStationTypeRelationships {
	__unsafe_unretained NSString *stations;
} CHDStationTypeRelationships;

extern const struct CHDStationTypeFetchedProperties {
} CHDStationTypeFetchedProperties;

@class CHDStation;




@interface CHDStationTypeID : NSManagedObjectID {}
@end

@interface _CHDStationType : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CHDStationTypeID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* searchType;



//- (BOOL)validateSearchType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *stations;

- (NSMutableSet*)stationsSet;





@end

@interface _CHDStationType (CoreDataGeneratedAccessors)

- (void)addStations:(NSSet*)value_;
- (void)removeStations:(NSSet*)value_;
- (void)addStationsObject:(CHDStation*)value_;
- (void)removeStationsObject:(CHDStation*)value_;

@end

@interface _CHDStationType (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveSearchType;
- (void)setPrimitiveSearchType:(NSString*)value;





- (NSMutableSet*)primitiveStations;
- (void)setPrimitiveStations:(NSMutableSet*)value;


@end
