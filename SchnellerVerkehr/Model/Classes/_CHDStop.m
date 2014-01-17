// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CHDStop.m instead.

#import "_CHDStop.h"

const struct CHDStopAttributes CHDStopAttributes = {
	.arrivalDate = @"arrivalDate",
	.departureDate = @"departureDate",
	.order = @"order",
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
	
	if ([key isEqualToString:@"orderValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"order"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic arrivalDate;






@dynamic departureDate;






@dynamic order;



- (int16_t)orderValue {
	NSNumber *result = [self order];
	return [result shortValue];
}

- (void)setOrderValue:(int16_t)value_ {
	[self setOrder:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveOrderValue {
	NSNumber *result = [self primitiveOrder];
	return [result shortValue];
}

- (void)setPrimitiveOrderValue:(int16_t)value_ {
	[self setPrimitiveOrder:[NSNumber numberWithShort:value_]];
}





@dynamic leg;

	

@dynamic station;

	






@end
