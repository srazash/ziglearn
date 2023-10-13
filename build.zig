// build.zig

const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // setup executable
    const exe = b.addExecutable(.{
        .name = "learning",
        .target = target,
        .optimize = optimize,
        .root_source_file = .{ .path = "learning.zig" },
    });
    b.installArtifact(exe);
}
