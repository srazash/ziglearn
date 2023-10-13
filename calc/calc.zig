pub const add = @import("add.zig");

test {
    // by default, only tests in the specified file are included.
    // this line of code will cause a reference to all nested containers to be tested:
    @import("std").testing.refAllDecls(@This());
}
