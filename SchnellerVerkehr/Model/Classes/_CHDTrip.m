// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CHDTrip.m instead.

#import "_CHDTrip.h"

const struct CHDTripAttributes CHDTripAttributes = {
	.duration = @"duration",
	.interchanges = @"interchanges",
};

const struct CHDTripRelationships CHDTripRelationships = {
	.legs = @"legs",
};

const struct CHDTripFetchedProperties CHDTripFetchedProperties = {
};

@implementation CHDTripID
@end

@implementation _CHDTrip

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Trip";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Trip" inManagedObjectContext:moc_];
}

- (CHDTripID*)objectID {
	return (CHDTripID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"durationValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"duration"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"interchangesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"interchanges"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic duration;



- (int64_t)durationValue {
	NSNumber *result = [self duration];
	return [result longLongValue];
}

- (void)setDurationValue:(int64_t)value_ {
	[self setDuration:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveDurationValue {
	NSNumber *result = [self primitiveDuration];
	return [result longLongValue];
}

- (void)setPrimitiveDurationValue:(int64_t)value_ {
	[self setPrimitiveDuration:[NSNumber numberWithLongLong:value_]];
}





@dynamic interchanges;



- (int16_t)interchangesValue {
	NSNumber *result = [self interchanges];
	return [result shortValue];
}

- (void)setInterchangesValue:(int16_t)value_ {
	[self setInterchanges:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveInterchangesValue {
	NSNumber *result = [self primitiveInterchanges];
	return [result shortValue];
}

- (void)setPrimitiveInterchangesValue:(int16_t)value_ {
	[self setPrimitiveInterchanges:[NSNumber numberWithShort:value_]];
}





@dynamic legs;

	
- (NSMutableOrderedSet*)legsSet {
	[self willAccessValueForKey:@"legs"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"legs"];
  
	[self didAccessValueForKey:@"legs"];
	return result;
}
	






@end
