//! POINTERS/MAIN
// main.zig
const std = @import("std");

pub fn main() void {
    // *** POINTERS
    var user = User{
        .id = 1,
        .power = 100,
    };

    // `&` is the ADDRESSOF operator
    // here we'll take a look at the addresses of our user, user.id and user.power in memory:
    std.debug.print("{*}\n", .{&user});
    std.debug.print("{*}\n", .{&user.id});
    std.debug.print("{*}\n", .{&user.power});

    // using the addressof operator returns a pointer
    // above we ask for the address of user (&user) and we recieve a pointer to User (*User)
    const user_ptr = &user; // type = *User, ZLS should express this as `...: *User =...`
    std.debug.print("{any}\n", .{@TypeOf(user_ptr)}); // this should return *main.User

    // because we want the levelUp() function to affect data in memory we need to pass it a pointer
    levelUp(&user); // we pass levelUp() the address of our user
    std.debug.print("User {d} has a power level of {d}.\n", .{ user.id, user.power });

    // for methods, this works exactly the same
    var ryan = BetterUser{
        .name = "Ryan",
        .id = 2,
        .power = 8999,
    };

    // we can call them like a normal function
    BetterUser.betterLevelUp(&ryan);

    // but we can also call them through our new user
    // Zig's compiler will infer that a pointer to our user needs to be passed in
    ryan.betterLevelUp();
    std.debug.print("{s} (ID: {d}) has a power level of {d}.\n", .{ ryan.name, ryan.id, ryan.power });
}

// levelUp() now takes a POINTER
fn levelUp(user: *User) void {
    user.power += 1;
}

const User = struct {
    id: u64,
    power: i32,
};

const BetterUser = struct {
    name: []const u8,
    id: u64,
    power: i32,

    fn betterLevelUp(user: *BetterUser) void {
        user.power += 1;
    }
};
