// main.zig
const std = @import("std");

const User = @import("models/user.zig").User;
const MAX_POWER = @import("models/user.zig").MAX_POWER;

pub fn main() void {
    // can be an anonymous struct because we provided the type
    const goku: User = .{
        .power = 9001,
        .name = "Goku",
    };

    // var type is inferred from the struct's type
    var ryan = User.init("Ryan", 1);

    std.debug.print("{s}'s power is {d}\n", .{ goku.name, goku.power });
    goku.diagnose();

    std.debug.print("{s}'s power is {d}\n", .{ ryan.name, ryan.power });
    ryan.diagnose();

    var a = [_]i32{ 1, 2, 3, 4, 5 }; // array
    const b = a[1..4]; // pointer
    var end: usize = 4; // end is not comptime know, so allows us to create a slice
    const c = a[1..end]; // slice

    std.debug.print("a is a {any} (array)\n", .{@TypeOf(a)});
    std.debug.print("b is a {any} (pointer)\n", .{@TypeOf(b)});
    std.debug.print("c is a {any} (slice)\n", .{@TypeOf(c)});

    c[2] = 99;

    // loops over each `ele` (element) in the `c` slice
    for (c) |ele| {
        std.debug.print("{d}\n", .{ele});
    }

    // an array of 3 booleans with false as the sentinel value
    const d = [3:false]bool{ false, true, false };
    std.debug.print("{any}\n", .{std.mem.asBytes(&d).*});

    // *** comptime
    // var i = 0; would throw a comptim error as the type is unknown
    // const i = 0; would be fine as a const is known at comptime
    const ck1 = 100; // compiler infers this is acomptime_int
    const ck2 = 1.0; // compuiler infers this is a comptime_float
    std.debug.print("{any} is a {any}.\n", .{ ck1, @TypeOf(ck1) });
    std.debug.print("{any} is a {any}.\n", .{ ck2, @TypeOf(ck2) });

    // *** control flow
    // Zig uses the `and` and `or` keyword in place of `&&` and `||` coomon is other languages
    const yes: bool = true;
    const no: bool = false;

    // standard if/else if/else statement
    if (yes == true and no == true) {
        std.debug.print("yes and no are both true\n", .{}); // won't print, both statements aren't true
    } else if (yes == false or no == false) {
        std.debug.print("yes or no are false\n", .{}); // will print, one of the statements is true
    } else {
        std.debug.print("something else\n", .{});
    }

    // `==` is used to check equality EXCEPT for strings/arrays/slices
    const num1: i32 = 100;
    const num2: i32 = 100;
    const numeq: bool = if (num1 == num2) true else false; // Zig lacks a ternary operator but we can use an if expression
    std.debug.print("{d} == {d} : {any}\n", .{ num1, num2, numeq });

    // `std.mem.eql` compares length THEN compares byte by byte
    const str1 = "Hammers";
    const str2 = "Anvils";
    const str3 = "Hammerz";
    const str4 = "Anvils";

    std.debug.print("String data type: {any}\n", .{@TypeOf(str1)});

    const streq1: bool = std.mem.eql(u8, str1, str2); // false here is returned because the length is different
    std.debug.print("{s} == {s} : {any}\n", .{ str1, str2, streq1 });

    const streq2: bool = std.mem.eql(u8, str1, str3); // false here is returned because the last byte is different
    std.debug.print("{s} == {s} : {any}\n", .{ str1, str3, streq2 });

    const streq3: bool = std.mem.eql(u8, str2, str4); // true is returned here because the length and all bytes match
    std.debug.print("{s} == {s} : {any}\n", .{ str2, str4, streq3 });

    // this also applies to arrays/slices
    const arr1 = [_]u32{ 2, 4, 6, 8, 10 };
    const arr2 = [_]u32{ 2, 4, 6, 8, 10 };

    const arreq: bool = std.mem.eql(u32, &arr1, &arr2); // true is returned here because length and all bytes match
    // we need to pass in the ADDRESS of the arrays here (this is what the `&` symbol is for), this is different to the string,
    // this is because a string is a slice, which is already an address to an array (or a section of an array)
    std.debug.print("Do my arrays match? {any}\n", .{arreq});

    // NOTE: std.mem.eql is a generic function, hence why it's first argument is the type being compared
    // std.ascii.eqlIgnoreCase can be used to compare strings but ignore differences in case

    // switch statements are similar to if/else if/else statements but are far more ehaustive
    // a comptime error will occur if all cases are not covered
    const swin1: u16 = 3;
    const swout1 = switch (swin1) {
        1 => "one",
        2 => "two",
        3 => "three",
        else => "more than three!", // else case covers all possible values of the u16 (4-65535) noth covered by any other case
    };

    std.debug.print("(1) Switch input: {d}, Switch output: {s}\n", .{ swin1, swout1 });

    // multiple cases can be combined, ranges can be used, and cases can contain blocks (useful in functions)
    const swin2: u16 = 7;
    const swout2 = switch (swin2) {
        0 => "too small",
        2, 4, 6, 8, 10 => "even",
        1, 3, 5, 7, 9 => "odd",
        11...999 => "too big",
        else => "waaay too big!",
    };

    // NOTE: switches are very powerful when paired with enums

    std.debug.print("(2) Switch input: {d}, Switch output: {s}\n", .{ swin2, swout2 });

    // for loops are used to iterate over arrays, slices and ranges
    const haystack = [_]u32{ 1, 5, 7, 11, 14 };
    const needle: u32 = 7;
    var needleFound: bool = false;

    for (haystack) |value| {
        if (value == needle) needleFound = true;
    }

    std.debug.print("The needle {s} been found.\n", .{if (needleFound == true) "has" else "has not"});

    // for loops can work on multiple sequences at one as long as they are of equal length
    const seq1 = [_]u32{ 1, 2, 3, 4, 5, 5, 7, 8 };
    const seq2 = [_]u32{ 1, 2, 3, 4, 5, 6, 7, 8 };
    var seqMatch: bool = true;

    // we need to check the arrays are of equal length before entering the for loop or a runtime error
    // may occur if they are not -- NO COMPTIME CHECK HERE! Ths is very similar to how std.mem.eql works
    // checking length first, then performing a byte by byte comparison if the length does match
    if (seq1.len != seq2.len) {
        seqMatch = false;
    } else {
        for (seq1, seq2) |ele1, ele2| {
            if (ele1 != ele2) seqMatch = false;
        }
    }

    std.debug.print("The sequences {s} match.\n", .{if (seqMatch == true) "do" else "do not"});

    // looping over a range
    var total: usize = 0;

    // for ranges (x..y) are upper bound exclusive
    // switch ranges (a...b) are upper bound inclusive
    // keep this difference in mind!
    for (1..10) |i| {
        total += i; // 1+2+3+4+5+6+7+8+9, 10 is the upper bound but excluded
    }

    std.debug.print("The total is {d}.\n", .{total});

    // we can combine ranges with sequences to keep track of the index
    // here the upper bound is inferred from the length of the sequence
    for (haystack, 0..) |value, i| {
        if (value == needle) {
            std.debug.print("Needle found at index: {d}\n", .{i});
            break;
        }
        std.debug.print("Checked index: {d}, needle not found\n", .{i});
    }

    // *** WHILE LOOPS
    // for loops in zig differ from their typical init>compare>step form in other languages, instead
    // zig's while loops do provide functionality closer to this than it's for loops, as well as
    // providing finer control over iteration
    var idx: usize = 0;
    var escapeCount: usize = 0;

    const src = "This \tstring contains\nthree\\3 escape sequences.";

    while (idx < src.len) {
        if (src[idx] == '\\') {
            idx += 2; // here we increment the index by 2 to include both backslashes
            escapeCount += 1;
        } else if (src[idx] == '\t' or src[idx] == '\n') {
            idx += 1;
            escapeCount += 1;
        } else {
            idx += 1;
        }
    }

    std.debug.print("(WHILE) Text contains {d} escape sequences\n", .{escapeCount});

    // zig's while loops can also have a continue expression, which functions like
    // a for loop's step expressions in other languages, repeating the same example as above
    idx = 0;
    escapeCount = 0;

    while (idx < src.len) : (idx += 1) {
        if (src[idx] == '\\') {
            idx += 1; // +1 here and +1 in the continue expression
            escapeCount += 1;
        } else if (src[idx] == '\t' or src[idx] == '\n') {
            // the increment here is gone
            escapeCount += 1;
        } // wo no longer need the else
    }

    std.debug.print("(WHILE+CONT) Text contains {d} escape sequences\n", .{escapeCount});

    // break and continue keywords can be used to break out of a loop or to continue
    // to the next iteration, they can also be used with LABELS
    outer: for (1..10) |i| { // `outer:` is the label, labels end with a colon
        for (i..10) |j| {
            if (i * j > (i + i + j + j)) continue :outer; // labels are called starting with a colon
            std.debug.print("{d} + {d} >= {d} * {d}\n", .{ i + i, j + j, i, j });
        }
    }

    // break can be used to return a value from a block when using a label
    const teaVote: u32 = 7;
    const coffeeVote: u32 = 8;

    const teaOrCoffee = drink: {
        if (teaVote > coffeeVote) break :drink "Time for tea!";
        if (coffeeVote > teaVote) break :drink "It's coffee time!";
        if (teaVote == coffeeVote) break :drink "It's a tie!";
    };

    std.debug.print("{s}\n", .{teaOrCoffee});

    // *** ENUMS
    // enums are integers constants given a label, they are declared like a stuct

    // could be `pub`
    const Status = enum {
        great,
        ok,
        mediocre,
        bad,
        awful,
    };

    const starWarsSequels = Status.awful; // type infered from enum

    // use the `@tagName()` builtin to access the string representation of the enum value
    std.debug.print("The Star Wars sequels were {s}\n", .{@tagName(starWarsSequels)});

    // REFER TO `PUB CONST STAGE = ENUM {...}` BELOW!

    const projectProgress = Stage.planning; // type infered from enum

    std.debug.print("Is the project complete? : {any}\n", .{projectProgress.isComplete()});
}

// like structs, enums can contain other definitions including functions
pub const Stage = enum {
    planning,
    starting,
    in_progress,
    complete,
    issue,

    fn isComplete(self: Stage) bool {
        return self == Stage.complete;
    }
};
