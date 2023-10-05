//! STACK MEMORY
// stackmem/main.zig

const std = @import("std");

// most Zig programs use three areas of memory:
// 1. global space, where program constants such as string literals are stored
// these are baked into the binary, known at comptime and immutable
// 2. stack memory,
// 3. heap memory, covered in heapmem/main.zig
