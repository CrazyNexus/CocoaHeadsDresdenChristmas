// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CHDFavorite.h instead.

#import <CoreData/CoreData.h>


extern const struct CHDFavoriteAttributes {
	__unsafe_unretained NSString *lastTime;
	__unsafe_unretained NSString *timesUsed;
} CHDFavoriteAttributes;

extern const struct CHDFavoriteRelationships {
	__unsafe_unretained NSString *station;
} CHDFavoriteRelationships;

extern const struct CHDFavoriteFetchedProperties {
} CHDFavoriteFetchedProperties;

@class CHDStation;




@interface CHDFavoriteID : NSManagedObjectID {}
@end

@interface _CHDFavorite : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CHDFavoriteID*)objectID;





@property (nonatomic, strong) NSDate* lastTime;



//- (BOOL)validateLastTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* timesUsed;



@property int32_t timesUsedValue;
- (int32_t)timesUsedValue;
- (void)setTimesUsedValue:(int32_t)value_;

//- (BOOL)validateTimesUsed:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) CHDStation *station;

//- (BOOL)validateStation:(id*)value_ error:(NSError**)error_;





@end

@interface _CHDFavorite (CoreDataGeneratedAccessors)

@end

@interface _CHDFavorite (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveLastTime;
- (void)setPrimitiveLastTime:(NSDate*)value;




- (NSNumber*)primitiveTimesUsed;
- (void)setPrimitiveTimesUsed:(NSNumber*)value;

- (int32_t)primitiveTimesUsedValue;
- (void)setPrimitiveTimesUsedValue:(int32_t)value_;





- (CHDStation*)primitiveStation;
- (void)setPrimitiveStation:(CHDStation*)value;


@end
