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

    // nested pointers
    // shallow copies created when a type is passed by value will give a function a copy of values, but pointers
    // (such as a slice... or a string) are copies of the original pointer - therefore are pointers to the original
    // data in memory, and not a copy
    // strings are typically immutable but as an example we can get around this:
    var new_name = [4]u8{ 'G', 'o', 'k', 'u' }; // var array, mutable
    var goku = EvenBetterUser{
        .id = 3,
        .power = 100,
        .name = new_name[0..], // name is a slice of `new_name`
    };
    mutateName(goku); // goku passed as value
    std.debug.print("{s}\n", .{goku.name}); // but goku is changed to go!u

    // this worked despite passing in goku as a value (therefore creating a copy) because the data we changed wasn't
    // a copy, but a copy of the address in goku that points to mutable data in our vat array

    // recrusive structures
    // we added an optional EvenBetterUser inside EvenBetterUser, called master
    const obi_wan = EvenBettererUser{
        .id = 4,
        .power = 9001,
        .master = null, // obi_wan has no master
    };

    const anakin = EvenBettererUser{
        .id = 5,
        .power = 9000,
        .master = &obi_wan, // anakin's master is obi_wan, passed in as a pointer
    };

    std.debug.print("{any}\n{any}\n", .{ obi_wan, anakin });
}

// levelUp() now takes a POINTER
// constant parameters helps prevent unitended behaviour, by default we PASS BY VALUE (COPY)
// but in some cases we want to PASS BY REFERENCE (POINT TO A MEMORY ADDRESS)
// typically it is cheaper to pass by value for samller types and more expensive for larger types
// so it may become desirable to pass by reference for the larger ones, but in some cases, such as
// this example we want to pass by reference to ensure our data is mutated, as we intended
fn levelUp(user: *User) void {
    user.power += 1;
    std.debug.print("{*}\n{*}\n", .{ &user, user }); // show the addresses of &user and user
    std.debug.print("{any}\n{any}\n", .{ @TypeOf(&user), @TypeOf(user) }); // pointer and pointer to a pointer
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

const EvenBetterUser = struct {
    name: []u8,
    id: u64,
    power: i32,
};

const EvenBettererUser = struct {
    id: u64,
    power: i32,
    master: ?*const EvenBettererUser, // optional EvenBetterUser
    // changed from ?const User ---> ?*const User, otherwise the compiler would error
    // as the number of recursions is unknown at comptime, a pointer's size is always
    // know because it is always the same size (usize ---> 8 bytes on a 64-bit platform)
};

fn mutateName(user: EvenBetterUser) void {
    user.name[2] = '!';
}
