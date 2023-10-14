// build.zig

const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // local dependency
    //const calc_module = b.addModule("calc", .{
    //    .source_file = .{ .path = "./calc/calc.zig" },
    //});

    // remote dependency
    const calc_dep = b.dependency("calc", .{ .target = target, .optimize = optimize });
    const calc_module = calc_dep.module("calc");

    // build (install) executable
    const exe = b.addExecutable(.{
        .name = "learning",
        .target = target,
        .optimize = optimize,
        .root_source_file = .{ .path = "learning.zig" },
    });
    exe.addModule("calc", calc_module);
    b.installArtifact(exe);

    // run executable
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "start learning!");
    run_step.dependOn(&run_cmd.step);

    const tests = b.addTest(.{
        .target = target,
        .optimize = optimize,
        .root_source_file = .{ .path = "learning.zig" },
    });
    tests.addModule("calc", calc_module);

    const test_cmd = b.addRunArtifact(tests);
    test_cmd.step.dependOn(b.getInstallStep());
    const test_step = b.step("test", "start testing!");
    test_step.dependOn(&test_cmd.step);
}
