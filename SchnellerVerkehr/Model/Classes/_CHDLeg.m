// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CHDLeg.m instead.

#import "_CHDLeg.h"

const struct CHDLegAttributes CHDLegAttributes = {
	.destination = @"destination",
	.lineNumber = @"lineNumber",
	.name = @"name",
};

const struct CHDLegRelationships CHDLegRelationships = {
	.carType = @"carType",
	.stops = @"stops",
	.trip = @"trip",
};

const struct CHDLegFetchedProperties CHDLegFetchedProperties = {
};

@implementation CHDLegID
@end

@implementation _CHDLeg

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Leg" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Leg";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Leg" inManagedObjectContext:moc_];
}

- (CHDLegID*)objectID {
	return (CHDLegID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic destination;






@dynamic lineNumber;






@dynamic name;






@dynamic carType;

	

@dynamic stops;

	
- (NSMutableSet*)stopsSet {
	[self willAccessValueForKey:@"stops"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"stops"];
  
	[self didAccessValueForKey:@"stops"];
	return result;
}
	

@dynamic trip;

	






@end
