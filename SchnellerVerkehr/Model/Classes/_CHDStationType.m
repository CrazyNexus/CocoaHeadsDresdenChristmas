// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CHDStationType.m instead.

#import "_CHDStationType.h"

const struct CHDStationTypeAttributes CHDStationTypeAttributes = {
	.name = @"name",
	.searchType = @"searchType",
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
	

	return keyPaths;
}




@dynamic name;






@dynamic searchType;






@dynamic stations;

	
- (NSMutableSet*)stationsSet {
	[self willAccessValueForKey:@"stations"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"stations"];
  
	[self didAccessValueForKey:@"stations"];
	return result;
}
	






@end
