//! STACK MEMORY
// stackmem/main.zig

const std = @import("std");

// most Zig programs use three areas of memory:
// 1. global space, where program constants such as string literals are stored
// these are baked into the binary, known at comptime and immutable
// 2. stack memory, each function in a program (including main()) push a frame onto the stack memory
// this frame is then popped once the function has completed executing, parameters are passed up the
// stack and returns are passed down as required between the functions. The stack is managed by the
// OS and the executable.
// 3. heap memory, covered in heapmem/main.zig

// dangling pointers
pub fn main() void {
    var user1 = User.init(1, 10);
    var user2 = User.init(2, 20);

    std.debug.print("User {d} has power of {d}\n", .{ user1.id, user1.power });
    std.debug.print("User {d} has power of {d}\n", .{ user2.id, user2.power });
}

const User = struct {
    id: u64,
    power: i32,

    // this method originally returned a POINTER to a User
    // but as soon as this methods frame on the stack popped we were left with
    // DANGLING POINTERS, that is; pointers to memory that has been freed.
    // in this example returning a value  rather than a refrence fixes this,
    // but in some more complex programs we may need to ensure the integrity of
    // data in memory between stack frames by using heap memory!
    fn init(id: u64, power: i32) User { // <--- changed from: *User {
        var user = User{
            .id = id,
            .power = power,
        };
        return user; // <--- changed from &user;
    }
};
