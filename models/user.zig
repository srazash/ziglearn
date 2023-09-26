// models/user.zig
const std = @import("std");

pub const MAX_POWER = 100_000;

pub const User = struct {
    power: u64 = 0, // default value
    name: []const u8,

    pub const SUPER_POWER = 9_000;

    pub fn init(name: []const u8, power: u64) User {
        // we can return an anonymous struct instead of return User{ ... }
        // because the return type of the function defines the type of struct
        return .{
            .name = name,
            .power = power,
        };
    }

    pub fn diagnose(user: User) void {
        if (user.power > SUPER_POWER) std.debug.print("it's over {d}!!!\n", .{SUPER_POWER});
        if (user.power < 1_000) std.debug.print(":-(\n", .{});
    }
};
