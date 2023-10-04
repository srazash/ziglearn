//! ERRORS
// errors.zig
const std = @import("std");

// errors use error sets, which look and behave like enums:
pub const OpenError = error{
    AccessDenied,
    NotFound,
};

// we can now return any error from our error set, but we need to mark the return type to indicate
// that an error is a possible return value, we do this by prepending the return type with an `!`
// this is an ERROR UNION TYPE
pub fn RtnErr() OpenError!void {
    std.debug.print("RtnErr() has executed\n", .{});
    return OpenError.AccessDenied;
}

// we can allow Zig's compiler to infer the error type being returned, so we could have defied RtnErr() as:
// pub fn RtnErr() !void {...}

// Zig is also capable of implicitely creating error sets for us, so instead of defining the OpenError error
// set, we could have simply returned:
// return error.AccessDenied;

// these two approaches are not equivalent, for example, implicit error sets need to use the `anyerror` type
// explicit error sets make code self-documenting, which can be a benefit when reviewing code
// both approches have their advantages and disadvantages, and can be mixed

// it's not unusual for functions to return an ERROR UNION OPTIONAL TYPE
const OptErrors = error{
    Not0Or1,
};

pub fn RtnErrOpt(in: u8) !?[]const u8 {
    switch (in) {
        0 => return null,
        1 => return "something",
        else => return OptErrors.Not0Or1,
    }
}
