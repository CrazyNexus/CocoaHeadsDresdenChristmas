// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CHDCarType.m instead.

#import "_CHDCarType.h"

const struct CHDCarTypeAttributes CHDCarTypeAttributes = {
	.id = @"id",
	.name = @"name",
};

const struct CHDCarTypeRelationships CHDCarTypeRelationships = {
	.legs = @"legs",
};

const struct CHDCarTypeFetchedProperties CHDCarTypeFetchedProperties = {
};

@implementation CHDCarTypeID
@end

@implementation _CHDCarType

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CarType" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CarType";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CarType" inManagedObjectContext:moc_];
}

- (CHDCarTypeID*)objectID {
	return (CHDCarTypeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic id;



- (int16_t)idValue {
	NSNumber *result = [self id];
	return [result shortValue];
}

- (void)setIdValue:(int16_t)value_ {
	[self setId:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result shortValue];
}

- (void)setPrimitiveIdValue:(int16_t)value_ {
	[self setPrimitiveId:[NSNumber numberWithShort:value_]];
}





@dynamic name;






@dynamic legs;

	
- (NSMutableSet*)legsSet {
	[self willAccessValueForKey:@"legs"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"legs"];
  
	[self didAccessValueForKey:@"legs"];
	return result;
}
	






@end
