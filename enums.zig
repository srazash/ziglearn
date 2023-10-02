//! ENUMS
// enums.zig

// like structs, enums can contain other definitions including functions
pub const Stage = enum {
    planning,
    starting,
    in_progress,
    complete,
    issue,

    pub fn isComplete(self: Stage) bool {
        return self == Stage.complete;
    }
};
