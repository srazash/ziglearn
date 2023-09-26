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
}
