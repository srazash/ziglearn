const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var l = Logger{ .level = .info };

    var arr = std.ArrayList(u8).init(allocator);
    defer arr.deinit();

    try l.info("server started or something, lol", arr.writer());
    std.debug.print("{s}\n", .{arr.items});
}

pub const Logger = struct {
    level: Level,

    // "error" is a reserved word in Zig
    // names insides a @"..." are alway treat as identifiers
    const Level = enum {
        debug,
        info,
        @"error",
        fatal,
    };

    fn info(logger: Logger, msg: []const u8, out: anytype) !void {
        if (@intFromEnum(logger.level) <= @intFromEnum(Level.info)) {
            // because `out` is `anytype` our Logger can log a message to struct that
            // has a `writeAll` method that accepts a `[]const u8` and retursns a `!void`
            try out.writeAll(msg);
        }
    }
};
