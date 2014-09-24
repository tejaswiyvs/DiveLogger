#import "Dive.h"

@implementation Dive

- (CLLocationCoordinate2D)diveLocation {
    return CLLocationCoordinate2DMake([self.diveLocationX floatValue], [self.diveLocationY floatValue]);
}

- (NSArray *)fields {
    return @[
             @{ FXFormFieldKey: @"diveName", FXFormFieldTitle: @"Dive Name", FXFormFieldPlaceholder: @"Dive Name" },
             @{ FXFormFieldKey: @"diveDate", FXFormFieldTitle: @"Dive Date", FXFormFieldPlaceholder: @"Date" },
             @{ FXFormFieldKey: @"diveLocation", FXFormFieldTitle: @"Dive Location", FXFormFieldPlaceholder: @"Pick a location for your dive", FXFormFieldAction: @"diveLocationClicked" },
             @{ FXFormFieldKey: @"diveTime", FXFormFieldTitle: @"Dive Time" },
             @{ FXFormFieldKey: @"diveTime", FXFormFieldTitle: @"Dive Time" },
             @{ FXFormFieldKey: @"visibility", FXFormFieldTitle: @"Visibility", FXFormFieldPlaceholder: @"Visibility" },
             @{ FXFormFieldKey: @"airTemperature", FXFormFieldTitle: @"Air Temperature", FXFormFieldPlaceholder: @"Air Temperature" },
             @{ FXFormFieldKey: @"waterTemperature", FXFormFieldTitle: @"Water Temperature", FXFormFieldPlaceholder: @"Water Temperature" },
             @{ FXFormFieldKey: @"diveTime", FXFormFieldTitle: @"Dive Time", FXFormFieldPlaceholder: @"Dive Time" },
             @{ FXFormFieldKey: @"tank", FXFormFieldTitle: @"Tank", FXFormFieldPlaceholder: @"Tank" }
             ];
}

@end
