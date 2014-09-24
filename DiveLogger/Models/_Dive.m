// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Dive.m instead.

#import "_Dive.h"

const struct DiveAttributes DiveAttributes = {
	.airTemperature = @"airTemperature",
	.diveDate = @"diveDate",
	.diveDepth = @"diveDepth",
	.diveLocationX = @"diveLocationX",
	.diveLocationY = @"diveLocationY",
	.diveName = @"diveName",
	.diveNotes = @"diveNotes",
	.diveTime = @"diveTime",
	.notes = @"notes",
	.visibility = @"visibility",
	.waterTemperature = @"waterTemperature",
};

const struct DiveRelationships DiveRelationships = {
	.tank = @"tank",
};

const struct DiveFetchedProperties DiveFetchedProperties = {
};

@implementation DiveID
@end

@implementation _Dive

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Dive" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Dive";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Dive" inManagedObjectContext:moc_];
}

- (DiveID*)objectID {
	return (DiveID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"airTemperatureValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"airTemperature"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"diveLocationXValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"diveLocationX"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"diveLocationYValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"diveLocationY"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"diveTimeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"diveTime"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"visibilityValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"visibility"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"waterTemperatureValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"waterTemperature"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic airTemperature;



- (double)airTemperatureValue {
	NSNumber *result = [self airTemperature];
	return [result doubleValue];
}

- (void)setAirTemperatureValue:(double)value_ {
	[self setAirTemperature:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveAirTemperatureValue {
	NSNumber *result = [self primitiveAirTemperature];
	return [result doubleValue];
}

- (void)setPrimitiveAirTemperatureValue:(double)value_ {
	[self setPrimitiveAirTemperature:[NSNumber numberWithDouble:value_]];
}





@dynamic diveDate;






@dynamic diveDepth;






@dynamic diveLocationX;



- (float)diveLocationXValue {
	NSNumber *result = [self diveLocationX];
	return [result floatValue];
}

- (void)setDiveLocationXValue:(float)value_ {
	[self setDiveLocationX:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveDiveLocationXValue {
	NSNumber *result = [self primitiveDiveLocationX];
	return [result floatValue];
}

- (void)setPrimitiveDiveLocationXValue:(float)value_ {
	[self setPrimitiveDiveLocationX:[NSNumber numberWithFloat:value_]];
}





@dynamic diveLocationY;



- (float)diveLocationYValue {
	NSNumber *result = [self diveLocationY];
	return [result floatValue];
}

- (void)setDiveLocationYValue:(float)value_ {
	[self setDiveLocationY:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveDiveLocationYValue {
	NSNumber *result = [self primitiveDiveLocationY];
	return [result floatValue];
}

- (void)setPrimitiveDiveLocationYValue:(float)value_ {
	[self setPrimitiveDiveLocationY:[NSNumber numberWithFloat:value_]];
}





@dynamic diveName;






@dynamic diveNotes;






@dynamic diveTime;



- (int32_t)diveTimeValue {
	NSNumber *result = [self diveTime];
	return [result intValue];
}

- (void)setDiveTimeValue:(int32_t)value_ {
	[self setDiveTime:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveDiveTimeValue {
	NSNumber *result = [self primitiveDiveTime];
	return [result intValue];
}

- (void)setPrimitiveDiveTimeValue:(int32_t)value_ {
	[self setPrimitiveDiveTime:[NSNumber numberWithInt:value_]];
}





@dynamic notes;






@dynamic visibility;



- (double)visibilityValue {
	NSNumber *result = [self visibility];
	return [result doubleValue];
}

- (void)setVisibilityValue:(double)value_ {
	[self setVisibility:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveVisibilityValue {
	NSNumber *result = [self primitiveVisibility];
	return [result doubleValue];
}

- (void)setPrimitiveVisibilityValue:(double)value_ {
	[self setPrimitiveVisibility:[NSNumber numberWithDouble:value_]];
}





@dynamic waterTemperature;



- (double)waterTemperatureValue {
	NSNumber *result = [self waterTemperature];
	return [result doubleValue];
}

- (void)setWaterTemperatureValue:(double)value_ {
	[self setWaterTemperature:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveWaterTemperatureValue {
	NSNumber *result = [self primitiveWaterTemperature];
	return [result doubleValue];
}

- (void)setPrimitiveWaterTemperatureValue:(double)value_ {
	[self setPrimitiveWaterTemperature:[NSNumber numberWithDouble:value_]];
}





@dynamic tank;

	






@end
