//! DANGLING POINTERS
const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    //var lookup = std.StringHashMap(User).init(allocator);
    var lookup = std.StringHashMap(*const User).init(allocator);
    defer lookup.deinit();

    const goku = User{ .power = 9001 };

    //try lookup.put("Goku", goku);
    // goku -> &goku
    try lookup.put("Goku", &goku);
    //const entry = lookup.getPtr("Goku").?;
    // getPtr -> get
    const entry = lookup.get("Goku").?;

    // returns an optional, .? would panic if "Goku"
    // wasn't in our hashmap

    std.debug.print("Goku's power is: {d}\n", .{entry.power});

    // returns true/false depending on if the item was removed
    //_ = lookup.remove("Goku");

    std.debug.print("Goku's power is: {d}\n", .{entry.power});
}

const User = struct {
    power: i32,
};
