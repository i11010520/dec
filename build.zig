const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();

    const dec_opts = b.addOptions();
    dec_opts.addOption([]const u8, "DECNUMDIGITS", "50");

    const dec_pkg: std.build.Pkg = .{
        .name = "dec",
        .source = .{ .path = "src/dec.zig" }, //getFileSource("src/dec.zig"),
        .dependencies = &[_]std.build.Pkg{
            dec_opts.getPackage("build_options"),
        },
    };

    const lib = b.addStaticLibrary("dec", "src/dec.zig");
    lib.setBuildMode(mode);
    lib.addIncludePath("src/decNumber/decNumber-icu-368/");
    lib.addCSourceFiles(&.{
            "src/decNumber/decNumber-icu-368/decContext.c",
            "src/decNumber/decNumber-icu-368/decNumber.c",
        }, &.{
            "-Wall",
            "-Wextra",
            "-O3",
        });
    lib.install();
    

    const unit_tests = b.addTest("test.zig");
    unit_tests.setBuildMode(mode);
    unit_tests.addPackage(dec_pkg);
    unit_tests.addIncludePath("src/decNumber/decNumber-icu-368");
    unit_tests.linkLibrary(lib);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&unit_tests.step);


}
