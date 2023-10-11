//! OWNERSHIP
const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var lookup = std.StringHashMap(User).init(allocator);
    // replace the existing:
    //   defer lookup.deinit();
    // with:
    defer {
        var it = lookup.keyIterator();
        while (it.next()) |key| {
            allocator.free(key.*);
        }
        lookup.deinit();
    }

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
            // replace the existing lookup.put with these two lines
            const owned_name = try allocator.dupe(u8, name);

            // name -> owned_name
            try lookup.put(owned_name, .{ .power = i });
        }
    }
    // Place this code after the while loop
    var it = lookup.iterator();
    while (it.next()) |kv| {
        std.debug.print("{s} == {any}\n", .{ kv.key_ptr.*, kv.value_ptr.* });
    }

    const has_leto = lookup.contains("Leto");
    std.debug.print("{any}\n", .{has_leto});
}

const User = struct {
    power: i32,
};
