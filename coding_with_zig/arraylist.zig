const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var arr = std.ArrayList(User).init(allocator);
    defer {
        for (arr.items) |user| user.deinit(allocator);
        arr.deinit();
    }

    // stdin is an std.io.Reader
    const stdin = std.io.getStdIn().reader();

    // stdout is an std.io.Writer
    const stdout = std.io.getStdOut().writer();

    var i: i32 = 0;
    while (true) : (i += 1) {
        var buf: [30]u8 = undefined;
        try stdout.print("Please enter a name: ", .{});
        if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |name| {
            if (name.len == 0) break;
            const owned_name = try allocator.dupe(u8, name);
            try arr.append(.{ .name = owned_name, .power = i });
        }
    }

    var has_leto = false;
    for (arr.items) |user| {
        if (std.mem.eql(u8, "Leto", user.name)) {
            has_leto = true;
            break;
        }
    }

    std.debug.print("{any}\n", .{has_leto});

    // a string is a []u8 or []const u8, so ArrayList(u8) is an appropriate string builder
    var out = std.ArrayList(u8).init(allocator);
    defer out.deinit();

    try std.json.stringify(.{
        .this_is = "an anonymous struct",
        .above = true,
        .last_param = "are options",
    }, .{ .whitespace = .indent_2 }, out.writer());

    std.debug.print("{s}\n", .{out.items});
}

const User = struct {
    name: []const u8,
    power: i32,

    fn deinit(self: User, allocator: Allocator) void {
        allocator.free(self.name);
    }
};
