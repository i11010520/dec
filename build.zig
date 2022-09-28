const std = @import("std");

fn pkgPath(comptime ppath: []const u8) std.build.FileSource {
    const ppath_full = comptime std.fs.path.dirname(@src().file).? ++ std.fs.path.sep_str ++ ppath;
    return .{ .path = ppath_full };
}

const dec_pkg: std.build.Pkg = .{
    .name = "dec",
    .source = pkgPath("src/dec.zig"),
};


pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("demo-c", null);
    exe.setBuildMode(mode);
    exe.addCSourceFiles(&.{
        "demo.c",
        "src/decNumber/decNumber-icu-368/decContext.c",
        "src/decNumber/decNumber-icu-368/decNumber.c",
    }, &.{
        "-Wall",
        "-Wextra",
        "-O3",
    });
    exe.install();

    const lib = b.addStaticLibrary("dec", "src/dec.zig");
    lib.setBuildMode(mode);
    lib.addCSourceFiles(&.{
            "src/decNumber/decNumber-icu-368/decContext.c",
            "src/decNumber/decNumber-icu-368/decNumber.c",
            "src/decContext.patch.c",
            "src/decNumber.patch.c",
        }, &.{
            "-Wall",
            "-Wextra",
            "-O3",
        });
    // lib.addIncludePath("");
    lib.install();

    const demo = b.addExecutable("demo-zig", "demo.zig");
    demo.setBuildMode(mode);
    demo.addPackage(dec_pkg);
    //// addObjectFile or linkLibrary
    // demo.addObjectFile("zig-out/lib/libdec.a");
    // demo.step.dependOn(&lib.step);
    demo.linkLibrary(lib);
    demo.install();

    const main_tests = b.addTest("test.zig");
    main_tests.setBuildMode(mode);
    main_tests.addPackage(dec_pkg);
    main_tests.addObjectFile("zig-out/lib/libdec.a");
    main_tests.step.dependOn(b.getInstallStep());

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);


}
