//! GENERICS
// generics/main.zig

const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var list = try List(u32).init(allocator);
    defer list.deinit();

    for (0..10) |i| {
        try list.add(@intCast(i + 1));
    }

    std.debug.print("{any}\n", .{list.items[0..list.pos]});
}

// this function returns a type, which is an array of a sized passed in as a parameter
// because types must be known at comptime the parameter is `comptime length: uzise`
//fn IntArray(comptime length: usize) type {

// to make our function full generic we replace the length parameter with a type (T) parameter
fn List(comptime T: type) type {
    //return [length]i64;

    // any type can be returned, not just primitives and arrays:
    return struct {
        pos: usize,
        items: []T,
        allocator: Allocator,

        fn init(allocator: Allocator) !List(T) {
            return .{
                .pos = 0,
                .allocator = allocator,
                .items = try allocator.alloc(T, 4),
            };
        }

        fn deinit(self: List(T)) void {
            self.allocator.free(self.items);
        }

        fn add(self: *List(T), value: T) !void {
            const pos = self.pos;
            const len = self.items.len;

            if (pos == len) {
                var larger = try self.allocator.alloc(T, len * 2);
                @memcpy(larger[0..len], self.items);
                self.allocator.free(self.items);
                self.items = larger;
            }

            self.items[pos] = value;
            self.pos = pos + 1;
        }
    };
}
