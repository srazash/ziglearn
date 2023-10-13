pub fn add(a: anytype, b: @TypeOf(a)) @TypeOf(a) {
    return a + b;
}

const testing = @import("std").testing;
test "add" {
    try testing.expectEqual(@as(i32, 32), add(30, 2));
}
