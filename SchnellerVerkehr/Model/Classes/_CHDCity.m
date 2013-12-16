// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CHDCity.m instead.

#import "_CHDCity.h"

const struct CHDCityAttributes CHDCityAttributes = {
	.name = @"name",
};

const struct CHDCityRelationships CHDCityRelationships = {
	.stations = @"stations",
};

const struct CHDCityFetchedProperties CHDCityFetchedProperties = {
};

@implementation CHDCityID
@end

@implementation _CHDCity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"City";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"City" inManagedObjectContext:moc_];
}

- (CHDCityID*)objectID {
	return (CHDCityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
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
