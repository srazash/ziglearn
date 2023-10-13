pub fn add(a: anytype, b: @TypeOf(a)) @TypeOf(a) {
    //pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

const testing = @import("std").testing;
test "add" {
    try testing.expectEqual(@as(i32, 32), add(30, 2));
}
