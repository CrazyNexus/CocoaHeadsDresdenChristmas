// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CHDStop.m instead.

#import "_CHDStop.h"

const struct CHDStopAttributes CHDStopAttributes = {
	.arrivalDate = @"arrivalDate",
	.departureDate = @"departureDate",
};

const struct CHDStopRelationships CHDStopRelationships = {
	.leg = @"leg",
	.station = @"station",
};

const struct CHDStopFetchedProperties CHDStopFetchedProperties = {
};

@implementation CHDStopID
@end

@implementation _CHDStop

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Stop" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Stop";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Stop" inManagedObjectContext:moc_];
}

- (CHDStopID*)objectID {
	return (CHDStopID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic arrivalDate;






@dynamic departureDate;






@dynamic leg;

	

@dynamic station;

	






@end
