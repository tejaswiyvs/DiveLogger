// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tank.m instead.

#import "_Tank.h"

const struct TankAttributes TankAttributes = {
	.airComposition = @"airComposition",
	.airCompositionNotes = @"airCompositionNotes",
	.endingPressure = @"endingPressure",
	.startingPressure = @"startingPressure",
};

const struct TankRelationships TankRelationships = {
	.dive = @"dive",
};

const struct TankFetchedProperties TankFetchedProperties = {
};

@implementation TankID
@end

@implementation _Tank

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Tank" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Tank";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Tank" inManagedObjectContext:moc_];
}

- (TankID*)objectID {
	return (TankID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"endingPressureValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"endingPressure"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"startingPressureValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"startingPressure"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic airComposition;






@dynamic airCompositionNotes;






@dynamic endingPressure;



- (int32_t)endingPressureValue {
	NSNumber *result = [self endingPressure];
	return [result intValue];
}

- (void)setEndingPressureValue:(int32_t)value_ {
	[self setEndingPressure:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveEndingPressureValue {
	NSNumber *result = [self primitiveEndingPressure];
	return [result intValue];
}

- (void)setPrimitiveEndingPressureValue:(int32_t)value_ {
	[self setPrimitiveEndingPressure:[NSNumber numberWithInt:value_]];
}





@dynamic startingPressure;



- (int32_t)startingPressureValue {
	NSNumber *result = [self startingPressure];
	return [result intValue];
}

- (void)setStartingPressureValue:(int32_t)value_ {
	[self setStartingPressure:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveStartingPressureValue {
	NSNumber *result = [self primitiveStartingPressure];
	return [result intValue];
}

- (void)setPrimitiveStartingPressureValue:(int32_t)value_ {
	[self setPrimitiveStartingPressure:[NSNumber numberWithInt:value_]];
}





@dynamic dive;

	






@end
