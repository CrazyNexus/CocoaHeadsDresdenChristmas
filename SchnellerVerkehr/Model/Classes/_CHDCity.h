// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CHDCity.h instead.

#import <CoreData/CoreData.h>


extern const struct CHDCityAttributes {
	__unsafe_unretained NSString *name;
} CHDCityAttributes;

extern const struct CHDCityRelationships {
	__unsafe_unretained NSString *stations;
} CHDCityRelationships;

extern const struct CHDCityFetchedProperties {
} CHDCityFetchedProperties;

@class CHDStation;



@interface CHDCityID : NSManagedObjectID {}
@end

@interface _CHDCity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CHDCityID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *stations;

- (NSMutableSet*)stationsSet;





@end

@interface _CHDCity (CoreDataGeneratedAccessors)

- (void)addStations:(NSSet*)value_;
- (void)removeStations:(NSSet*)value_;
- (void)addStationsObject:(CHDStation*)value_;
- (void)removeStationsObject:(CHDStation*)value_;

@end

@interface _CHDCity (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveStations;
- (void)setPrimitiveStations:(NSMutableSet*)value;


@end
