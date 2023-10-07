//! HEAP MEMORY
// heapmem/main.zig

const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn main() !void {
    // 3. heap memory - compared to the global space and stack memory, heap
    // memory allows for types with an unknown size at comptime, and if far
    // more flexible, in short anything goes! At runtime we can allocate
    // memory with a runtime known size and have full control over it.

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // here we allocate memory, allocator (std.mem.Allocator) takes two arguments:
    // 1. the type to allocate
    // 2. a number of items to allocate
    // a slice to []T is returned --- in our example we will get [5]usize upto [10]usize
    // based on the value returned from our prng function
    var arr = try allocator.alloc(usize, try getPrng(0, true));
    // here we defer a call to free, which frees up the allocated memory, defer performs this
    // when existing the current scope, in our example that will be once the main function exits
    defer allocator.free(arr);

    // ERRDEFER
    // there is also:
    //errdefer allocator.free(arr);
    // so if an error occurs before the current scope exits, free is still called, and our memory
    // is freed.

    // DOUBLE-FREE & MEMORY LEAKS
    // there are a few rules that we must adhere to effectively manage memory, that is to say Zig
    // doesn't enforce these but failing to follow them could lead to crashes!
    // 1. we cannot free the same memory twice -- this will lead to an immediate crash
    // this is common where we manually free the memory but also free it elsewhere, such as in a deinit function
    // be sure to only free memory ONCE and when needed!
    // 2. we cannot free memory we don't have a reference to -- this will eventually crash by running out of memory, due to a memory leak
    // if we allocate memory as part of a function but never free that memory and the function exists scope, that memory remains in use
    // with no way to deallocate it, over time this can fill memory and cause a crash. Small leaks can be hard to detect, but Zig does
    // provide some help

    for (0..arr.len) |i| {
        arr[i] = try getPrng(100, false);
    }

    std.debug.print("{any}\n", .{arr});

    // alloc and free are used for slices, if we want to manage memory for single items we use:
    // CREATE & DESTROY
    var user = try allocator.create(User); // <--- we create a User on the heap
    defer allocator.destroy(user); // <--- destroy user once we exit scope to free the memory

    user.id = 1;
    user.power = 100;

    levelUp(user);
    std.debug.print("User {d} has power of {d}\n", .{ user.id, user.power });

    // the create function takes a single parameter - a type, T: User, and returns a pointer to user
    // again we defer the destroy function, and pass it user as the parameter, so that we know our
    // memory will be freed upon scope exit

    var list = try IntList.init(allocator);
    defer list.deinit();

    for (0..10) |i| {
        try list.add(@intCast(i + 1));
    }

    std.debug.print("{any}\n", .{list.items[0..list.pos]});
}

fn getPrng(at_most: u8, arr_init: bool) !u8 {
    var seed: u64 = undefined;
    try std.os.getrandom(std.mem.asBytes(&seed));
    var random = std.rand.DefaultPrng.init(seed);
    if (arr_init) return random.random().uintAtMost(u8, 5) + 5;
    return random.random().uintAtMost(u8, at_most);
}

fn levelUp(user: *User) void {
    user.power += 1;
}

const User = struct {
    id: u64,
    power: i32,
};

pub const IntList = struct {
    pos: usize,
    items: []i64,
    allocator: Allocator,

    fn init(allocator: Allocator) !IntList {
        return .{
            .pos = 0,
            .allocator = allocator,
            .items = try allocator.alloc(i64, 4),
        };
    }

    fn deinit(self: IntList) void {
        self.allocator.free(self.items);
    }

    fn add(self: *IntList, value: i64) !void {
        const pos = self.pos;
        const len = self.items.len;

        if (pos == len) {
            // we've run out of space
            // create a new slice that's twice as large
            var larger = try self.allocator.alloc(i64, len * 2);

            // copy the items we previously added to our new space
            @memcpy(larger[0..len], self.items);
            // freeing memory now data copied to larger
            self.allocator.free(self.items);

            self.items = larger;
        }

        self.items[pos] = value;
        self.pos = pos + 1;
    }
};

const testing = std.testing;
test "IntList: add" {
    var list = try IntList.init(testing.allocator);
    defer list.deinit();

    for (0..5) |i| {
        try list.add(@intCast(i + 10));
    }

    try testing.expectEqual(@as(usize, 5), list.pos);

    try testing.expectEqual(@as(i64, 10), list.items[0]);
    try testing.expectEqual(@as(i64, 11), list.items[1]);
    try testing.expectEqual(@as(i64, 12), list.items[2]);
    try testing.expectEqual(@as(i64, 13), list.items[3]);
    try testing.expectEqual(@as(i64, 14), list.items[4]);
}
