// main.zig
const std = @import("std");

const User = @import("models/user.zig").User;
const MAX_POWER = @import("models/user.zig").MAX_POWER;

pub fn main() void {
    // can be an anonymous struct because we provided the type
    const goku: User = .{
        .power = 9001,
        .name = "Goku",
    };

    // var type is inferred from the struct's type
    var ryan = User.init("Ryan", 1);

    std.debug.print("{s}'s power is {d}\n", .{ goku.name, goku.power });
    goku.diagnose();

    std.debug.print("{s}'s power is {d}\n", .{ ryan.name, ryan.power });
    ryan.diagnose();

    var a = [_]i32{ 1, 2, 3, 4, 5 }; // array
    const b = a[1..4]; // pointer
    var end: usize = 4; // end is not comptime know, so allows us to create a slice
    const c = a[1..end]; // slice

    std.debug.print("a is {any} = array\n", .{@TypeOf(a)});
    std.debug.print("b is {any} = pointer\n", .{@TypeOf(b)});
    std.debug.print("c is {any} = slice\n", .{@TypeOf(c)});

    c[2] = 99;

    for (c) |ele| {
        std.debug.print("{d}\n", .{ele});
    }

    // an array of 3 booleans with false as the sentinel value
    const d = [3:false]bool{ false, true, false };
    std.debug.print("{any}\n", .{std.mem.asBytes(&d).*});
}
