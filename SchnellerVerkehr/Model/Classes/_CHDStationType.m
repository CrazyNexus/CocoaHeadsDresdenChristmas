// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CHDStationType.m instead.

#import "_CHDStationType.h"

const struct CHDStationTypeAttributes CHDStationTypeAttributes = {
	.id = @"id",
	.name = @"name",
};

const struct CHDStationTypeRelationships CHDStationTypeRelationships = {
	.stations = @"stations",
};

const struct CHDStationTypeFetchedProperties CHDStationTypeFetchedProperties = {
};

@implementation CHDStationTypeID
@end

@implementation _CHDStationType

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"StationType" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"StationType";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"StationType" inManagedObjectContext:moc_];
}

- (CHDStationTypeID*)objectID {
	return (CHDStationTypeID*)[super objectID];
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






@dynamic stations;

	
- (NSMutableSet*)stationsSet {
	[self willAccessValueForKey:@"stations"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"stations"];
  
	[self didAccessValueForKey:@"stations"];
	return result;
}
	






@end
