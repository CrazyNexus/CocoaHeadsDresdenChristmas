// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CHDStation.h instead.

#import <CoreData/CoreData.h>


extern const struct CHDStationAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *name;
} CHDStationAttributes;

extern const struct CHDStationRelationships {
	__unsafe_unretained NSString *city;
	__unsafe_unretained NSString *favorite;
	__unsafe_unretained NSString *stop;
	__unsafe_unretained NSString *type;
} CHDStationRelationships;

extern const struct CHDStationFetchedProperties {
} CHDStationFetchedProperties;

@class CHDCity;
@class CHDFavorite;
@class CHDStop;
@class CHDStationType;






@interface CHDStationID : NSManagedObjectID {}
@end

@interface _CHDStation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CHDStationID*)objectID;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* latitude;



@property double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longitude;



@property double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) CHDCity *city;

//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) CHDFavorite *favorite;

//- (BOOL)validateFavorite:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) CHDStop *stop;

//- (BOOL)validateStop:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) CHDStationType *type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@end

@interface _CHDStation (CoreDataGeneratedAccessors)

@end

@interface _CHDStation (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (CHDCity*)primitiveCity;
- (void)setPrimitiveCity:(CHDCity*)value;



- (CHDFavorite*)primitiveFavorite;
- (void)setPrimitiveFavorite:(CHDFavorite*)value;



- (CHDStop*)primitiveStop;
- (void)setPrimitiveStop:(CHDStop*)value;



- (CHDStationType*)primitiveType;
- (void)setPrimitiveType:(CHDStationType*)value;


@end
