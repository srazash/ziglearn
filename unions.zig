//! TAGGED UNIONS
// unions.zig

// a union defines a set of types that a value can have
// Number can have an int, float or nan
pub const Number = union {
    int: i64,
    float: f64,
    nan: void,
};

// tagged union example --- enum + union:
const TimestampType = enum {
    unix,
    datetime,
};

// we could have declared this union this way:
// pub const Timestamp = union(enum) {...}
// this is because zig would have created an implicit enum based on our union's fields
pub const Timestamp = union(TimestampType) {
    unix: i32,
    datetime: DateTime,

    const DateTime = struct {
        year: u16,
        month: u8,
        day: u8,
        hour: u8,
        minute: u8,
        second: u8,
    };

    // each case in the switch below captures the type of each field value
    pub fn seconds(self: Timestamp) u16 {
        switch (self) {
            .datetime => |dt| return dt.second,
            .unix => |ts| {
                // `@rem` returns the remainder from the numerator and denominator we pass it
                const seconds_since_zero = @rem(ts, 86400);
                // `@intCast()` infers we want a u16 from the return type of the function
                return @intCast(@rem(seconds_since_zero, 60));
            },
        }
    }
};
