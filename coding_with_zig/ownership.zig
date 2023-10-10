//! OWNERSHIP
const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var lookup = std.StringHashMap(User).init(allocator);
    defer lookup.deinit();

    // stdin is an std.io.Reader
    // the opposite of an std.io.Writer, which we already saw
    const stdin = std.io.getStdIn().reader();

    // stdout is an std.io.Writer
    const stdout = std.io.getStdOut().writer();

    var i: i32 = 0;
    while (true) : (i += 1) {
        var buf: [30]u8 = undefined;
        try stdout.print("Please enter a name: ", .{});
        if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |name| {
            if (name.len == 0) {
                break;
            }
            try lookup.put(name, .{ .power = i });
        }
    }

    const has_leto = lookup.contains("Leto");
    std.debug.print("{any}\n", .{has_leto});
}

const User = struct {
    power: i32,
};
