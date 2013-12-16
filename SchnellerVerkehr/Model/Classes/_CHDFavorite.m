// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CHDFavorite.m instead.

#import "_CHDFavorite.h"

const struct CHDFavoriteAttributes CHDFavoriteAttributes = {
	.lastTime = @"lastTime",
	.timesUsed = @"timesUsed",
};

const struct CHDFavoriteRelationships CHDFavoriteRelationships = {
	.station = @"station",
};

const struct CHDFavoriteFetchedProperties CHDFavoriteFetchedProperties = {
};

@implementation CHDFavoriteID
@end

@implementation _CHDFavorite

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Favorite" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Favorite";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:moc_];
}

- (CHDFavoriteID*)objectID {
	return (CHDFavoriteID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"timesUsedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"timesUsed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic lastTime;






@dynamic timesUsed;



- (int32_t)timesUsedValue {
	NSNumber *result = [self timesUsed];
	return [result intValue];
}

- (void)setTimesUsedValue:(int32_t)value_ {
	[self setTimesUsed:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTimesUsedValue {
	NSNumber *result = [self primitiveTimesUsed];
	return [result intValue];
}

- (void)setPrimitiveTimesUsedValue:(int32_t)value_ {
	[self setPrimitiveTimesUsed:[NSNumber numberWithInt:value_]];
}





@dynamic station;

	






@end
