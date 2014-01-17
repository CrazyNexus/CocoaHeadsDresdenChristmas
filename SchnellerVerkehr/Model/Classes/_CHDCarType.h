// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CHDCarType.h instead.

#import <CoreData/CoreData.h>


extern const struct CHDCarTypeAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *name;
} CHDCarTypeAttributes;

extern const struct CHDCarTypeRelationships {
	__unsafe_unretained NSString *legs;
} CHDCarTypeRelationships;

extern const struct CHDCarTypeFetchedProperties {
} CHDCarTypeFetchedProperties;

@class CHDLeg;




@interface CHDCarTypeID : NSManagedObjectID {}
@end

@interface _CHDCarType : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CHDCarTypeID*)objectID;





@property (nonatomic, strong) NSNumber* id;



@property int16_t idValue;
- (int16_t)idValue;
- (void)setIdValue:(int16_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *legs;

- (NSMutableSet*)legsSet;





@end

@interface _CHDCarType (CoreDataGeneratedAccessors)

- (void)addLegs:(NSSet*)value_;
- (void)removeLegs:(NSSet*)value_;
- (void)addLegsObject:(CHDLeg*)value_;
- (void)removeLegsObject:(CHDLeg*)value_;

@end

@interface _CHDCarType (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int16_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int16_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveLegs;
- (void)setPrimitiveLegs:(NSMutableSet*)value;


@end
